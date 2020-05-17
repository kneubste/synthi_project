-------------------------------------------------------------------------------
-- Title      : infrastructure
-- Project    : 
-------------------------------------------------------------------------------
-- File       : infrastructure.vhd
-- Author     :   <Cyrill@DESKTOP-MRJOR86>
-- Company    : 
-- Created    : 2020-02-20
-- Last update: 2020-05-17
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: This is the Infrastructure blocke that contains the Modulo
-- divider, clock sync and the signal check.
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2020-02-20  1.0      Cyrill  Created
-- 2020-05-17  1.1      kneubste   Project-Contrl. & Beautify.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------------

entity infrastructure is
  port (clock_50     : in  std_logic;
        key_0        : in  std_logic;
        usb_txd      : in  std_logic;
        clk_12m      : out std_logic;
        reset_n      : out std_logic;
        usb_txd_sync : out std_logic;
        ledr_0       : out std_logic
        );

end entity infrastructure;

-------------------------------------------------------------------------------

architecture str of infrastructure is

-----------------------------------------------------------------------------
-- Internal signal declarations
-----------------------------------------------------------------------------
  signal sig_clk_12m : std_logic;

-----------------------------------------------------------------------------
-- Component declarations
-----------------------------------------------------------------------------

  component modulo_divider is
    port (
      clk     : in  std_logic;
      clk_div : out std_logic);
  end component modulo_divider;

  component clock_sync is
    port (
      data_in  : in  std_logic;
      clk      : in  std_logic;
      sync_out : out std_logic);
  end component clock_sync;

  component signal_checker is
    port (
      clk, reset_n : in  std_logic;
      data_in      : in  std_logic;
      led_blink    : out std_logic);
  end component signal_checker;

begin  -- architecture str

-----------------------------------------------------------------------------
-- Component instantiations
-----------------------------------------------------------------------------

-- instance "modulo_divider_1"
  modulo_divider_1 : modulo_divider
    port map (clk     => clock_50,
              clk_div => sig_clk_12m);

-- instance "clock_sync_1"
  clock_sync_1 : clock_sync
    port map (data_in  => key_0,
              clk      => sig_clk_12m,
              sync_out => reset_n);

-- instance "clock_sync_2"
  clock_sync_2 : clock_sync
    port map (data_in  => usb_txd,
              clk      => sig_clk_12m,
              sync_out => usb_txd_sync);

-- instance "signal_checker_1"
  signal_checker_1 : signal_checker
    port map (clk       => clock_50,
              reset_n   => key_0,
              data_in   => usb_txd,
              led_blink => ledr_0);

-----------------------------------------------------------------------------
-- cuncurrent assingments
-----------------------------------------------------------------------------
  clk_12m <= sig_clk_12m;

end architecture str;

-------------------------------------------------------------------------------
