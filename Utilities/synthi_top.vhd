-------------------------------------------------------------------------------
-- Title      : synthi_top
-- Project    : 
-------------------------------------------------------------------------------
-- File       : synthi_top.vhd
-- Author     :   <matth@DESKTOP-R2733AE>
-- Company    : 
-- Created    : 2020-02-23
-- Last update: 2020-02-24
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-02-23  1.0      matth   Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity synthi_top is

  port (SW          : in  std_logic_vector(9 downto 0);
        AUD_ADCDAT  : in  std_logic;
        CLOCK_50    : in  std_logic;
        KEY_0	    : in  std_logic;
        USB_TXD     : in  std_logic;
        AUD_XCK     : out std_logic;
        AUD_SCLK    : out std_logic;
        AUD_SDAT    : out std_logic;
        AUD_DACDAT  : out std_logic;
        AUD_BCLK    : out std_logic;
        AUD_DACLRCK : out std_logic;
        AUD_ADCLRCK : out std_logic;
        HEX0        : out std_logic_vector(6 downto 0);
        HEX1        : out std_logic_vector(6 downto 0);
        LEDR_0      : out std_logic
        );

end entity synthi_top;

-------------------------------------------------------------------------------

architecture str of synthi_top is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  signal clk_int      : std_logic;
  signal reset_n_int  : std_logic;
  signal ser_data_int : std_logic;

  -----------------------------------------------------------------------------
  -- Component declarations
  -----------------------------------------------------------------------------

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

  component uart_top is
    port (
      clk         : in  std_logic;
      reset_n     : in  std_logic;
      ser_data_i  : in  std_logic;
      rx_data     : out std_logic_vector (7 downto 0);
      seg0_o      : out std_logic_vector (6 downto 0);
      seg1_o      : out std_logic_vector (6 downto 0);
      rx_data_rdy : out std_logic);
  end component uart_top;

begin  -- architecture str

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  -- instance "infrastructure_1"
  infrastructure_1 : infrastructure
    port map (
      clock_50     => CLOCK_50,
      key_0        => KEY_0,
      usb_txd      => USB_TXD,
      clk_12m      => clk_int,
      reset_n      => reset_n_int,
      usb_txd_sync => ser_data_int,
      ledr_0       => LEDR_0);

  -- instance "uart_top_1"
  uart_top_1 : uart_top
    port map (
      clk         => clk_int,
      reset_n     => reset_n_int,
      ser_data_i  => ser_data_int,
      seg0_o      => HEX0,
      seg1_o      => HEX1);

end architecture str;

-------------------------------------------------------------------------------
