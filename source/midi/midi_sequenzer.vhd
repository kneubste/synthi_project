-------------------------------------------------------------------------------
-- Title      : midi_sequenzer
-- Project    : synthi_project
-------------------------------------------------------------------------------
-- File       : midi_sequenzer.vhd
-- Author     :   <lussimat>
-- Company    : 
-- Created    : 2020-04-20
-- Last update: 2020-05-17
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: This building block is responsible to record and replay the recorded
--              sequence.
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date:       | Version:   | Author:   | Description:
-- 2020-04-20  | 1.0        | lussimat  | Created & commented
-- 2020-04-22  | 1.1	    | lussimat  | Improvment: incrementation counter
-- 2020-05-17  | 1.2        | lussimat  | Array increased (to 100)
-- 2020-05-28  | 1.3        | kneubste  | Project-Contrl. & Beautify.
-------------------------------------------------------------------------------

-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tone_gen_pkg.all;

-- Entity Declaration 
-------------------------------------------

entity midi_sequenzer is
  port (clk_12m        : in  std_logic;
        reset_n        : in  std_logic;
        note_i         : in  std_logic_vector(6 downto 0);  --note_signal otput von midi_controller
        velocity_i     : in  std_logic_vector(6 downto 0);  --velocity_Signal output von midi_controller
        write_enable_i : in  std_logic;  -- How long the note plays
        play_i         : in  std_logic;  --Switch 5
        record_i       : in  std_logic;  --Switch 4
        note_o         : out std_logic_vector(6 downto 0);
        velocity_o     : out std_logic_vector(6 downto 0);
        note_pulse     : out std_logic;  --note on or off
        flag_out       : out std_logic;
		  reset_o 		  : out std_logic
        );

end entity midi_sequenzer;

-- Architecture Declaration
-------------------------------------------
architecture rtl of midi_sequenzer is
-- Signals & Constants Declaration
-------------------------------------------

  type fsm_states is (st_wait, st_record, st_play);
  signal fsm_state, next_fsm_state           : fsm_states;
  signal note_ram, next_note_ram             : NOTE_VELOCITY_RAM_TYPE;
  signal velocity_ram, next_velocity_ram     : NOTE_VELOCITY_RAM_TYPE;
  signal timer_ram, next_timer_ram           : TIMER_RAM_TYPE;
  signal counter_time, next_counter_time     : unsigned(SEQUENZ-1 downto 0);  --counts time (SEQUENZ: 32)
  signal counter_row, next_counter_row       : unsigned(SEQUENZ-1 downto 0);  --serves as column-/row-index
  signal note_sig, next_note_sig             : std_logic_vector(6 downto 0);
  signal velocity_sig, next_velocity_sig     : std_logic_vector(6 downto 0);
  signal note_pulse_sig, next_note_pulse_sig : std_logic;
  signal flag_sig, next_flag_sig             : std_logic;

-- Begin Architecture
-------------------------------------------
begin

  --------------------------------------------------
  -- PROCESS FOR ALL FLIP-FLOPS
  --------------------------------------------------
  flip_flops : process(all)
  begin
    if reset_n = '0' then
      counter_time   <= (others => '0');
      counter_row    <= (others => '0');
      note_sig       <= (others => '0');
      velocity_sig   <= (others => '0');
      fsm_state      <= st_wait;
      note_pulse_sig <= '0';
      flag_sig       <= '0';
      velocity_ram   <= (others => (others => '0'));
      timer_ram      <= (others => (others => '0'));
      note_ram       <= (others => (others => '0'));

    elsif rising_edge(clk_12m) then
      counter_time   <= next_counter_time;
      counter_row    <= next_counter_row;
      fsm_state      <= next_fsm_state;
      note_sig       <= next_note_sig;
      velocity_sig   <= next_velocity_sig;
      note_pulse_sig <= next_note_pulse_sig;
      note_ram       <= next_note_ram;
      timer_ram      <= next_timer_ram;
      velocity_ram   <= next_velocity_ram;
      flag_sig       <= next_flag_sig;

    end if;
  end process flip_flops;


  --------------------------------------------------
  -- PROCESS FOR OUTPUT-COMB-LOGIC MIDI-FSM 
  --------------------------------------------------
  state_logic : process (all)
  begin

  --default case
  	 reset_o <= '0';
		  
    case fsm_state is

      when st_wait =>
		
        if record_i = '1' then
          next_fsm_state <= st_record;
        elsif play_i = '1' then
          next_fsm_state <= st_play;
        else
          next_fsm_state <= fsm_state;
        end if;

      when st_record =>

        if record_i = '0' then
          next_fsm_state <= st_wait;
        else
          next_fsm_state <= fsm_state;
        end if;

      when st_play =>

        if play_i = '0' then
          next_fsm_state <= st_wait;
			 reset_o        <= '1';
        else
          next_fsm_state <= fsm_state;
        end if;

      when others =>
        next_fsm_state <= st_wait;

    end case;

  end process state_logic;

--------------------------------------------------
-- PROCESS FOR FSM-COMB-LOGIC
--------------------------------------------------
  fsm_logic : process (all)

  begin

	 --default cases
    next_counter_row    <= counter_row;
    next_counter_time   <= counter_time;
    next_note_sig       <= note_sig;
    next_velocity_sig   <= velocity_sig;
    next_note_pulse_sig <= note_pulse_sig;
    next_note_ram       <= note_ram;
    next_velocity_ram   <= velocity_ram;
    next_timer_ram      <= timer_ram;
    next_flag_sig       <= flag_sig;

    case fsm_state is

      when st_wait =>

        --record after play and vice versa are connected over st_wait therefore here defualt state
        next_counter_row  <= to_unsigned(0, SEQUENZ);
        next_counter_time <= to_unsigned(0, SEQUENZ);

      when st_record =>

        next_counter_time <= counter_time + 1;  --Time begins to count

        if write_enable_i = '1' then

          if (not(to_unsigned(0, SEQUENZ)) > counter_time) then  --32 bit reached

            next_note_ram(to_integer(counter_row))     <= note_i;  --note gets saved into row
            next_velocity_ram(to_integer(counter_row)) <= velocity_i;  --corresponding velocity gets saved into same row in another array
            next_timer_ram(to_integer(counter_row))    <= std_logic_vector(counter_time);  --start or stop time gets saved into same row
            next_counter_row                           <= counter_row + 1;  -- increasing row count

          else

            -- Possibility of led signal or similar.

          end if;
        end if;

      when st_play =>

        if timer_ram(to_integer(counter_row)) = std_logic_vector(counter_time) then

          next_counter_row  <= counter_row + 1;  -- next note/ row observed in next run.
          next_flag_sig     <= '1';
          next_note_sig     <= note_ram(to_integer(counter_row));  --output note 
          next_velocity_sig <= velocity_ram(to_integer(counter_row));  --output velocity

          if next_velocity_sig = std_logic_vector(to_unsigned(0, 7)) then  --velocity 0?
            next_note_pulse_sig <= '0';
          else
            next_note_pulse_sig <= '1';  --if no: note on status
          end if;

        else

          next_flag_sig <= '0';

        end if;

        next_counter_time <= counter_time + 1;

      when others =>

    end case;

  end process fsm_logic;

--------------------------------------------------
-- Output
--------------------------------------------------

  note_o     <= note_sig;
  velocity_o <= velocity_sig;
  note_pulse <= note_pulse_sig;
  flag_out   <= flag_sig;


end rtl;
