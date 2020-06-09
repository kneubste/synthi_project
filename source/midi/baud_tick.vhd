-------------------------------------------------------------------------------
-- Title      : baud_tick
-- Project    : synthi_project
-------------------------------------------------------------------------------
-- File       : baud_tick.vhd
-- Author     :   <dqtm>
-- Company    : 
-- Created    : 2013-11-12
-- Last update: 2020-05-25
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: This building block generates the baud-tick rate
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date:       | Version:   | Author:   | Description:
-- 2013-11-12	| 1.0			 | dqtm		 | created
-- 2019-12-25  | 1.1      	 | Cyrill    | angepasst
-- 2020-05-17  | 1.2        | kneubste  | Project-Contrl. & Beautify.
-- 2020-05-25  | 1.3			 | lussimat  | auskommentiert & neu strukturiert
-------------------------------------------------------------------------------

-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Entity Declaration 
-------------------------------------------
entity baud_tick is
  generic (width : positive := 10);
  port(clk, reset_n : in  std_logic;
       start_bit    : in  std_logic;
       baud_tick    : out std_logic
       );
end baud_tick;


-- Architecture Declaration
-------------------------------------------
architecture rtl of baud_tick is
-- Signals & Constants Declaration
-------------------------------------------
  constant max_val         : unsigned(width-1 downto 0)         := to_unsigned(4, width);  -- convert integer value 4 to unsigned with 4bits
  constant clock_freq      : positive                           := 12_500_000;  -- Clock/Hz 
  constant baud_rate       : positive                           := 115_200;  -- Baude Rate/Hz 
  constant count_width     : positive                           := 10;  -- FreqClock/FreqBaudRate=50000000/115200 =434 so need 10bits 
  constant one_period      : unsigned(count_width - 1 downto 0) := to_unsigned(clock_freq / baud_rate, count_width);
  constant half_period     : unsigned(count_width - 1 downto 0) := to_unsigned(clock_freq/ baud_rate /2, count_width);
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
    if (start_bit = '1') then
      next_count <= half_period;

    elsif (count = "0000000000") then
      next_count <= one_period;

    -- decrement
    else
      next_count <= count - 1;
    end if;

  end process comb_logic;
  
  --------------------------------------------------
  -- PROCESS FOR OUTPUT-LOGIC
  --------------------------------------------------

  out_logic : process(all)
  begin
  
    baud_tick <= '0'; -- default value

    if (count = "000000000") then
      baud_tick <= '1';
    end if;

  end process out_logic;

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


-- End Architecture 
------------------------------------------- 
end rtl;

