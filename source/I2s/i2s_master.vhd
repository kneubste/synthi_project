--------------------------------------------------------------------
-- Project     : DTP_Soundmachine
--
-- File Name   : i2s_master.vhd
-- Description : Konvertiert die seriellen i2s Daten in ein paralleles signal
--                              und umgekehrt, Hierachie f�r clock-Teiler, state-machine, schieberegister
--
--------------------------------------------------------------------
-- Change History
-- Date     |Name      |Modification
------------|----------|--------------------------------------------
-- 24.03.14 | loosean  | file created
-- 21.04.14 | loosean  | revised comments
-- 29.03.17 | dqtm     | adapt to reuse on extended DTP2 project 
--                     | Changes: reuse mod_div, combine bit_cnt & i2s_decoder into frame_decoder)
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity i2s_master is
  port(
		 clk_12m : in std_logic;  -- 12.5M Clock
       reset_n : in std_logic;  -- Reset or init used for re-initialisation

       load_o : out std_logic;  -- Pulse once per audio frame 1/48kHz

       --Verbindungen zum audio_controller
       adcdat_pl_o : out std_logic_vector(15 downto 0);  --Ausgang zum audio_controller
       adcdat_pr_o : out std_logic_vector(15 downto 0);

       dacdat_pl_i : in std_logic_vector(15 downto 0);  --Eingang vom audio_controller
       dacdat_pr_i : in std_logic_vector(15 downto 0);

       --Verbindungen zum Audio-Codec
       dacdat_s_o : out std_logic;      --Serielle Daten Ausgang
       bclk_o     : out std_logic;      --Bus-Clock
       ws_o       : out std_logic;      --WordSelect (Links/Rechts)
       adcdat_s_i : in  std_logic       --Serielle Daten Eingang
       );
end i2s_master;


architecture rtl of i2s_master is
 -----------------------------------------------------------------------------
 --internal signal declaration
 -----------------------------------------------------------------------------

 signal load_int : std_logic;
 signal bclk_int : std_logic;
 signal shift_l_int : std_logic;
 signal shift_r_int : std_logic;
 signal ser_l_out : std_logic;
 signal ser_r_out : std_logic;
 signal clk_12m_int : std_logic;
 signal adcdat_s_int : std_logic;
 signal ws_int : std_logic;
 signal reset_n_int : std_logic;
  
 -------------------------------------------------------------------------------
 -- Component declarations
 -------------------------------------------------------------------------------
  component i2s_frame_generator is
    port (
		rst_n_12m : in  std_logic;
      clk_12m	 : in  std_logic;
      bclk    	 : out std_logic;
      load   	 : out std_logic;
      shift_l	 : out std_logic;
      shift_r	 : out std_logic;
      ws  	    : out std_logic);
  end component i2s_frame_generator;

 component universal_shiftreg is
   port (
     load      : in  std_logic;
     en_1      : in  std_logic;
     en_2      : in  std_logic;
     clk_12m   : in  std_logic;
     rst_n_12m : in  std_logic;
     ser_out   : out std_logic;
     ser_in    : in  std_logic;
     par_in    : in  std_logic_vector(15 downto 0);
     par_out   : out std_logic_vector(15 downto 0));
 end component universal_shiftreg;
  
  begin
	 
    P2S_left : universal_shiftreg
      port map (
        load => load_int,
        en_1 => bclk_int,
        en_2 => shift_l_int,
        ser_out => ser_l_out,
		  ser_in  => '0',
        clk_12m => clk_12m_int,
        rst_n_12m => reset_n_int,
        par_in => dacdat_pl_i,
		  par_out => OPEN);

    P2S_right : universal_shiftreg
      port map (
        load => load_int,
        en_1 => bclk_int,
        en_2 => shift_r_int,
        ser_out => ser_r_out,
		  ser_in  => '0',
        clk_12m => clk_12m_int,
        rst_n_12m => reset_n_int,
        par_in => dacdat_pr_i,
		  par_out => OPEN);

    S2P_left : universal_shiftreg
      port map (
		  load => load_int,
        en_1 => not(bclk_int),
        en_2 => shift_l_int,
		  ser_out => OPEN,
        ser_in => adcdat_s_int,
        clk_12m => clk_12m_int,
        rst_n_12m => reset_n_int,
		  par_in => "0000000000000000",
        par_out => adcdat_pl_o);

    S2P_right : universal_shiftreg
      port map (
		  load => load_int,
        en_1 => not(bclk_int),
        en_2 => shift_r_int,
		  ser_out => OPEN,
        ser_in => adcdat_s_int,
        clk_12m => clk_12m_int,
        rst_n_12m => reset_n_int,
		  par_in => "0000000000000000",
        par_out => adcdat_pr_o);

    frame_generator : i2s_frame_generator
       port map (
			rst_n_12m => reset_n_int,
         clk_12m => clk_12m_int,
         bclk => bclk_int,
         load => load_int,
         shift_l => shift_l_int,
         shift_r => shift_r_int,
         ws => ws_int);

 -------------------------------------------------------------------------------
 -- Wire connections/nodes
 -------------------------------------------------------------------------------
 
adcdat_s_int <= adcdat_s_i;
ws_o <= ws_int;       
load_o <= load_int;
clk_12m_int <= clk_12m;
reset_n_int <= reset_n;
bclk_o <= bclk_int;

 mux_logic : process(all)
 
 begin
       
	if ws_int = '1' then --ist word select high (rechts)?
		dacdat_s_o <= ser_r_out; 
	else 
		dacdat_s_o <= ser_l_out;
	end if; 
   
 end process;
 
end rtl;

