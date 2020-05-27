-------------------------------------------------------------------------------
-- Title      : bit_counter.vhd
-- Project    : synthi_project
-------------------------------------------------------------------------------
-- File       : midi_controller.vhd
-- Author     :   <kneubste>
-- Company    : 
-- Created    : 2013-11-13 (dqtm)
-- Last update: 2020-05-27
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: The bit_counter is a modulo counter which counts from 0 to 127. Each run-through from 0 to 127 equals a stereo signal sampling period.
-------------------------------------------------------------------------------
-- Revision:
-- 12.11.13| dqtm     | 1st version
-- 29.11.19| kneubste | changed from count_down.vhd
-- 17.05.27| kneubste | Project-Contrl. & Beautify.
-------------------------------------------------------------------------------

-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Entity Declaration 
-------------------------------------------
entity bit_counter is
  generic (width : positive := 4);
  port(clk, reset_n : in  std_logic;
       start_bit    : in  std_logic;
       baud_tick    : in  std_logic;
       bit_count    : out std_logic_vector(3 downto 0)
       );
end bit_counter;


-- Architecture Declaration
-------------------------------------------
architecture rtl of bit_counter is
-- Signals & Constants Declaration
-------------------------------------------
  constant max_val             : unsigned(width-1 downto 0) := to_unsigned(4, width);  -- convert integer value 4 to unsigned with 4bits
  signal count, next_bit_count : unsigned(width-1 downto 0);


-- Begin Architecture
-------------------------------------------
begin


  --------------------------------------------------
  -- PROCESS FOR COMBINATORIAL LOGIC
  --------------------------------------------------
  bit_counter : process(all)
  begin
    -- load     
    if (start_bit = '1') then
      next_bit_count <= to_unsigned(9, width);

    -- decrement
    elsif (bit_count > "0000") and baud_tick = '1' then
      next_bit_count <= count - 1;

    -- freezes
    else
      next_bit_count <= count;
    end if;

  end process bit_counter;




  --------------------------------------------------
  -- PROCESS FOR REGISTERS
  --------------------------------------------------
  flip_flops : process(all)
  begin
    if reset_n = '0' then
      count <= to_unsigned(0, width);  -- convert integer value 0 to unsigned with 4bits
    elsif rising_edge(clk) then
      count <= next_bit_count;
    end if;
  end process flip_flops;


  --------------------------------------------------
  -- CONCURRENT ASSIGNMENTS
  --------------------------------------------------
  -- convert count from unsigned to std_logic (output data-type)
  bit_count <= std_logic_vector(count);
-- End Architecture 
------------------------------------------- 
end rtl;
