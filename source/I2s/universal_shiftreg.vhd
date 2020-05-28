-------------------------------------------------------------------------------
-- Title      : universal_shiftreg
-- Project    : Master_I2s
-------------------------------------------------------------------------------
-- File       : universal_shiftreg.vhd
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
-- 2020.03.30 | lussimat | Start with project.
-- 2020.05.28 | kneubste | Project-Contrl. & Beautify.
-------------------------------------------------------------------------------

library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.reg_table_pkg.all;

--------------------------------------------------------------------------------------------------

entity universal_shiftreg is

  port (
    load      : in  std_logic;
    en_1      : in  std_logic;          --bclk has to be high 
    en_2      : in  std_logic;
    clk_12m   : in  std_logic;
    rst_n_12m : in  std_logic;          --shift_l or shift_r
    ser_out   : out std_logic;
    ser_in    : in  std_logic;
    par_in    : in  std_logic_vector(15 downto 0);
    par_out   : out std_logic_vector(15 downto 0)
    );
end universal_shiftreg;

--------------------------------------------------------------------------------------------------

architecture rtl of universal_shiftreg is

  signal shiftreg_S2P, next_shiftreg_S2P : std_logic_vector(15 downto 0);
  signal shiftreg_P2S, next_shiftreg_P2S : std_logic_vector(15 downto 0);

begin

 ------------------------------------------------------------------------------------------------
 -- PROCESS FOR SHIFT-COMB-LOGIC
 ------------------------------------------------------------------------------------------------
  
  comb_shift : process(all)
  begin
    --default statements
    next_shiftreg_S2P <= shiftreg_S2P;
    next_shiftreg_P2S <= shiftreg_P2S;

    if load = '1' and en_1 = '1' then  --*(If load wasn't linked with bclk, it would shift 1 period early.)
      next_shiftreg_P2S <= par_in;      --parallel signal load
    elsif en_1 = '1' and en_2 = '1' then
      next_shiftreg_P2S <= shiftreg_P2S(14 downto 0) & '0';  --shift right to left
      next_shiftreg_S2P <= shiftreg_S2P(14 downto 0) & ser_in;  --shift left to right
    end if;
	 
  end process comb_shift;

 ------------------------------------------------------------------------------------------------
 -- PROCESS FOR ALL FLIP-FLOPS
 ------------------------------------------------------------------------------------------------

  shift_dffs : process(all)
  begin
  
    if rst_n_12m = '0' then
      shiftreg_P2S <= (others => '0');
      shiftreg_S2P <= (others => '0');
    elsif rising_edge(clk_12m) then
      shiftreg_P2S <= next_shiftreg_P2S;
      shiftreg_S2P <= next_shiftreg_S2P;
    end if;
	 
  end process shift_dffs;

 ------------------------------------------------------------------------------------------------
 -- PROCESS OUTPUT
 ------------------------------------------------------------------------------------------------

  par_out <= shiftreg_S2P;
  ser_out <= shiftreg_P2S(15);

end rtl;
