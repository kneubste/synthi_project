-------------------------------------------------------------------------------
-- Title      : midi_sequenzer
-- Project    : 
-------------------------------------------------------------------------------
-- File       : midi_sequenzer.vhd
-- Author     :   <lussimat>
-- Company    : 
-- Created    : 2020-04-20
-- Last update: 2020-05-15
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: This block contains the midi_sequenzer for sythi_project
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-04-20  1.0      lussimat        Created
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
        note_i         : in  std_logic_vector(7 downto 0);
        velocity_i     : in  std_logic_vector(7 downto 0);
        write_enable_i : in  std_logic;  --wie lange wird die note gespielt
        play_i         : in  std_logic;  --Schalter
        record_i       : in  std_logic;  --Schalter
        note_o         : out std_logic_vector(7 downto 0);
        velocity_o     : out std_logic_vector(7 downto 0);
        note_pulse     : out std_logic_vector(7 downto 0) --note ein oder aus
        );

end entity midi_sequenzer;

-- Architecture Declaration
-------------------------------------------
architecture rtl of midi_sequenzer is
-- Signals & Constants Declaration
-------------------------------------------

  type fsm_states is (st_wait, st_record, st_play);
  signal fsm_state, next_fsm_state       : fsm_states;
  signal note_ram, velocity_ram          : NOTE_VELOCITY_RAM_TYPE := (others => (others => '0'));
  signal timer_ram                       : TIMER_RAM_TYPE         := (others => (others => '0'));
  signal counter_time, next_counter_time : unsigned(31 downto 0);
  signal counter_row, next_counter_row   : unsigned((sequenz-1) downto 0);  --soll die Anzahl Zeilen durchgehen
  signal note_sig, next_note_sig         : std_logic_vector(7 downto 0);
  signal velocity_sig, next_velocity_sig : std_logic_vector(7 downto 0);
  signal note_pulse_sig, next_note_pulse_sig : std_logic_vector(7 downto 0);

-- Begin Architecture
-------------------------------------------
begin

  --------------------------------------------------
  -- PROCESS FOR ALL FLIP-FLOPS
  --------------------------------------------------
  flip_flops : process(all)
  begin
    if reset_n = '0' then
      counter_time <= (others => '0');
      counter_row  <= (others => '0');
      note_sig     <= (others => '0');
      velocity_sig <= (others => '0');
      fsm_state    <= st_wait;
		note_pulse_sig <= (others => '0');

    elsif rising_edge(clk_12m) then
      counter_time <= next_counter_time;
      counter_row  <= next_counter_row;
      fsm_state    <= next_fsm_state;
      note_sig     <= next_note_sig;
      velocity_sig <= next_velocity_sig;
		note_pulse_sig <= next_note_pulse_sig;

    end if;
  end process flip_flops;


  --------------------------------------------------
  -- PROCESS FOR OUTPUT-COMB-LOGIC MIDI-FSM 
  --------------------------------------------------
  state_logic : process (all)
  begin

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

  next_counter_row  <= counter_row;
  next_counter_time <= counter_time;
  next_note_sig     <= note_sig;
  next_velocity_sig <= velocity_sig;
  next_note_pulse_sig <= note_pulse_sig;

  case fsm_state is

    when st_wait =>

      --record nach play und umgekehrt sind über st_wait verbunden deshalb hier default state
      next_counter_row  <= to_unsigned(0, sequenz);
      next_counter_time <= to_unsigned(0, 32);

    when st_record =>

      next_counter_time <= next_counter_time + 1;  --Zeit beginnt zu zählen

      if write_enable_i = '1' then

        if ((counter_time xor to_unsigned(0, 32)) > counter_time) then  --32 bit erreicht?

          note_ram(to_integer(counter_row))     <= note_i;  --note wird in Zeile gespeichert
          velocity_ram(to_integer(counter_row)) <= velocity_i;  --dazugehörige velocity wird in gleicher Zeile (anderes Array) gespeichert
          timer_ram(to_integer(counter_row))    <= std_logic_vector(unsigned(counter_time));  --die Zeit, bei welcher der Ton spielt oder verstummt wird in gleiche Zeile gespeichert
          next_counter_row                      <= next_counter_row + 1;  --Zeilen werden raufgezählt

        else

          -- led leuchten lassen oder so

        end if;
      end if;

    when st_play =>

      if timer_ram(to_integer(counter_row)) = std_logic_vector(unsigned(counter_time)) then

        next_note_sig     <= note_ram(to_integer(counter_row));  --note wird ausgegeben
        next_velocity_sig <= velocity_ram(to_integer(counter_row));  --dazugehörige velocity wird mitausgegeben
        next_counter_row  <= next_counter_row + 1;  --nächste note/Zeile wird im nächste Durchlauf angeschaut 

		 if next_velocity_sig = std_logic_vector(to_unsigned(0, 8)) then --ist velocity 0?
			next_note_pulse_sig <= std_logic_vector(to_unsigned(128, 8)); --Ja: note off status
		 else
			next_note_pulse_sig <= std_logic_vector(to_unsigned(144, 8)); --nein: note on status
		 end if;
		 
      end if;

      next_counter_time <= next_counter_time + 1;

    when others =>
	 
      fsm_state <= st_wait;

  end case;

end process fsm_logic;

--------------------------------------------------
-- Output
--------------------------------------------------

note_o     <= note_sig;
velocity_o <= velocity_sig;
note_pulse <= note_pulse_sig;


end rtl;
