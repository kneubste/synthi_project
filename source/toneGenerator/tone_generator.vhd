-------------------------------------------------------------------------------
-- Title      : tone generator
-- Project    : 
-------------------------------------------------------------------------------
-- File       : tone_generator.vhd
-- Author     :   <Cyrill@DESKTOP-MRJOR86>
-- Company    : 
-- Created    : 2020-04-07
-- Last update: 2020-04-07
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: This block contains the dds for sythi_project
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-04-07  1.0      Cyrill	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tone_gen_pkg.all;

-------------------------------------------------------------------------------

entity tone_generator is

  port (clk_12m		: in  std_logic;
        rst_n			: in  std_logic;
        tone_on_i 	: in  std_logic;
        step_i			: in  std_logic;
        note_i			: in  std_logic_vector(7 downto 0);
        velocity_i	: in  std_logic_vector(7 downto 0);
        dds_l_o 		: out std_logic_vector(15 downto 0);
        dds_r_o 		: out std_logic_vector(15 downto 0)        
    );

end entity tone_generator;


architecture str of tone_generator is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  signal dds_tone_gene : std_logic_vector(15 downto 0); --internes dds signal
  
  -----------------------------------------------------------------------------
  -- Component declarations
  -----------------------------------------------------------------------------

  component dds is
    port (
      clk_12m    : in  std_logic;
      reset_n    : in  std_logic;
      step_i     : in  std_logic;
      tone_on_i  : in  std_logic;
      phi_incr_i : in  std_logic_vector(N_CUM-1 downto 0);
      attenu_i   : in  std_logic_vector(2 downto 0);
      dds_o      : out std_logic_vector(15 downto 0));
  end component dds;

begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  -- instance "dds_1"
  dds_1: dds
    port map (
      clk_12m    => clk_12m,
      reset_n    => rst_n,
      step_i     => step_i,
      tone_on_i  => tone_on_i,
      phi_incr_i => lut_midi2dds(to_integer(unsigned(note_i))), --Lut wert von note_i
      attenu_i   => velocity_i(7 downto 5),  --MSBs der velocity_i
      dds_o      => dds_tone_gene);

  -----------------------------------------------------------------------------
  -- Concurrenst stantments
  -----------------------------------------------------------------------------
  dds_l_o <= dds_tone_gene;
  dds_r_o <= dds_tone_gene;  

end architecture str;

-------------------------------------------------------------------------------