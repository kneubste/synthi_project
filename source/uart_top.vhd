-- Copyright (C) 2018  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details.

-- PROGRAM		"Quartus Prime"
-- VERSION		"Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"
-- CREATED		"Mon Feb 17 11:01:37 2020"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY uart_top IS 
	PORT
	(
		clk 			:  IN  STD_LOGIC;
		reset_n 		:  IN  STD_LOGIC; 
		ser_data_i 	:  IN  STD_LOGIC;
		rx_data_rdy :  OUT  STD_LOGIC;
		seg0_o 		:  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		seg1_o 		:  OUT  STD_LOGIC_VECTOR(6 DOWNTO 0);
		rx_data 		: 	OUT  STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END uart_top;

ARCHITECTURE bdf_type OF uart_top IS 

COMPONENT output_register
GENERIC (width : INTEGER
			);
	PORT(clk 		 : IN STD_LOGIC;
		 reset_n 	 : IN STD_LOGIC;
		 data_valid  : IN STD_LOGIC;
		 parallel_in : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 hex_lsb_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
		 hex_msb_out : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
END COMPONENT;

COMPONENT shiftreg_uart
GENERIC (width : INTEGER
			);
	PORT(clk				: IN STD_LOGIC;
		 reset_n 		: IN STD_LOGIC;
		 load_in 		: IN STD_LOGIC;
		 serial_in 		: IN STD_LOGIC;
		 shift_enable  : IN STD_LOGIC;
		 parallel_in 	: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 serial_out 	: OUT STD_LOGIC;
		 parallel_out  : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END COMPONENT;

COMPONENT bus_hex2sevseg
	PORT(data_in : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		 seg_o  	 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)
	);
END COMPONENT;

COMPONENT uart_controller_fsm
GENERIC (width : INTEGER
			);
	PORT(clk				: IN STD_LOGIC;
		 reset_n 		: IN STD_LOGIC;
		 falling_pulse : IN STD_LOGIC;
		 baud_tick 		: IN STD_LOGIC;
		 bit_count 		: IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 parallel_data : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
		 shift_enable 	: OUT STD_LOGIC;
		 start_bit 		: OUT STD_LOGIC;
		 data_valid 	: OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT baud_tick
GENERIC (width : INTEGER
			);
	PORT(clk 		: IN STD_LOGIC;
		 reset_n		: IN STD_LOGIC;
		 start_bit 	: IN STD_LOGIC;
		 baud_tick 	: OUT STD_LOGIC
	);
END COMPONENT;

COMPONENT bit_counter
GENERIC (width : INTEGER
			);
	PORT(clk 		: IN STD_LOGIC;
		 reset_n		: IN STD_LOGIC;
		 start_bit 	: IN STD_LOGIC;
		 baud_tick 	: IN STD_LOGIC;
		 bit_count 	: OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
	);
END COMPONENT;

COMPONENT flanken_detekt_vhdl
	PORT(data_in		: IN STD_LOGIC;
		 clk 				: IN STD_LOGIC;
		 reset_n 		: IN STD_LOGIC;
		 rising_pulse 	: OUT STD_LOGIC;
		 falling_pulse : OUT STD_LOGIC
	);
END COMPONENT;

SIGNAL	sig_baud_tick 				:  STD_LOGIC;
SIGNAL	sig_bit_count 				:  STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL	sig_data_valid 			:  STD_LOGIC;
SIGNAL	sig_falling_puls 			:  STD_LOGIC;
SIGNAL	sig_hex_lsb_out 			:  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	sig_hex_msb_out 			:  STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL	sig_led_blink 				:  STD_LOGIC;
SIGNAL	sig_load_in 				:  STD_LOGIC;
SIGNAL	sig_parallel_data 		:  STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL	sig_parallel_in 			:  STD_LOGIC_VECTOR(9 DOWNTO 0);
SIGNAL	sig_PIO2_Connected		:  STD_LOGIC;
SIGNAL	sig_PIO5_status 			:  STD_LOGIC;
SIGNAL	sig_PIO_RF_Status 		:  STD_LOGIC;
SIGNAL	sig_seg_out_1 				:  STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL	sig_seg_out_2 				:  STD_LOGIC_VECTOR(6 DOWNTO 0);
SIGNAL	sig_serial_data_from_BT :  STD_LOGIC;
SIGNAL	sig_shift_enable 			:  STD_LOGIC;
SIGNAL	sig_start_bit 				:  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_5 		:  STD_LOGIC;


BEGIN 

rx_data <= sig_parallel_data(8 downto 1);
sig_load_in <= '0';
sig_parallel_in <= "0000000000";
rx_data_rdy <= sig_data_valid;


b2v_inst : output_register
GENERIC MAP(width => 10
			)
PORT MAP(clk			=> clk,
			reset_n 		=> reset_n,
			data_valid	=> sig_data_valid,
			parallel_in => sig_parallel_data,
			hex_lsb_out => sig_hex_lsb_out,
			hex_msb_out => sig_hex_msb_out);

b2v_inst11 : shiftreg_uart
GENERIC MAP(width => 10
			)
PORT MAP(clk				=> clk,
			reset_n			=> reset_n,
			load_in			=> sig_load_in,
			serial_in 		=> ser_data_i,
			shift_enable	=> sig_shift_enable,
			parallel_in		=> sig_parallel_in,
			parallel_out	=> sig_parallel_data);

b2v_inst14 : bus_hex2sevseg
PORT MAP(data_in	=> sig_hex_lsb_out,
			seg_o		=> seg0_o);


b2v_inst15 : bus_hex2sevseg
PORT MAP(data_in	=> sig_hex_msb_out,
			seg_o		=> seg1_o);

b2v_inst3 : uart_controller_fsm
GENERIC MAP(width => 10
			)
PORT MAP(clk 				=> clk,
			reset_n 			=> reset_n,
			falling_pulse 	=> sig_falling_puls,
			baud_tick 		=> sig_baud_tick,
			bit_count 		=> sig_bit_count,
			parallel_data 	=> sig_parallel_data,
			shift_enable 	=> sig_shift_enable,
			start_bit 		=> sig_start_bit,
			data_valid 		=> sig_data_valid);

b2v_inst5 : baud_tick
GENERIC MAP(width => 10
			)
PORT MAP(clk		 => clk,
			reset_n	 => reset_n,
			start_bit => sig_start_bit,
			baud_tick => sig_baud_tick);

b2v_inst6 : bit_counter
GENERIC MAP(width => 10
			)
PORT MAP(clk		 => clk,
			reset_n 	 => reset_n,
			start_bit => sig_start_bit,
			baud_tick => sig_baud_tick,
			bit_count => sig_bit_count);

b2v_inst7 : flanken_detekt_vhdl
PORT MAP(data_in			=> ser_data_i,
			clk 				=> clk,
			reset_n			=> reset_n,
			falling_pulse	=> sig_falling_puls);


END bdf_type;