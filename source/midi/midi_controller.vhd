-------------------------------------------------------------------------------
-- Title      : midi_controller
-- Project    : 
-------------------------------------------------------------------------------
-- File       : midi_controller.vhd
-- Author     :   <kneubste>
-- Company    : 
-- Created    : 2020-04-20
-- Last update: 2020-05-09
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: This block contains the midi_controller for sythi_project
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-04-20  1.0      kneubste        Created
-------------------------------------------------------------------------------

-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tone_gen_pkg.all;

-- Entity Declaration 
-------------------------------------------

entity midi_controller is

  port (clk_12m         : in  std_logic;
        reset_n         : in  std_logic;
        rx_data_rdy     : in  std_logic;
        rx_data         : in  std_logic_vector(7 downto 0);
        note_on         : out std_logic;
        note_simple     : out std_logic_vector(6 downto 0);
        velocity_simple : out std_logic_vector(6 downto 0)

        );

end entity midi_controller;

-- Architecture Declaration
-------------------------------------------
architecture rtl of midi_controller is
-- Signals & Constants Declaration
-------------------------------------------

  type fsm_states is (st_wait, st_wait_data1, st_wait_data2);
  signal fsm_state                : fsm_states;
  signal next_fsm_state           : fsm_states;
  signal new_data_flag            : std_logic;
  signal note_on_sig              : note_array;
  signal next_note_on_sig         : note_array;
  signal note_simple_sig          : t_tone_array;
  signal next_note_simple_sig     : t_tone_array;
  signal velocity_simple_sig      : t_tone_array;
  signal next_velocity_simple_sig : t_tone_array;
  signal status_reg               : status_array;
  signal data1_reg, data2_reg     : std_logic_vector(6 downto 0);

-- Begin Architecture
-------------------------------------------
begin

  --------------------------------------------------
  -- PROCESS FOR ALL FLIP-FLOPS
  --------------------------------------------------
  flip_flops : process(all)
  begin
    if reset_n = '0' then
      fsm_state           <= st_wait;
      note_on_sig         <= (others => '0');
      note_simple_sig     <= (others => (others => '0'));
      velocity_simple_sig <= (others => (others => '0'));
      new_data_flag       <= '0';
		status_reg			  <= (others => (others => '0'));
		data1_reg			  <= (others => '0');
		data2_reg			  <= (others => '0');

    elsif rising_edge(clk_12m) then
      fsm_state           <= next_fsm_state;
      note_on_sig         <= next_note_on_sig;
      note_simple_sig     <= next_note_simple_sig;
      velocity_simple_sig <= next_velocity_simple_sig;

    end if;
  end process flip_flops;


  --------------------------------------------------
  -- PROCESS FOR OUTPUT-COMB-LOGIC MIDI-FSM 
  --------------------------------------------------
  state_logic : process (all)
  begin
    -- default statements (hold current value)
    next_fsm_state <= fsm_state;


    --------------------------------------------------

    case fsm_state is

      when st_wait =>

        if rx_data_rdy = '0' then
          next_fsm_state <= st_wait;
        elsif
          rx_data(7) = '1' then
          next_fsm_state <= st_wait_data1;
        elsif
          rx_data(7) = '0' then
          next_fsm_state <= st_wait_data2;
        end if;

      when st_wait_data1 =>

        if rx_data_rdy = '0' then
          next_fsm_state <= st_wait_data1;
        else
          next_fsm_state <= st_wait_data2;
        end if;

      when st_wait_data2 =>

        if rx_data_rdy = '0' then
          next_fsm_state <= st_wait_data2;
        else
          new_data_flag  <= '1';
          next_fsm_state <= st_wait;
        end if;

      when others =>
        next_fsm_state <= st_wait;

    end case;

  end process state_logic;


  --------------------------------------------------
  -- PROCESS FOR OUTPUT-COMB-LOGIC
  --------------------------------------------------
  fsm_output_logic : process (all)

  begin

    next_note_on_sig         <= note_on_sig;
    next_note_simple_sig     <= note_simple_sig;
    next_velocity_simple_sig <= velocity_simple_sig;

    case fsm_state is
      when st_wait =>
        if rx_data_rdy = '1' then
          if rx_data(7) = '1' then
            next_note_on_sig(0) <= rx_data(4);
          elsif rx_data(7) = '0' then
            next_note_simple_sig(0) <= rx_data(6 downto 0);
          end if;
        end if;
      when st_Wait_data1 =>
        if rx_data_rdy = '1' then
          next_note_simple_sig(0) <= rx_data(6 downto 0);
        end if;
      when st_Wait_data2 =>
        if rx_data_rdy = '1' then
          next_velocity_simple_sig(0) <= rx_data(6 downto 0);

          -- Falls Taste velocity = 0 anstatt tone off sendet
          if rx_data = "00000000" then
            next_note_on_sig(0) <= '0';
          end if;
        end if;
      when others =>


    end case;

  end process fsm_output_logic;


  --------------------------------------------------
  -- PROCESS FOR MIDI-ARRAY_LOGIC
  --------------------------------------------------


  midi_array_logic : process (all)

    variable note_available : std_logic := '0';
    variable note_written   : std_logic := '0';

  begin
    --default statements
    if new_data_flag = '1' then
      note_available := '0';
    end if;

    ------------------------------------------------------
    -- CHECK IF NOTE IS ALREADY ENTERED IN MIDI ARRAY
    ------------------------------------------------------ 
    for i in 0 to 9 loop
      if note_simple_sig(i) = data1_reg and note_on_sig(i) = '1' then  -- Found a matching note
        note_available := '1';
        if status_reg(4) = "0" then --note off
          next_note_on_sig(i) <= '0';  -- turn off note
        elsif status_reg(4) = "1" and data2_reg = "00000000" then
          next_note_on_sig(i) <= '0';   -- turn off note if velocity is 0 
        end if;
      end if;
    end loop;


    -----------------------------------------
    -- ENTER A NEW NOTE IF STILL EMPTY REGISTERS
    ------------------------------------------
    -- If the new note is not in the midi storage array yet, find a free space 
    -- if the valid flag is cleared, the note can be overwritten, at the same time a flag is set to mark that
    -- the new note has found a place.

    if note_available = '0' then  -- If there is not yet an entry for the note, look for an empty space and write it

      for i in 0 to 9 loop
        if note_written = '0' then  -- if the note already written, ignore the remaining loop runs

          -- If a free space is found, enter the note number and velocity
          -- or if until the end of the loop no space is found overwrite last entry
		IF (note_on_sig(i) = '0' OR i = 9)  AND status_reg(4) = "1" 
			then 																		-- bit 4 is note_on bit
				next_note_simple_sig(i) <= data1_reg;
				next_velocity_simple_sig(i) <= data2_reg;
				next_note_on_sig(i)         <= '1';  -- And set the note_1_register to valid.
				note_written                := '1';  -- flag that note is written to supress remaining loop runs
          end if;
        end if;
      end loop;
    end if;

	END PROCESS midi_array_logic;
	
	
  --------------------------------------------------
  -- Output-Zuweisungen
  --------------------------------------------------

  note_on         <= note_on_sig(0);
  note_simple     <= note_simple_sig(0);
  velocity_simple <= velocity_simple_sig(0);
  --------------------------------------------------

-- End Architecture 
------------------------------------------- 
  end rtl;
