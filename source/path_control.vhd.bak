--------------------------------------------------------------------
-- Project     : Audio_Synthesizer
--
-- File Name   : digital_loop.vhd
-- Description : Multiplexer für die parallelen Daten des i2s_master.vhd
--                                      Bei Digital-Loop werden die Daten des i2s_master direkt
--                                      an ihn zurückgegeben, bei aktivem synthesizer werden die
--                                      Daten des synthesizer an den i2s_master gesendet.
--
--------------------------------------------------------------------
-- Change History
-- Date     |Name      |Modification
------------|----------|--------------------------------------------
-- 24.03.14 | loosean  | file created
-- 21.04.14 | loosean  | revised comments
-- 29.03.17 | dqtm     | adapt to reuse on extended DTP2 project with DAFX
--------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;


entity path_control is
  port(sw_sync_3      : in  std_logic;  --Wahl des Path
            -- Audio data generated inside FPGA
       dds_l_i : in  std_logic_vector(15 downto 0);  --Eingang vom Synthesizer
       dds_r_i : in  std_logic_vector(15 downto 0);
       -- Audio data coming from codec
       adcdat_pl_i : in  std_logic_vector(15 downto 0);  --Eingang vom i2s_master
       adcdat_pr_i : in  std_logic_vector(15 downto 0);
       -- Audio data towards codec
       dacdat_pl_o : out std_logic_vector(15 downto 0);  --Ausgang zum i2s_master
       dacdat_pr_o : out std_logic_vector(15 downto 0)
       );
end path_control;


architecture comb of path_control is



begin




end comb;

