onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group synthi_top /synthi_top_tb/CLOCK_50
add wave -noupdate -group synthi_top /synthi_top_tb/KEY_0
add wave -noupdate -group synthi_top /synthi_top_tb/KEY_1
add wave -noupdate -group synthi_top /synthi_top_tb/SW
add wave -noupdate -group synthi_top /synthi_top_tb/USB_RXD
add wave -noupdate -group synthi_top /synthi_top_tb/USB_TXD
add wave -noupdate -group synthi_top /synthi_top_tb/AUD_XCK
add wave -noupdate -group synthi_top /synthi_top_tb/AUD_DACDAT
add wave -noupdate -group synthi_top /synthi_top_tb/AUD_BCLK
add wave -noupdate -group synthi_top /synthi_top_tb/AUD_DACLRCK
add wave -noupdate -group synthi_top /synthi_top_tb/AUD_ADCLRCK
add wave -noupdate -group synthi_top /synthi_top_tb/AUD_ADCDAT
add wave -noupdate -group synthi_top /synthi_top_tb/AUD_SCLK
add wave -noupdate -group synthi_top /synthi_top_tb/AUD_SDAT
add wave -noupdate -group synthi_top /synthi_top_tb/LEDR_0
add wave -noupdate -group synthi_top /synthi_top_tb/HEX0
add wave -noupdate -group synthi_top /synthi_top_tb/HEX1
add wave -noupdate -group synthi_top /synthi_top_tb/HEX2
add wave -noupdate -group synthi_top /synthi_top_tb/HEX3
add wave -noupdate -group synthi_top /synthi_top_tb/reg_data0
add wave -noupdate -group synthi_top /synthi_top_tb/reg_data1
add wave -noupdate -group synthi_top /synthi_top_tb/reg_data2
add wave -noupdate -group synthi_top /synthi_top_tb/reg_data3
add wave -noupdate -group synthi_top /synthi_top_tb/reg_data4
add wave -noupdate -group synthi_top /synthi_top_tb/reg_data5
add wave -noupdate -group synthi_top /synthi_top_tb/reg_data6
add wave -noupdate -group synthi_top /synthi_top_tb/reg_data7
add wave -noupdate -group synthi_top /synthi_top_tb/reg_data8
add wave -noupdate -group synthi_top /synthi_top_tb/reg_data9
add wave -noupdate -expand -group tone_gen /synthi_top_tb/DUT/tone_generator_1/clk_12m
add wave -noupdate -expand -group tone_gen /synthi_top_tb/DUT/tone_generator_1/rst_n
add wave -noupdate -expand -group tone_gen /synthi_top_tb/DUT/tone_generator_1/tone_on_i
add wave -noupdate -expand -group tone_gen /synthi_top_tb/DUT/tone_generator_1/step_i
add wave -noupdate -expand -group tone_gen /synthi_top_tb/DUT/tone_generator_1/note_i
add wave -noupdate -expand -group tone_gen /synthi_top_tb/DUT/tone_generator_1/velocity_i
add wave -noupdate -expand -group tone_gen /synthi_top_tb/DUT/tone_generator_1/dds_o_array
add wave -noupdate -expand -group tone_gen /synthi_top_tb/DUT/tone_generator_1/sum_reg
add wave -noupdate -expand -group tone_gen /synthi_top_tb/DUT/tone_generator_1/next_sum_reg
add wave -noupdate -expand -group midi_controll /synthi_top_tb/DUT/midi_controller_1/clk_12m
add wave -noupdate -expand -group midi_controll /synthi_top_tb/DUT/midi_controller_1/reset_n
add wave -noupdate -expand -group midi_controll /synthi_top_tb/DUT/midi_controller_1/rx_data_rdy
add wave -noupdate -expand -group midi_controll /synthi_top_tb/DUT/midi_controller_1/rx_data
add wave -noupdate -expand -group midi_controll /synthi_top_tb/DUT/midi_controller_1/note_on
add wave -noupdate -expand -group midi_controll /synthi_top_tb/DUT/midi_controller_1/note_simple
add wave -noupdate -expand -group midi_controll /synthi_top_tb/DUT/midi_controller_1/velocity_simple
add wave -noupdate -expand -group midi_controll /synthi_top_tb/DUT/midi_controller_1/data_flag
add wave -noupdate -expand -group midi_controll /synthi_top_tb/DUT/midi_controller_1/fsm_state
add wave -noupdate -expand -group midi_controll /synthi_top_tb/DUT/midi_controller_1/next_fsm_state
add wave -noupdate -expand -group midi_controll /synthi_top_tb/DUT/midi_controller_1/data_flag_sig
add wave -noupdate -expand -group midi_controll /synthi_top_tb/DUT/midi_controller_1/next_data_flag_sig
add wave -noupdate -expand -group midi_controll /synthi_top_tb/DUT/midi_controller_1/note_on_sig
add wave -noupdate -expand -group midi_controll /synthi_top_tb/DUT/midi_controller_1/next_note_on_sig
add wave -noupdate -expand -group midi_controll /synthi_top_tb/DUT/midi_controller_1/note_simple_sig
add wave -noupdate -expand -group midi_controll /synthi_top_tb/DUT/midi_controller_1/next_note_simple_sig
add wave -noupdate -expand -group midi_controll /synthi_top_tb/DUT/midi_controller_1/velocity_simple_sig
add wave -noupdate -expand -group midi_controll /synthi_top_tb/DUT/midi_controller_1/next_velocity_simple_sig
add wave -noupdate -group midi_array /synthi_top_tb/DUT/midi_array1/clk_12m
add wave -noupdate -group midi_array /synthi_top_tb/DUT/midi_array1/reset_n
add wave -noupdate -group midi_array /synthi_top_tb/DUT/midi_array1/status_reg
add wave -noupdate -group midi_array /synthi_top_tb/DUT/midi_array1/data1_reg
add wave -noupdate -group midi_array /synthi_top_tb/DUT/midi_array1/data2_reg
add wave -noupdate -group midi_array /synthi_top_tb/DUT/midi_array1/new_data_flag
add wave -noupdate -group midi_array /synthi_top_tb/DUT/midi_array1/reg_note_on_o
add wave -noupdate -group midi_array /synthi_top_tb/DUT/midi_array1/reg_note_simple_o
add wave -noupdate -group midi_array /synthi_top_tb/DUT/midi_array1/reg_velocity_simple_o
add wave -noupdate -group midi_array /synthi_top_tb/DUT/midi_array1/reg_note_on
add wave -noupdate -group midi_array /synthi_top_tb/DUT/midi_array1/next_reg_note_on
add wave -noupdate -group midi_array /synthi_top_tb/DUT/midi_array1/reg_note
add wave -noupdate -group midi_array /synthi_top_tb/DUT/midi_array1/next_reg_note
add wave -noupdate -group midi_array /synthi_top_tb/DUT/midi_array1/reg_velocity
add wave -noupdate -group midi_array /synthi_top_tb/DUT/midi_array1/next_reg_velocity
add wave -noupdate -format Analog-Step -height 74 -max 269850.0 -expand /synthi_top_tb/DUT/tone_generator_1/dds_l_o
add wave -noupdate -format Analog-Step -height 74 -max 269850.0 -expand /synthi_top_tb/DUT/tone_generator_1/dds_r_o
add wave -noupdate -expand -group uart /synthi_top_tb/DUT/uart_top_1/clk
add wave -noupdate -expand -group uart /synthi_top_tb/DUT/uart_top_1/reset_n
add wave -noupdate -expand -group uart /synthi_top_tb/DUT/uart_top_1/ser_data_i
add wave -noupdate -expand -group uart /synthi_top_tb/DUT/uart_top_1/rx_data_rdy
add wave -noupdate -expand -group uart /synthi_top_tb/DUT/uart_top_1/seg0_o
add wave -noupdate -expand -group uart /synthi_top_tb/DUT/uart_top_1/seg1_o
add wave -noupdate -expand -group uart /synthi_top_tb/DUT/uart_top_1/rx_data
add wave -noupdate -expand -group uart /synthi_top_tb/DUT/uart_top_1/sig_baud_tick
add wave -noupdate -expand -group uart /synthi_top_tb/DUT/uart_top_1/sig_bit_count
add wave -noupdate -expand -group uart /synthi_top_tb/DUT/uart_top_1/sig_data_valid
add wave -noupdate -expand -group uart /synthi_top_tb/DUT/uart_top_1/sig_falling_puls
add wave -noupdate -expand -group uart /synthi_top_tb/DUT/uart_top_1/sig_hex_lsb_out
add wave -noupdate -expand -group uart /synthi_top_tb/DUT/uart_top_1/sig_hex_msb_out
add wave -noupdate -expand -group uart /synthi_top_tb/DUT/uart_top_1/sig_led_blink
add wave -noupdate -expand -group uart /synthi_top_tb/DUT/uart_top_1/sig_load_in
add wave -noupdate -expand -group uart /synthi_top_tb/DUT/uart_top_1/sig_parallel_data
add wave -noupdate -expand -group uart /synthi_top_tb/DUT/uart_top_1/sig_parallel_in
add wave -noupdate -expand -group uart /synthi_top_tb/DUT/uart_top_1/sig_seg_out_1
add wave -noupdate -expand -group uart /synthi_top_tb/DUT/uart_top_1/sig_seg_out_2
add wave -noupdate -expand -group uart /synthi_top_tb/DUT/uart_top_1/sig_shift_enable
add wave -noupdate -expand -group uart /synthi_top_tb/DUT/uart_top_1/sig_start_bit
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {135522 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 508
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {3568736 ns}
