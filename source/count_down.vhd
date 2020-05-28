-------------------------------------------------------------------------------
-- Title      : count_down
-- Project    : Synthesizer
-------------------------------------------------------------------------------
-- File       : uart_top.vhd
-- Author     :   <dqtm>
-- Company    : 
-- Created    : 2013-11-12
-- Last update: 2020-05-28
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description:         down-counter, with start input and count output. 
--                      The input start should be a pulse which causes the 
--                      counter to load its max-value. When start is off,
--                      the counter decrements by one every clock cycle till 
--                      count_o equals 0. Once the count_o reachs 0, the counter
--                      freezes and wait till next start pulse. 
--                      Can be used as enable for other blocks where need to 
--                      count number of iterations.
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date:       | Version:   | Author:   | Description:
-- 2020-04-20  | 1.0        | dqtm      | 1st version
-- 2020-05-17  | 1.1        | kneubste  | Project-Contrl. & Beautify.
-------------------------------------------------------------------------------

-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Entity Declaration 
-------------------------------------------
entity count_down is
  generic (width : positive := 4);
  port(clk, reset_n : in  std_logic;
       start_i      : in  std_logic;
       count_o      : out std_logic_vector(width-1 downto 0)
       );
end count_down;


-- Architecture Declaration
-------------------------------------------
architecture rtl of count_down is
-- Signals & Constants Declaration
-------------------------------------------
  constant max_val         : unsigned(width-1 downto 0) := to_unsigned(4, width);  -- convert integer value 4 to unsigned with 4bits
  signal count, next_count : unsigned(width-1 downto 0);


-- Begin Architecture
-------------------------------------------
begin


  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  comb_logic : process(all)
  begin
    -- load     
    if (start_i = '1') then
      next_count <= max_val;

    -- decrement
    elsif (count > 0) then
      next_count <= count - 1;

    -- freezes
    else
      next_count <= count;
    end if;

  end process comb_logic;




  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : process(all)
  begin
    if reset_n = '0' then
      count <= to_unsigned(0, width);  -- convert integer value 0 to unsigned with 4bits
    elsif rising_edge(clk) then
      count <= next_count;
    end if;
  end process flip_flops;


  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
  -- convert count from unsigned to std_logic (output data-type)
  count_o <= std_logic_vector(count);


-- End Architecture 
------------------------------------------- 
end rtl;

