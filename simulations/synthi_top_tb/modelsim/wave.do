onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/CLOCK_50
add wave -noupdate /synthi_top_tb/KEY_0
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/frame_generator/bit_counter
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/load_o
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/adcdat_pl_o
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/adcdat_pr_o
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/dacdat_pl_i
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/dacdat_pr_i
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/bclk_o
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/ws_o
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/shift_l_int
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/shift_r_int
add wave -noupdate /synthi_top_tb/SW
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/adcdat_s_i
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/dacdat_s_o
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/clk_12m
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/frame_generator/clk_12m
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/frame_generator/bclk
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/frame_generator/load
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/frame_generator/shift_l
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/frame_generator/shift_r
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/frame_generator/ws
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/frame_generator/bit_counter
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/frame_generator/ws_int
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/frame_generator/load_int
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/frame_generator/shift_l_int
add wave -noupdate /synthi_top_tb/DUT/i2s_master_1/frame_generator/shift_r_int
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1378459 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 368
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
WaveRestoreZoom {0 ns} {93272 ns}
