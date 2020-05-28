-------------------------------------------------------------------------------
-- Title      : shiftreg_s2p
-- Project    : Master_I2s
-------------------------------------------------------------------------------
-- File       : shiftrep_S2P.vhd
-- Author     : gelk
-- Company    : 
-- Created    : 2019-03-06
-- Last update: 2020-05-28
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: If shift_enable High, shift from clk_12m with rising flank.
--		
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2019.03.06 | gelk     | Prepared template for students
-- 2020.03.21 | lussimat | Start with project.
-- 2020.05.28 | kneubste | Project-Contrl. & Beautify.
-------------------------------------------------------------------------------




library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.reg_table_pkg.all;


entity shiftreg_S2P is

  port (
    en_1      : in  std_logic;          --bclk has to be high
    en_2      : in  std_logic;          --shift_l or shift_r
    ser_in    : in  std_logic;
    clk_12m   : in  std_logic;
    rst_n_12m : in  std_logic;
    par_out   : out std_logic_vector(15 downto 0)
    );
end shiftreg_S2P;

architecture rtl of shiftreg_S2P is

  signal shift_enable            : std_logic := (not(en_1) and en_2);
  signal shiftreg, next_shiftreg : std_logic_vector(15 downto 0);

begin

  --------------------------------------------------
  -- PROCESS FOR ALL FLIP-FLOPS
  --------------------------------------------------
  comb_shift : process(all)
  begin

    if shift_enable = '1' then
      next_shiftreg <= shiftreg(14 downto 0) & ser_in;
    else
      next_shiftreg <= shiftreg;
    end if;
  end process comb_shift;


  shift_dffs : process(all)
  begin
    if rst_n_12m = '0' then
      shiftreg <= (others => '0');
    elsif rising_edge(clk_12m) then
      shiftreg <= next_shiftreg;
    end if;
  end process shift_dffs;

  par_out <= shiftreg;

end rtl;
