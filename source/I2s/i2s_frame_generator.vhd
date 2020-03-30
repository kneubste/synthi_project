-------------------------------------------
-- Block code:  i2s_frame_generator.vhd
-- History:     24.Maerz.2020 - 1st version (lussimat)
--
-- Function: 
-------------------------------------------

-- Library & Use Statements
-------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


-- Entity Declaration 
-------------------------------------------
entity i2s_frame_generator is
  port(clk_12m : in  std_logic;
		 rst_n_12m : in  std_logic;
       bclk    : out std_logic;
       load    : out std_logic;
       shift_l : out std_logic;
       shift_r : out std_logic;
       ws      : out std_logic
       );
end i2s_frame_generator;


-- Architecture Declaration?
-------------------------------------------
architecture rtl of i2s_frame_generator is
-- Signals & Constants Declaration?
-------------------------------------------
  signal width                      : integer                    := 2;
  signal div_count, div_next_count  : unsigned(width-1 downto 0) := (others => '0');
  signal bit_counter, next_bit_counter                : unsigned(6 downto 0);
  signal ws_int, load_int, bclk_int : std_logic;
  signal shift_l_int, shift_r_int   : std_logic;

  constant links  : std_logic := '0';
  constant rechts : std_logic := '1';
-- Begin Architecture
-------------------------------------------
begin
-------------------------------------------------------
--BCLK Generator
-------------------------------------------------------
  mod_div_comb_logic : process(all)
  begin
    --increment next_count
    div_next_count <= div_count + 2;

  end process mod_div_comb_logic;

  mod_div_ff : process(all)
  begin
    --shift
    if rising_edge(clk_12m) then
      div_count <= div_next_count;
    end if;

  end process mod_div_ff;
--------------------------------------------------------


--------------------------------------------------------
--modul Counter
--------------------------------------------------------
  modulo_logic : process(all)
  begin
   if bclk = '1' then
     next_bit_counter <= bit_counter + 1;
   else
     next_bit_counter <= bit_counter;
   end if;
   

  end process modulo_logic;
--------------------------------------------------------

 modul_counter : process(all)
  begin
    --counter from 0 to 128 - increment by rising edge of clk_12m and low bclk
    if rst_n_12m = '0' then
      bit_counter <= (others => '0');
   elsif rising_edge(clk_12m) then
      bit_counter <= next_bit_counter;
    end if;

  end process modul_counter;
  

--------------------------------------------------------
--i2s_decoder
--------------------------------------------------------        
  i2s_decoder : process(all)
  begin
    --default values
    shift_r_int <= '0';
    shift_l_int <= '0';
    load_int    <= '0';
    ws_int      <= '0';

    --comb of: shift_l, shft_r, ws
    if bit_counter(3 downto 0) > "0000" then
      if bit_counter(6 downto 4) = "000" then
        ws_int      <= links;           --word select => left
        shift_l_int <= '1';             --shift_l wird
      elsif bit_counter(6 downto 4) = "100" then
        ws_int      <= rechts;          --word select => rechts
        shift_r_int <= '1';             --shift_r wird
      end if;
    elsif bit_counter(6 downto 4) = "000" then
      load_int <= '1';
    end if;


  end process i2s_decoder;
--------------------------------------------------------

  --Output: bclk, ws, load, shift_l, shift_r

  bclk    <= std_logic(div_next_count(width-1));  --bclk wird ausgegeben   
  ws      <= ws_int;
  shift_l <= shift_l_int;
  shift_r <= shift_r_int;
  load    <= load_int;

end rtl;
