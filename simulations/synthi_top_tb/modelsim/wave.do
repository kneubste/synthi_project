onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/CLOCK_50
add wave -noupdate /synthi_top_tb/KEY_0
add wave -noupdate /synthi_top_tb/DUT/uart_top_1/b2v_inst11/parallel_out
add wave -noupdate /synthi_top_tb/DUT/uart_top_1/b2v_inst/parallel_in
add wave -noupdate /synthi_top_tb/DUT/uart_top_1/b2v_inst3/parallel_data
add wave -noupdate /synthi_top_tb/DUT/uart_top_1/ser_data_i
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/uart_top_1/b2v_inst/parallel_in
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/uart_top_1/sig_hex_msb_out
add wave -noupdate /synthi_top_tb/DUT/uart_top_1/b2v_inst15/data_in
add wave -noupdate /synthi_top_tb/DUT/uart_top_1/b2v_inst15/seg_o
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/uart_top_1/seg1_o
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/uart_top_1/sig_hex_lsb_out
add wave -noupdate /synthi_top_tb/DUT/uart_top_1/b2v_inst14/data_in
add wave -noupdate /synthi_top_tb/DUT/uart_top_1/b2v_inst14/seg_o
add wave -noupdate -radix hexadecimal /synthi_top_tb/DUT/uart_top_1/seg0_o
add wave -noupdate /synthi_top_tb/DUT/uart_top_1/b2v_inst/data_valid
add wave -noupdate /synthi_top_tb/DUT/uart_top_1/rx_data
add wave -noupdate /synthi_top_tb/DUT/uart_top_1/rx_data_rdy
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/frame_generator/bit_counter
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/load_o
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/adcdat_pl_o
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/adcdat_pr_o
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/dacdat_pl_i
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/dacdat_pr_i
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/dacdat_s_o
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/bclk_o
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/ws_o
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/shift_l_int
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/shift_r_int
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {166 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 335
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
WaveRestoreZoom {49587533 ns} {50021709 ns}
