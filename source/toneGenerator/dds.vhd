-------------------------------------------------------------------------------
-- Title      : dds Direct Digital Synthesis
-- Project    : 
-------------------------------------------------------------------------------
-- File       : dds.vhd
-- Author     :   <Cyrill@DESKTOP-MRJOR86>
-- Company    : 
-- Created    : 2020-04-06
-- Last update: 2020-04-06
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-04-06  1.0      Cyrill	Created
-------------------------------------------------------------------------------

library ieee;
library work;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tone_gen_pkg.all;

-------------------------------------------------------------------------------

entity dds is
	port(
		clk_12m		: in	std_logic;
		reset_n		: in	std_logic;
		step_i		: in	std_logic;
		tone_on_i	: in	std_logic;
		instr_sel_i	: in 	std_logic_vector(3 downto 0);			-- Schalter für die Wahl des Instruments ein.
		instr_ctrl  : in std_logic;
		phi_incr_i	: in	std_logic_vector(N_CUM-1 downto 0); 	-- Zähler inkrement Schritte --> Freq des Sin
		attenu_i		: in	std_logic_vector(2 downto 0);
		dds_o			: out std_logic_vector(15 downto 0)
		);

end entity dds;

-------------------------------------------------------------------------------

architecture str of dds is

SIGNAL count		: unsigned(N_CUM-1 downto 0);
SIGNAL next_count	: unsigned(N_CUM-1 downto 0);
SIGNAL lut_val		: signed(N_AUDIO-1 downto 0);
SIGNAL lut_addr 	: integer range 0 to L-1; 
SIGNAL atte			: integer range 0 to 7;


begin  -- architecture str
--------------------------------------------------
-- PROCESS FOR COMBINATORIAL LOGIC
--------------------------------------------------

comb_logic : PROCESS(all)
	BEGIN
		if step_i = '0' THEN
			next_count <= count;
		else
			next_count <= count + unsigned(phi_incr_i);
		end if;		
END PROCESS comb_logic;

lut_addr <= to_integer(count(N_CUM-1 downto N_CUM - N_LUT));

instrument : PROCESS(all) -- Prozess für die Auswahl des Instrument-LUTs.

	BEGIN
		if instr_sel_i(0) = '1' then
			case instr_sel_i(3 downto 1) is
			when "000" => lut_val <= to_signed(LUT_sinus(lut_addr), N_AUDIO); 	-- Audio Output accessing lut_sinus
			when "001" => lut_val <= to_signed(LUT_violin_a(lut_addr), N_AUDIO); 		-- Audio Output accessing LUT_violin_a
			when "010" => lut_val <= to_signed(LUT_chello_a(lut_addr), N_AUDIO); 		-- Audio Output accessing LUT_chello_a
			when "011" => lut_val <= to_signed(LUT_sinus(lut_addr), N_AUDIO); 		-- Audio Output accessing LUT_sinus
			when "100" => lut_val <= to_signed(LUT_sinus(lut_addr), N_AUDIO); 		-- Audio Output accessing LUT_sinus
			when "101" => lut_val <= to_signed(LUT_sinus(lut_addr), N_AUDIO); 		-- Audio Output accessing LUT_sinus
			when "111" => lut_val <= to_signed(LUT_sinus(lut_addr), N_AUDIO); 		-- Audio Output accessing LUT_sinus
			when others => lut_val <= to_signed(LUT_sinus(lut_addr), N_AUDIO); 	-- Audio Output accessing lut_sinus
			end case;
		else
			lut_val <= to_signed(LUT_sinus(lut_addr), N_AUDIO); 	-- Audio Output accessing lut_sinus
		end if;
END PROCESS instrument;
		 
		

attenu : PROCESS(all)
	BEGIN
	atte <= to_integer(unsigned(attenu_i));
		
		if tone_on_i = '1' then
			case atte is 
			when 0 => dds_o <= std_logic_vector(lut_val);
			when 1 => dds_o <= std_logic_vector(shift_right(lut_val,1));
			when 2 => dds_o <= std_logic_vector(shift_right(lut_val,2));
			when 3 => dds_o <= std_logic_vector(shift_right(lut_val,3));
			when 4 => dds_o <= std_logic_vector(shift_right(lut_val,4));
			when 5 => dds_o <= std_logic_vector(shift_right(lut_val,5));
			when 6 => dds_o <= std_logic_vector(shift_right(lut_val,6));
			when 7 => dds_o <= std_logic_vector(shift_right(lut_val,7));
			when others => dds_o <= std_logic_vector(lut_val);
			end case;
		else dds_o <=  (others => '0');
		end if;
END PROCESS attenu;	


--------------------------------------------------
-- PROCESS FOR Counter
--------------------------------------------------

counter : PROCESS(all)
	BEGIN
		if reset_n = '0' THEN
			count <= (others => '0');
		elsif rising_edge(clk_12m) THEN
			count <= next_count;
		end if;
END PROCESS counter;


end architecture str;

-------------------------------------------------------------------------------
