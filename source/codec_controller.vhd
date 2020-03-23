--------------------------------------------------------------------
--
-- Project     : Audio_Synth
--
-- File Name   : codec_controller.vhd
-- Description : Controller to define Audio Codec Configuration via I2C
--                                      
-- Features:    Der Baustein wartet bis das reset_n signal inaktiv wird.
--              Danach sendet dieser Codec Konfigurierungsdaten an
--              den Baustein i2c_Master
--                              
--------------------------------------------------------------------
-- Change History
-- Date     |Name      |Modification
------------|----------|--------------------------------------------
-- 6.03.19 | gelk     | Prepared template for students
-- 9.03.19 | kneubste | Start with project.
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.reg_table_pkg.all;

-------------------------------------------------------------------------------
-- TEST --
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- TEST --
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- TEST --
-------------------------------------------------------------------------------

entity codec_controller is

  port (
    mode         : in  std_logic_vector(2 downto 0);  -- Inputs to choose Audio_MODE
    write_done_i : in  std_logic;       -- Input from i2c register write_done
    ack_error_i  : in  std_logic;       -- Inputs to check the transmission
    clk          : in  std_logic;
    reset_n      : in  std_logic;
    write_o      : out std_logic;       -- Output to i2c to start transmission 
    write_data_o : out std_logic_vector(15 downto 0)  -- Data_Output
    );
end codec_controller;


-- Architecture Declaration
-------------------------------------------
architecture rtl of codec_controller is
-- Signals & Constants Declaration
-------------------------------------------
  type fsm_states is (st_idle, st_wait_write, st_state_end);
  signal fsm_state         : fsm_states;
  signal next_fsm_state    : fsm_states;
  signal count, next_count : unsigned(3 downto 0);
-- Begin Architecture
-------------------------------------------
begin

  --------------------------------------------------
  -- PROCESS FOR ALL FLIP-FLOPS
  --------------------------------------------------
  flip_flops : process(all)
  begin
  
    if reset_n = '0' then
      fsm_state <= st_idle;
      count     <= to_unsigned(0, 4);
    elsif rising_edge(clk) then
      fsm_state <= next_fsm_state;
      count     <= next_count;
    end if;
	 
  end process flip_flops;
  --------------------------------------------------
  -- PROCESS FOR OUTPUT-codec-LOGIC 
  --------------------------------------------------
  fsm_state_logic : process (all)
  begin
  
    -- default statements (hold current value)
    next_count     <= count;
    next_fsm_state <= fsm_state;
 write_o                   <= '0';
  --------------------------------------------------
	 
    case fsm_state is
      when st_idle =>
         write_o <= '1';
        next_fsm_state <= st_wait_write;
      when st_wait_write =>
        if write_done_i = '1' and count < 9 then
          next_fsm_state <= st_idle;
          next_count     <= count + 1;
        elsif (write_done_i = '1' and count >= 9) or ack_error_i = '1' then
          next_fsm_state <= st_state_end;
        else NULL;
        end if;
      when others => null;
    end case;

  end process fsm_state_logic;




-- purpose: oudput data
-- type   : combinational
-- inputs : all
-- outputs: 
outdata: process (all) is
begin  -- process outdata
   case mode is
            when "001"  => write_data_o <= "000" & std_logic_vector(count) & C_W8731_ANALOG_BYPASS(to_integer(count));
            when "101"  => write_data_o <= "000" & std_logic_vector(count) & C_W8731_ANALOG_MUTE_LEFT(to_integer(count));
            when "011"  => write_data_o <= "000" & std_logic_vector(count) & C_W8731_ANALOG_MUTE_RIGHT(to_integer(count));
            when "111"  => write_data_o <= "000" & std_logic_vector(count) & C_W8731_ANALOG_MUTE_BOTH(to_integer(count));
            when others => write_data_o <= "000" & std_logic_vector(count) & C_W8731_ADC_DAC_0DB_48K(to_integer(count));
          end case;
end process outdata;

-- End Architecture 
------------------------------------------- 
end rtl;
