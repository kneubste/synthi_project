-------------------------------------------------------------------------------
-- Title      : synthi_top
-- Project    : 
-------------------------------------------------------------------------------
-- File       : synthi_top.vhd
-- Author     :   <Cyrill@DESKTOP-MRJOR86>
-- Company    : 
-- Created    : 2020-02-21
-- Last update: 2020-03-28
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: This is the Top level of the synthi project.
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-02-21  1.0      Cyrill	Created
-- 2020-01-11  1.1      Cyrill  Added codec_controller and i2c_master
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.all;
use work.reg_table_pkg.all;
-------------------------------------------------------------------------------

entity synthi_top is

   port (  CLOCK_50 : in std_logic;            -- DE2 clock from xtal 50MHz
    KEY_0    : in std_logic;            -- DE2 low_active input buttons
    KEY_1    : in std_logic;            -- DE2 low_active input buttons
    SW       : in std_logic_vector(9 downto 0);  -- DE2 input switches
    USB_RXD : in std_logic;             -- USB (midi) serial_input
    USB_TXD : in std_logic;             -- USB (midi) serial_output
    BT_RXD : in std_logic;             -- Bluetooth serial_input
    BT_TXD : in std_logic;             -- Bluetooth serial_output
    BT_RST_N : in std_logic;           -- Bluetooth reset_n
    AUD_XCK     : out std_logic;        -- master clock for Audio Codec
    AUD_DACDAT  : out std_logic;        -- audio serial data to Codec-DAC
    AUD_BCLK    : out std_logic;        -- bit clock for audio serial data
    AUD_DACLRCK : out std_logic;        -- left/right word select for Codec-DAC
    AUD_ADCLRCK : out std_logic;        -- left/right word select for Codec-ADC
    AUD_ADCDAT  : in  std_logic;        -- audio serial data from Codec-ADC
    AUD_SCLK : out   std_logic;         -- clock from I2C master block
    AUD_SDAT : inout std_logic;          -- data  from I2C master block
    LEDR_0 : out std_logic;
    HEX0: out std_logic_vector(6 downto 0);  -- output for HEX 0 display
    HEX1: out std_logic_vector(6 downto 0)  -- output for HEX 1 display
    );

end entity synthi_top;

-------------------------------------------------------------------------------

architecture str of synthi_top is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  signal sig_clk_12m : std_logic;
  signal sig_reset_n : std_logic;
  signal sig_usb_txd_sync : std_logic;
  signal sig_ledr_0 : std_logic;
  signal sig_write_o : std_logic;
  signal sig_write_data_o : std_logic_vector(15 downto 0);
  signal sig_write_done_i : std_logic;
  signal sig_ack_error : std_logic;
  signal ws_o_int : std_logic;
  signal pl_master_out : std_logic_vector(15 downto 0);
  signal pr_master_out : std_logic_vector(15 downto 0);
  signal pl_pathcon_out : std_logic_vector(15 downto 0);
  signal pr_pathcon_out : std_logic_vector(15 downto 0);
  signal dds_r_i : std_logic_vector(15 downto 0);
  signal dds_l_i : std_logic_vector(15 downto 0);
  
  -----------------------------------------------------------------------------
  -- Component declarations
  -----------------------------------------------------------------------------

  component uart_top is
    port (
      clk         : IN  STD_LOGIC;
      reset_n     : IN  STD_LOGIC;
      ser_data_i  : IN  STD_LOGIC;
      rx_data_rdy : OUT STD_LOGIC;
      seg0_o      : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      seg1_o      : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);
      rx_data     : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
  end component uart_top;

  component infrastructure is
    port (
      clock_50     : in  std_logic;
      key_0        : in  std_logic;
      usb_txd      : in  std_logic;
      clk_12m      : out std_logic;
      reset_n      : out std_logic;
      usb_txd_sync : out std_logic;
      ledr_0       : out std_logic);
  end component infrastructure;

  component i2c_master is
    port (
      clk          : in    std_logic;
      reset_n      : in    std_logic;
      write_i      : in    std_logic;
      write_data_i : in    std_logic_vector(15 downto 0);
      sda_io       : inout std_logic;
      scl_o        : out   std_logic;
      write_done_o : out   std_logic;
      ack_error_o  : out   std_logic);
  end component i2c_master;

  component codec_controller is
    port (
      mode         : in  std_logic_vector(2 downto 0);
      write_done_i : in  std_logic;
      ack_error_i  : in  std_logic;
      clk          : in  std_logic;
      reset_n      : in  std_logic;
      write_o      : out std_logic;
      write_data_o : out std_logic_vector(15 downto 0));
  end component codec_controller;

  component i2s_master is
    port (
      clk_12m     : in  std_logic;
      reset_n     : in  std_logic;
      load_o      : out std_logic;
      adcdat_pl_o : out std_logic_vector(15 downto 0);
      adcdat_pr_o : out std_logic_vector(15 downto 0);
      dacdat_pl_i : in  std_logic_vector(15 downto 0);
      dacdat_pr_i : in  std_logic_vector(15 downto 0);
      dacdat_s_o  : out std_logic;
      bclk_o      : out std_logic;
      ws_o        : out std_logic;
      adcdat_s_i  : in  std_logic);
  end component i2s_master;

  component path_control is
    port (
      sw_sync_3   : in  std_logic;
      dds_l_i     : in  std_logic_vector(15 downto 0);
      dds_r_i     : in  std_logic_vector(15 downto 0);
      adcdat_pl_i : in  std_logic_vector(15 downto 0);
      adcdat_pr_i : in  std_logic_vector(15 downto 0);
      dacdat_pl_o : out std_logic_vector(15 downto 0);
      dacdat_pr_o : out std_logic_vector(15 downto 0));
  end component path_control;
  
begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  -- instance "path_control"
  path_control_1: path_control
    port map (
      sw_sync_3   => SW(3),
      adcdat_pl_i => pl_master_out,
      adcdat_pr_i => pr_master_out,
		dds_r_i     => dds_r_i,
		dds_l_i     => dds_l_i, 
      dacdat_pl_o => pl_pathcon_out,
      dacdat_pr_o => pr_pathcon_out);
      
  -- instance "i2s_master"
  i2s_master_1: i2s_master
    port map (
      clk_12m     => sig_clk_12m,
      reset_n     => sig_reset_n,
      adcdat_pl_o => pl_master_out,
      adcdat_pr_o => pr_master_out,
      dacdat_pl_i => pl_pathcon_out,
      dacdat_pr_i => pr_pathcon_out,
      dacdat_s_o  => AUD_DACDAT,
      bclk_o      => AUD_BCLK,
      ws_o        => ws_o_int,
      adcdat_s_i  => AUD_ADCDAT);

  AUD_DACLRCK <= ws_o_int;
  AUD_ADCLRCK <= ws_o_int;
    
  -- instance "uart_top_1"
  uart_top_1: uart_top
    port map (
      clk         => sig_clk_12m,
      reset_n     => sig_reset_n,
      ser_data_i  => sig_usb_txd_sync,
      seg0_o      => HEX0,
      seg1_o      => HEX1);

  -- instance "infrastructure_1"
  infrastructure_1: infrastructure
    port map (
      clock_50     => CLOCK_50,
      key_0        => KEY_0,
      usb_txd      => USB_TXD,
      clk_12m      => sig_clk_12m,
      reset_n      => sig_reset_n,
      usb_txd_sync => sig_usb_txd_sync,
      ledr_0       => LEDR_0);

  -- instance "i2c_master_1"
  i2c_master_1: i2c_master
    port map (
      clk          => sig_clk_12m,
      reset_n      => sig_reset_n,
      write_i      => sig_write_o,
      write_data_i => sig_write_data_o,
      sda_io       => AUD_SDAT,
      scl_o        => AUD_SCLK,
      write_done_o => sig_write_done_i,
      ack_error_o  => sig_ack_error);

  -- instance "codec_controller_1"
  codec_controller_1: codec_controller
    port map (
      clk          => sig_clk_12m,
      reset_n      => sig_reset_n,
      mode         => SW(2 downto 0),
      write_done_i => sig_write_done_i,
      ack_error_i  => sig_ack_error,
      write_o      => sig_write_o,
      write_data_o => sig_write_data_o);

  AUD_XCK <= sig_clk_12m;
  
end architecture str;

-------------------------------------------------------------------------------
