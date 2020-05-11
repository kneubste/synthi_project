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

  port (button_cmd      : in  std_logic_vector(3 downto 0);
        reset_n         : in  std_logic;
        play_mode       : in  std_logic;
        note_on_melody         : out std_logic;
        note_simple_melody     : out std_logic_vector(6 downto 0);
        velocity_simple_melody : out std_logic_vector(6 downto 0)

        );

end entity midi_controller;

-- Architecture Declaration
-------------------------------------------
architecture rtl of midi_controller is
-- Signals & Constants Declaration
-------------------------------------------

  type XXXXXX is ();
  signal 

-- Begin Architecture
-------------------------------------------
begin

  --------------------------------------------------
  -- PROCESS FOR ALL XXXXX
  --------------------------------------------------
  XXXXX : process(all)
  begin

  end process XXXXX;


  --------------------------------------------------
  -- PROCESS FOR OUTPUT-COMB-LOGIC XXXXX
  --------------------------------------------------

  --------------------------------------------------

  --------------------------------------------------
  -- Output-Zuweisungen
  --------------------------------------------------

  --------------------------------------------------

-- End Architecture 
------------------------------------------- 
  end rtl;
