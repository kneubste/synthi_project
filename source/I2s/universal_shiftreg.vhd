--------------------------------------------------------------------
--
-- Project     : Master_I2s
--
-- File Name   : universal_shiftreg.vhd
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
-- 30.03.19| lussimat | Start with project.
--------------------------------------------------------------------

library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.reg_table_pkg.all;


entity universal_shiftreg is

  port (
    load      : in  std_logic;
    en_1      : in  std_logic;          --bclk muss high sein
    en_2      : in  std_logic;
    clk_12m   : in  std_logic;
    rst_n_12m : in  std_logic;          --shift_l oder shift_r
    ser_out   : out std_logic;
    ser_in    : in  std_logic;
    par_in    : in  std_logic_vector(15 downto 0);
    par_out   : out std_logic_vector(15 downto 0)
    );
end universal_shiftreg;

architecture rtl of universal_shiftreg is

  signal shiftreg_S2P, next_shiftreg_S2P : std_logic_vector(15 downto 0);
  signal shiftreg_P2S, next_shiftreg_P2S : std_logic_vector(15 downto 0);
  signal shift_enable                    : std_logic;

begin

  --------------------------------------------------
  -- PROCESS FOR ALL FLIP-FLOPS
  --------------------------------------------------
  comb_shift : process(all)
  begin
    --default statements
    next_shiftreg_S2P <= shiftreg_S2P;
    next_shiftreg_P2S <= shiftreg_P2S;

    if load = '1' and en_1 = '1' then  --*(würde load nicht mit bclk gekoppelt werden, würde eine Periode zu früh geschoben werden)
      next_shiftreg_P2S <= par_in; --paralleles signal wird geladen
    elsif en_1 = '1' and en_2 = '1' then
      next_shiftreg_P2S <= shiftreg_P2S(14 downto 0) & '0'; --schiebe von rechts nach links
      next_shiftreg_S2P <= shiftreg_S2P(14 downto 0) & ser_in; --schiebe von links nach rechts
    end if;
  end process comb_shift;


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

  par_out      <= shiftreg_S2P;
  ser_out      <= shiftreg_P2S(15);
  shift_enable <= en_1 and en_2;

end rtl;
