# create work library
vlib work

# compile project files
vcom -2008 -explicit -work work ../../support/simulation_pkg.vhd
vcom -2008 -explicit -work work ../../support/standard_driver_pkg.vhd
vcom -2008 -explicit -work work ../../support/user_driver_pkg.vhd
vcom -2008 -explicit -work work ../../support/reg_table_pkg.vhd
vcom -2008 -explicit -work work ../../../source/toneGenerator/tone_gen_pkg.vhd
vcom -2008 -explicit -work work ../../../source/midi/midi_controller.vhd
vcom -2008 -explicit -work work ../../../source/midi/midi_array.vhd
vcom -2008 -explicit -work work ../../../source/midi/baud_tick.vhd
vcom -2008 -explicit -work work ../../../source/midi/bit_counter.vhd
vcom -2008 -explicit -work work ../../../source/midi/bus_hex2sevseg.vhd
vcom -2008 -explicit -work work ../../../source/infrastructure/clock_sync.vhd
vcom -2008 -explicit -work work ../../../source/count_down.vhd
vcom -2008 -explicit -work work ../../../source/codec_controller.vhd
vcom -2008 -explicit -work work ../../../source/midi/flanken_detekt_vhdl.vhd
vcom -2008 -explicit -work work ../../../source/midi/midi_array.vhd
vcom -2008 -explicit -work work ../../../source/i2c/i2c_slave_bfm.vhd
vcom -2008 -explicit -work work ../../../source/i2c/i2c_master.vhd
vcom -2008 -explicit -work work ../../../source/infrastructure.vhd
vcom -2008 -explicit -work work ../../../source/infrastructure/modulo_divider.vhd
vcom -2008 -explicit -work work ../../../source/midi/output_register.vhd
vcom -2008 -explicit -work work ../../../source/midi/shiftreg_uart.vhd
vcom -2008 -explicit -work work ../../../source/infrastructure/signal_checker.vhd
vcom -2008 -explicit -work work ../../../source/synthi_top_tb.vhd
vcom -2008 -explicit -work work ../../../source/synthi_top.vhd
vcom -2008 -explicit -work work ../../../source/midi/uart_controller_fsm.vhd
vcom -2008 -explicit -work work ../../../source/uart_top.vhd
vcom -2008 -explicit -work work ../../../source/path_control.vhd
vcom -2008 -explicit -work work ../../../source/I2s/i2s_frame_generator.vhd
vcom -2008 -explicit -work work ../../../source/I2s/i2s_master.vhd
vcom -2008 -explicit -work work ../../../source/I2s/universal_shiftreg.vhd
vcom -2008 -explicit -work work ../../../source/toneGenerator/tone_generator.vhd
vcom -2008 -explicit -work work ../../../source/toneGenerator/dds.vhd
vcom -2008 -explicit -work work ../../../source/synthi_top.vhd
vcom -2008 -explicit -work work ../../../source/synthi_top_tb.vhd


# run the simulation
vsim -novopt -t 1ns -lib work work.synthi_top_tb
do ./wave.do
run 500 ms
