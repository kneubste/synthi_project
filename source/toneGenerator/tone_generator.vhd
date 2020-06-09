-------------------------------------------------------------------------------
-- Title      : tone generator
-- Project    : synthi_project
-------------------------------------------------------------------------------
-- File       : tone_generator.vhd
-- Author     : Cyrill Stutz <stutzcyr>
-- Company    : 
-- Created    : 2020-04-07
-- Last update: 2020-05-27
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: This block contains the dds's for sythi_project.
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-04-07  1.0      stutzcyr   Created
-- 2020-05-11  1.1      lussimat   Changes for 10 DDS.
-- 2020-05-27  1.2      kneubste   Project-Contrl. & Beautify.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tone_gen_pkg.all;

-------------------------------------------------------------------------------

entity tone_generator is

  port (clk_12m     : in  std_logic;
        rst_n       : in  std_logic;
        tone_on_i   : in  note_on_array;
        step_i      : in  std_logic;    --load from m2s_master
        note_i      : in  t_tone_array;
        instr_sel_i : in  std_logic_vector(3 downto 0);
        velocity_i  : in  t_tone_array;
        dds_l_o     : out std_logic_vector(15 downto 0);
        dds_r_o     : out std_logic_vector(15 downto 0)
        );

end entity tone_generator;


architecture str of tone_generator is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  signal dds_o_array           : t_dds_o_array;
  signal sum_reg, next_sum_reg : signed(N_Audio-1 downto 0);
  -----------------------------------------------------------------------------
  -- Component declarations
  -----------------------------------------------------------------------------

  component dds is
    port (
      clk_12m     : in  std_logic;
      reset_n     : in  std_logic;
      step_i      : in  std_logic;
      tone_on_i   : in  std_logic;
      instr_sel_i : in  std_logic_vector(3 downto 0);
      phi_incr_i  : in  std_logic_vector(N_CUM-1 downto 0);
      attenu_i    : in  std_logic_vector(2 downto 0);
      dds_o       : out std_logic_vector(15 downto 0));
  end component dds;

begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  -- For-Loop for automatic instance generation for 10 DDS.

  -- instance "10 dds"
  dds_inst_gen : for i in 0 to 9 generate
    inst_dds : dds
      port map (
        clk_12m     => clk_12m,
        reset_n     => rst_n,
        step_i      => step_i,
        tone_on_i   => tone_on_i(i), -- tone_on Array is filled.
        instr_sel_i => instr_sel_i,
        phi_incr_i  => lut_midi2dds(to_integer(unsigned(note_i(i)))),  --Lut value of note_i
        attenu_i    => velocity_i(i)(6 downto 4),  --MSBs of velocity_i
        dds_o       => dds_o_array(i)); ---Output per dds is stored in array location
  end generate dds_inst_gen;

  -----------------------------------------------------------------------------
  -- CALCULATION OUTPUT
  -----------------------------------------------------------------------------

  comb_sum_output : process (all)
    variable var_sum : signed(N_Audio-1 downto 0); --variabel definieren	 
  begin
  
    var_sum := (others => '0'); --default case
    if step_i = '1' then --load from I2s Master (only then, change in tone)
      dds_sum_loop : for i in 0 to 9 loop
        var_sum := var_sum + signed(dds_o_array(i)); --All 10 levels are added together
      end loop dds_sum_loop;
      next_sum_reg <= var_sum;
    else
      next_sum_reg <= sum_reg;
    end if;
	 
  end process comb_sum_output;

  -----------------------------------------------------------------------------
  -- FLIP FLOP
  -----------------------------------------------------------------------------

  reg_sum_output : process(all)
  begin
  
    if rst_n = '0' then
      sum_reg <= (others => '0');
    elsif rising_edge(clk_12m) then
      sum_reg <= next_sum_reg;
    end if;
	 
  end process reg_sum_output;
  
  -----------------------------------------------------------------------------
  -- OUTPUT
  ----------------------------------------------------------------------------- 

  dds_l_o <= std_logic_vector(sum_reg);
  dds_r_o <= std_logic_vector(sum_reg);

end architecture str;

-------------------------------------------------------------------------------
