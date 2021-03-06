-------------------------------------------------------------------------------
-- Title      : midi_controller
-- Project    : synthi_project
-------------------------------------------------------------------------------
-- File       : midi_controller.vhd
-- Author     :   <kneubste>
-- Company    : 
-- Created    : 2020-05-11
-- Last update: 2020-05-17
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Enthaelt den mode_switch-Block fuer den Tone_generator.
--              Umschaltung zwischen Midi-Controller und Melody-Box.
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-05-11  1.0      kneubste   Created
-- 2020-05-11  1.1      lussimat   Changes for 10 DDS
-- 2020-05-17  1.1      kneubste   Project-Contrl. & Beautify.
-------------------------------------------------------------------------------

-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Entity Declaration 
-------------------------------------------

entity mode_switch is

  port (mode                      : in  std_logic;  -- Wahl Betriebsart
        note_on_midi              : in  std_logic;  -- Signal von Midi_controller
        note_simple_midi          : in  std_logic_vector(6 downto 0);  -- Signal von Midi_controller
        flag_midi                 : in  std_logic;
        velocity_simple_midi      : in  std_logic_vector(6 downto 0);  -- Signal von Midi_controller
        note_on_sequenzer         : in  std_logic;  -- Signal von Melody_box
        note_simple_sequenzer     : in  std_logic_vector(6 downto 0);  -- Signal von Melody_box
        velocity_simple_sequenzer : in  std_logic_vector(6 downto 0);  -- Signal von Melody_box
        flag_sequenzer            : in  std_logic;
        note_on                   : out std_logic;  -- Signal ton_gen
        note_simple               : out std_logic_vector(6 downto 0);  -- Signal ton_gen
        velocity_simple           : out std_logic_vector(6 downto 0);  -- Signal ton_gen
        flag_out                  : out std_logic
        );

end entity mode_switch;

-- Architecture Declaration
-------------------------------------------
architecture rtl of mode_switch is
-- Signals & Constants Declaration
-------------------------------------------


-- Begin Architecture
-------------------------------------------
begin
-- default statements

  --------------------------------------------------
  -- PROCESS FOR OUTPUT
  --------------------------------------------------
  muxer_out : process (all)
  begin

    if mode = '1' then
      flag_out        <= flag_sequenzer;
      note_on         <= note_on_sequenzer;
      note_simple     <= note_simple_sequenzer;
      velocity_simple <= velocity_simple_sequenzer;
		
    else
      flag_out        <= flag_midi;
      note_on         <= note_on_midi;
      note_simple     <= note_simple_midi;
      velocity_simple <= velocity_simple_midi;
    end if;

  end process muxer_out;

-- End Architecture 
------------------------------------------- 
end rtl;
