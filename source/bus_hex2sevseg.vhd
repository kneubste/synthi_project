-------------------------------------------------------------------------------
-- Title      : sevenseg
-- Project    : 
-------------------------------------------------------------------------------
-- File       : bus_sevenseg.vhd
-- Author     : Hans-Joachim Gelke  <hansgelke@Hans-Joachims-MacBook-Pro.local>
-- Company    : 
-- Created    : 2018-10-26
-- Last update: 2019-07-22
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2018 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2018-10-26  1.0      hansgelke       Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity bus_hex2sevseg is

  port(

    data_in  : in std_logic_vector(3 downto 0);
  

    seg_o : out std_logic_vector(6 downto 0));  -- Sequence is "gfedcba" (MSB is seg_g)

end bus_hex2sevseg;

architecture rtl of bus_hex2sevseg is

  -- Signals & Constants Declaration
 
  constant display_0     : std_logic_vector(6 downto 0) := "0111111";
  constant display_1     : std_logic_vector(6 downto 0) := "0000110";
  constant display_2     : std_logic_vector(6 downto 0) := "1011011";
  constant display_3     : std_logic_vector(6 downto 0) := "1001111";
  constant display_4     : std_logic_vector(6 downto 0) := "1100110";
  constant display_5     : std_logic_vector(6 downto 0) := "1101101";
  constant display_6     : std_logic_vector(6 downto 0) := "1111101";
  constant display_7     : std_logic_vector(6 downto 0) := "0000111";
  constant display_8     : std_logic_vector(6 downto 0) := "1111111";
  constant display_9     : std_logic_vector(6 downto 0) := "1101111";
  constant display_A     : std_logic_vector(6 downto 0) := "1110111";
  constant display_B     : std_logic_vector(6 downto 0) := "1111100";
  constant display_C     : std_logic_vector(6 downto 0) := "0111001";
  constant display_D     : std_logic_vector(6 downto 0) := "1011110";
  constant display_E     : std_logic_vector(6 downto 0) := "1111001";
  constant display_F     : std_logic_vector(6 downto 0) := "1110001";

begin



  -------------------------------------------

  -- Concurrent Assignments  

  -------------------------------------------

  -- Implementation option: concurrent comb logic with with/select/when

  hex2seven : process (data_in) is
  begin  -- process hex2seven

      case data_in is

        when x"0"   => seg_o <= not(display_0);
        when x"1"   => seg_o <= not(display_1);
        when x"2"   => seg_o <= not(display_2);
        when x"3"   => seg_o <= not(display_3);
        when x"4"   => seg_o <= not(display_4);
        when x"5"   => seg_o <= not(display_5);
        when x"6"   => seg_o <= not(display_6);
        when x"7"   => seg_o <= not(display_7);
        when x"8"   => seg_o <= not(display_8);
        when x"9"   => seg_o <= not(display_9);
        when x"a"   => seg_o <= not(display_A);
        when x"b"   => seg_o <= not(display_B);
        when x"c"   => seg_o <= not(display_C);
        when x"d"   => seg_o <= not(display_D);
        when x"e"   => seg_o <= not(display_E);
        when x"f"   => seg_o <= not(display_F);
        when others => seg_o <= not(display_F);

      end case;
    end process hex2seven;

 
  end rtl;
