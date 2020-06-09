-------------------------------------------------------------------------------
-- Title      : uart_top
-- Project    : synthi_project
-------------------------------------------------------------------------------
-- File       : uart_top.vhd
-- Author     :   <Cyrill>
-- Company    : 
-- Created    : 2020-04-20
-- Last update: 2020-05-25
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: This building block contains multiple shiftregister and counters. 
-- 				 It's required for analysing data-packets and generating baud tick.
-------------------------------------------------------------------------------
-- Copyright (c) 2020 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date:       | Version:   | Author:   | Description:
-- 2020-04-20  | 1.0        | Cyrill    | Created
-- 2020-05-17  | 1.1        | kneubste  | Project-Contrl. & Beautify.
-- 2020-05-25  | 1.2        | lussimat  | auskommentiert & neu strukturiert
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;

-------------------------------------------------------------------------------

entity uart_top is
  port
    (
      clk         : in  std_logic;
      reset_n     : in  std_logic;
      ser_data_i  : in  std_logic;
      rx_data_rdy : out std_logic;
      seg0_o      : out std_logic_vector(6 downto 0);
      seg1_o      : out std_logic_vector(6 downto 0);
      rx_data     : out std_logic_vector(7 downto 0)
      );
end uart_top;

-------------------------------------------------------------------------------

architecture bdf_type of uart_top is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  signal sig_baud_tick           : std_logic;
  signal sig_bit_count           : std_logic_vector(3 downto 0);
  signal sig_data_valid          : std_logic;
  signal sig_falling_puls        : std_logic;
  signal sig_hex_lsb_out         : std_logic_vector(3 downto 0);
  signal sig_hex_msb_out         : std_logic_vector(3 downto 0);
  signal sig_led_blink           : std_logic;
  signal sig_load_in             : std_logic;
  signal sig_parallel_data       : std_logic_vector(9 downto 0);
  signal sig_parallel_in         : std_logic_vector(9 downto 0);
  signal sig_PIO2_Connected      : std_logic;
  signal sig_PIO5_status         : std_logic;
  signal sig_PIO_RF_Status       : std_logic;
  signal sig_seg_out_1           : std_logic_vector(6 downto 0);
  signal sig_seg_out_2           : std_logic_vector(6 downto 0);
  signal sig_serial_data_from_BT : std_logic;
  signal sig_shift_enable        : std_logic;
  signal sig_start_bit           : std_logic;
  signal SYNTHESIZED_WIRE_5      : std_logic;

  -----------------------------------------------------------------------------
  -- Component declarations
  -----------------------------------------------------------------------------

  component output_register
    generic (width : integer
             );
    port(clk         : in  std_logic;
         reset_n     : in  std_logic;
         data_valid  : in  std_logic;
         parallel_in : in  std_logic_vector(9 downto 0);
         hex_lsb_out : out std_logic_vector(3 downto 0);
         hex_msb_out : out std_logic_vector(3 downto 0)
         );
  end component;

  component shiftreg_uart
    generic (width : integer
             );
    port(clk          : in  std_logic;
         reset_n      : in  std_logic;
         load_in      : in  std_logic;
         serial_in    : in  std_logic;
         shift_enable : in  std_logic;
         parallel_in  : in  std_logic_vector(9 downto 0);
         serial_out   : out std_logic;
         parallel_out : out std_logic_vector(9 downto 0)
         );
  end component;

  component bus_hex2sevseg
    port(data_in : in  std_logic_vector(3 downto 0);
         seg_o   : out std_logic_vector(6 downto 0)
         );
  end component;

  component uart_controller_fsm
    port(clk           : in  std_logic;
         reset_n       : in  std_logic;
         falling_pulse : in  std_logic;
         baud_tick     : in  std_logic;
         bit_count     : in  std_logic_vector(3 downto 0);
         parallel_data : in  std_logic_vector(9 downto 0);
         shift_enable  : out std_logic;
         start_bit     : out std_logic;
         data_valid    : out std_logic
         );
  end component;

  component baud_tick
    generic (width : integer
             );
    port(clk       : in  std_logic;
         reset_n   : in  std_logic;
         start_bit : in  std_logic;
         baud_tick : out std_logic
         );
  end component;

  component bit_counter
    generic (width : integer
             );
    port(clk       : in  std_logic;
         reset_n   : in  std_logic;
         start_bit : in  std_logic;
         baud_tick : in  std_logic;
         bit_count : out std_logic_vector(3 downto 0)
         );
  end component;

  component flanken_detekt_vhdl
    port(data_in       : in  std_logic;
         clk           : in  std_logic;
         reset_n       : in  std_logic;
         rising_pulse  : out std_logic;
         falling_pulse : out std_logic
         );
  end component;
  
  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

begin

  b2v_inst : output_register
    generic map(width => 10
                )
    port map(clk         => clk,
             reset_n     => reset_n,
             data_valid  => sig_data_valid,
             parallel_in => sig_parallel_data,
             hex_lsb_out => sig_hex_lsb_out,
             hex_msb_out => sig_hex_msb_out);

  b2v_inst11 : shiftreg_uart
    generic map(width => 10
                )
    port map(clk          => clk,
             reset_n      => reset_n,
             load_in      => sig_load_in,
             serial_in    => ser_data_i,
             shift_enable => sig_shift_enable,
             parallel_in  => sig_parallel_in,
             parallel_out => sig_parallel_data);

  b2v_inst14 : bus_hex2sevseg
    port map(data_in => sig_hex_lsb_out,
             seg_o   => seg0_o);


  b2v_inst15 : bus_hex2sevseg
    port map(data_in => sig_hex_msb_out,
             seg_o   => seg1_o);

  b2v_inst3 : uart_controller_fsm

    port map(clk           => clk,
             reset_n       => reset_n,
             falling_pulse => sig_falling_puls,
             baud_tick     => sig_baud_tick,
             bit_count     => sig_bit_count,
             parallel_data => sig_parallel_data,
             shift_enable  => sig_shift_enable,
             start_bit     => sig_start_bit,
             data_valid    => sig_data_valid);

  b2v_inst5 : baud_tick
    generic map(width => 10
                )
    port map(clk       => clk,
             reset_n   => reset_n,
             start_bit => sig_start_bit,
             baud_tick => sig_baud_tick);

  b2v_inst6 : bit_counter
    generic map(width => 4
                )
    port map(clk       => clk,
             reset_n   => reset_n,
             start_bit => sig_start_bit,
             baud_tick => sig_baud_tick,
             bit_count => sig_bit_count);

  b2v_inst7 : flanken_detekt_vhdl
    port map(data_in       => ser_data_i,
             clk           => clk,
             reset_n       => reset_n,
             falling_pulse => sig_falling_puls);
				 

  rx_data         <= sig_parallel_data(8 downto 1);
  sig_load_in     <= '0';
  sig_parallel_in <= std_logic_vector(to_unsigned(0, 10)); 
  rx_data_rdy     <= sig_data_valid;

end bdf_type;
