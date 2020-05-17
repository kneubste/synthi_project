--------------------------------------------------------------------
--
-- Project     : Master_I2s
--
-- File Name   : shiftreg_P2S.vhd
-- Description : converts parallel signal to serial signal
--                                      
-- Features:    ist load und bclk high, wird das parallele Signal 
--              in das Schieberegister geladen. Anhand des shift
--              enables und dem Haupttakt clk_12m wird geschoben.                
--------------------------------------------------------------------
-- Change History
-- Date     |Name      |Modification
------------|----------|--------------------------------------------
-- 6.03.19 | gelk     | Prepared template for students
-- 25.03.19| lussimat | Start with project.
-- 17.05.20| kneubste | Project-Contrl. & Beautify.
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.reg_table_pkg.all;


entity shiftreg_P2S is

  port (
    load      : in  std_logic;
    en_1      : in  std_logic;          --bclk muss high sein
    en_2      : in  std_logic;          --shift_l oder shift_r
    ser_out   : out std_logic;
    clk_12m   : in  std_logic;
    rst_n_12m : in  std_logic;
    par_in    : in  std_logic_vector(15 downto 0)
    );
end shiftreg_P2S;

architecture rtl of shiftreg_P2S is

  signal shift_enable            : std_logic := (en_1 and en_2);
  signal shiftreg, next_shiftreg : std_logic_vector(15 downto 0);

begin

  --------------------------------------------------
  -- PROCESS FOR ALL FLIP-FLOPS
  --------------------------------------------------
  comb_shift : process(all)
  begin

    if load = '1' and en_1 = '1' then  --*(wuerde load nicht mit bclk gekoppelt werden, wuerde eine Periode zu frueh geschoben werden)
      next_shiftreg <= par_in;
    elsif shift_enable = '1' then
      next_shiftreg <= shiftreg(14 downto 0) & '0';
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

  ser_out <= shiftreg(15);

end rtl;
