-------------------------------------------------------------------------------
-- Title      : midi_controller
-- Project    : 
-------------------------------------------------------------------------------
-- File       : midi_controller.vhd
-- Author     :   <kneubste>
-- Company    : 
-- Created    : 2020-05-11
-- Last update: 2020-05-11
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Enth�lt den mode_switch-Block f�r den Tone_generator.
--              Umschaltung zwischen Midi-Controller und Melody-Box.
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-05-11  1.0      kneubste        Created
-------------------------------------------------------------------------------

-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Entity Declaration 
-------------------------------------------

entity mode_switch is

  port (mode                   : in  std_logic;  -- Wahl Betriebsart
        note_on_midi           : in  std_logic;  -- Signal von Midi_controller
        note_simple_midi       : in  std_logic_vector(6 downto 0);  -- Signal von Midi_controller
        velocity_simple_midi   : in  std_logic_vector(6 downto 0);  -- Signal von Midi_controller
        note_on_melody         : in  std_logic;  -- Signal von Melody_box
        note_simple_melody     : in  std_logic_vector(6 downto 0);  -- Signal von Melody_box
        velocity_simple_melody : in  std_logic_vector(6 downto 0);  -- Signal von Melody_box
-- Umbennenung der Signale vom Midi_Controller sinnvoll.
        note_on                : out std_logic;  -- Signal ton_gen
        note_simple            : out std_logic_vector(6 downto 0);  -- Signal ton_gen
        velocity_simple        : out std_logic_vector(6 downto 0)  -- Signal ton_gen
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
	if mode = '1' then
	note_on <= note_on_melody
	note_simple <= note_simple_melody
	velocity_simple <= velocity_simple_melody;
	else
	note_on <= note_on_midi
	note_simple <= note_simple_midi
	velocity_simple <= velocity_simple_midi;
	end if;


-- End Architecture 
------------------------------------------- 
end rtl;
