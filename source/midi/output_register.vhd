-------------------------------------------
-- Block code:  output_register.vhd
-- History:     12.Nov.2013 - 1st version (dqtm)
--              03.Dez.2019 - 2nd version  (stutzcyr)
--              2020-05-17    kneubste   Project-Contrl. & Beautify.
--
-- Function: down-counter, with start input and count output. 
--                      The input start should be a pulse which causes the 
--                      counter to load its max-value. When start is off,
--                      the counter decrements by one every clock cycle till 
--                      count_o equals 0. Once the count_o reachs 0, the counter
--                      freezes and wait till next start pulse. 
--                      Can be used as enable for other blocks where need to 
--                      count number of iterations.
-------------------------------------------


-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Entity Declaration 
-------------------------------------------
entity output_register is
  generic (width : positive := 10);
  port(clk, reset_n : in  std_logic;
       data_valid   : in  std_logic;
       parallel_in  : in  std_logic_vector(width-1 downto 0);
       hex_lsb_out  : out std_logic_vector(3 downto 0);
       hex_msb_out  : out std_logic_vector(3 downto 0)
       );
end output_register;


-- Architecture Declaration
-------------------------------------------
architecture rtl of output_register is
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
    if (data_valid = '1') then
      next_count <= unsigned(parallel_in);
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
  hex_msb_out <= std_logic_vector(count(width-2 downto 5));
  hex_lsb_out <= std_logic_vector(count(4 downto 1));


-- End Architecture 
------------------------------------------- 
end rtl;

