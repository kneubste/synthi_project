-------------------------------------------
-- Block code:  flankenDetekt_v2.vhd
-- History:     14.Oct.2013 - 1st version (dqtm)
-- Function: template to be edited by students in order 
--           to describe edge detector with rise & fall outputs. 
--             
-------------------------------------------

-- Library & Use Statements
library ieee;
use ieee.std_logic_1164.all;

-- Entity Declaration 
entity flanken_detekt_vhdl is
  port(data_in       : in  std_logic;
       clk           : in  std_logic;
       reset_n       : in  std_logic;
       rising_pulse  : out std_logic;
       falling_pulse : out std_logic
       );
end flanken_detekt_vhdl;


-- Architecture Declaration 
architecture rtl of flanken_detekt_vhdl is

  -- Signals & Constants Declaration 
  signal q_0 : std_logic;
  signal q_1 : std_logic;

-- Begin Architecture
begin
  -------------------------------------------
  -- Process for combinatorial logic
  ------------------------------------------- 
  -- not needed in this file, using concurrent logic

  -------------------------------------------
  -- Process for registers (flip-flops)
  -------------------------------------------
  flip_flops : process(all)
  begin
    if reset_n = '0' then
      q_0 <= '0';
      q_1 <= '0';
    elsif (rising_edge(clk)) then
      q_0 <= data_in;
      q_1 <= q_0;
    end if;
  end process flip_flops;

  -------------------------------------------
  -- Concurrent Assignments  
  -------------------------------------------
  flanken_detect : process(all)
  begin
    rising_pulse  <= q_0 and not q_1;
    falling_pulse <= not q_0 and q_1;
  end process flanken_detect;

end rtl;
