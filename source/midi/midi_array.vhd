
-------------------------------------------------------------------------------
-- Title      : midi_array
-- Project    : 
-------------------------------------------------------------------------------
-- File       : midi_array.vhd
-- Author     :   <lussimat>
-- Company    : 
-- Created    : 2020-04-20
-- Last update: 2020-05-17
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: thie building block assignes velocity, note_on and the note 
--              itself to one of the ten dds
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-05-06  1.0      lussimat        Created
-- 2020-05-17  1.1      kneubste | Project-Contrl. & Beautify.
-------------------------------------------------------------------------------

-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tone_gen_pkg.all;

-- Entity Declaration 
-------------------------------------------

entity midi_array is

  port (clk_12m               : in  std_logic;
        reset_n               : in  std_logic;
        status_reg            : in  std_logic;
        data1_reg             : in  std_logic_vector(6 downto 0);
        data2_reg             : in  std_logic_vector(6 downto 0);
        new_data_flag         : in  std_logic;
		  rst_flag_i				: in  std_logic;
        reg_note_on_o         : out note_on_array;
        reg_note_simple_o     : out t_tone_array;
        reg_velocity_simple_o : out t_tone_array
        );

end entity midi_array;

-- Architecture Declaration
-------------------------------------------
architecture rtl of midi_array is
-- Signals & Constants Declaration
-------------------------------------------

  signal reg_note_on, next_reg_note_on   : note_on_array;
  signal reg_note, next_reg_note         : t_tone_array;
  signal reg_velocity, next_reg_velocity : t_tone_array;

-- Begin Architecture
-------------------------------------------
begin

  --------------------------------------------------
  -- PROCESS FOR all FLIP-FLOPs
  --------------------------------------------------

  flip_flops : process (all)

  begin

    if reset_n = '0' then
      reg_note_on  <= (others => '0');
      reg_velocity <= (others => (others => '0'));
      reg_note     <= (others => (others => '0'));

    elsif rising_edge(clk_12m) then
      reg_note_on  <= next_reg_note_on;
      reg_velocity <= next_reg_velocity;
      reg_note     <= next_reg_note;

    end if;

  end process flip_flops;

  --------------------------------------------------
  -- PROCESS FOR MIDI-ARRAY_LOGIC
  --------------------------------------------------

  midi_array_logic : process (all)

    variable note_available : std_logic := '0';  --wenn Ton bereits gespielt wird (dann = 1) => im Array bereits verzeichnet
    variable note_written   : std_logic := '0';  --wenn Ton gerade eingetragen wurde (dann 1) => verhindert unnoetige loops

  begin

    ------------------------------------------------------
    --default statements
    ------------------------------------------------------
    if new_data_flag = '1' then  --erhaelt status (etwas wird geloescht oder geschrieben) 
      note_available := '0';
      note_written   := '0';
    else
      note_available := '1';
      note_written   := '1';
    end if;

    next_reg_note_on  <= reg_note_on;
    next_reg_velocity <= reg_velocity;
    next_reg_note     <= reg_note;
	 
	 ------------------------------------------------------
	 -- RESET AFTER SWITCH 5 (PLAY) GOES '0'
	 ------------------------------------------------------
	 
	 if rst_flag_i = '1' then
		for i in 0 to 9 loop
			next_reg_note_on(i) <= '0';
		end loop;
	 end if;

    ------------------------------------------------------
    -- CHECK IF NOTE IS ALREADY ENTERED IN MIDI ARRAY
    ------------------------------------------------------ 
    for i in 0 to 9 loop
      if (reg_note(i) = data1_reg and reg_note_on(i) = '1') and note_written = '0' then  -- Found a matching note (spielt bereits)
        note_available := '1';

        if status_reg = '0' then        --note off
          next_reg_note_on(i) <= '0';   -- turn off note
        elsif status_reg = '1' and data2_reg = "0000000" then
          next_reg_note_on(i) <= '0';   -- turn off note if velocity is 0 
        end if;

      else
        note_available := '0';
      end if;
    end loop;


    ------------------------------------------------------
    -- ENTER A NEW NOTE IF STILL EMPTY REGISTERS
    ------------------------------------------------------
    -- If the new note is not in the midi storage array yet, find a free space 
    -- if the valid flag is cleared, the note can be overwritten, at the same time a flag is set to mark that
    -- the new note has found a place.

    if note_available = '0' then  -- If there is not yet an entry for the note, look for an empty space and write it

      for i in 0 to 9 loop
        if note_written = '0' then  -- if the note already written, ignore the remaining loop runs

          -- If a free space is found, enter the note number and velocity
          -- or if until the end of the loop no space is found overwrite last entry
          if (reg_note_on(i) = '0' or i = 9) and status_reg = '1' then  -- bit 4 is note_on bit
            next_reg_note(i)     <= data1_reg;
            next_reg_velocity(i) <= data2_reg;
            next_reg_note_on(i)  <= '1';  -- And set the note_1_register to valid.
            note_written         := '1';  -- flag that note is written to supress remaining loop runs
          else
            note_written := '0';
          end if;
        else
          note_written := '1';
        end if;
      end loop;
    else
      note_written := '0';
    end if;

  end process midi_array_logic;

  -----------------------------------------------
  -- Output
  -----------------------------------------------

  reg_note_on_o         <= reg_note_on;
  reg_note_simple_o     <= reg_note;
  reg_velocity_simple_o <= reg_velocity;

end rtl;
