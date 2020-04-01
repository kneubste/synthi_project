onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/SW
add wave -noupdate -group PathControl /synthi_top_tb/DUT/path_control_1/sw_sync_3
add wave -noupdate -group PathControl /synthi_top_tb/DUT/path_control_1/dds_l_i
add wave -noupdate -group PathControl /synthi_top_tb/DUT/path_control_1/dds_r_i
add wave -noupdate -group PathControl /synthi_top_tb/DUT/path_control_1/adcdat_pl_i
add wave -noupdate -group PathControl /synthi_top_tb/DUT/path_control_1/adcdat_pr_i
add wave -noupdate -group PathControl /synthi_top_tb/DUT/path_control_1/dacdat_pl_o
add wave -noupdate -group PathControl /synthi_top_tb/DUT/path_control_1/dacdat_pr_o
add wave -noupdate -group FrameGenerator /synthi_top_tb/DUT/i2s_master_1/frame_generator/rst_n_12m
add wave -noupdate -group FrameGenerator /synthi_top_tb/DUT/i2s_master_1/frame_generator/clk_12m
add wave -noupdate -group FrameGenerator /synthi_top_tb/DUT/i2s_master_1/frame_generator/bclk
add wave -noupdate -group FrameGenerator /synthi_top_tb/DUT/i2s_master_1/frame_generator/load
add wave -noupdate -group FrameGenerator /synthi_top_tb/DUT/i2s_master_1/frame_generator/shift_l
add wave -noupdate -group FrameGenerator /synthi_top_tb/DUT/i2s_master_1/frame_generator/shift_r
add wave -noupdate -group FrameGenerator /synthi_top_tb/DUT/i2s_master_1/frame_generator/ws
add wave -noupdate -group FrameGenerator /synthi_top_tb/DUT/i2s_master_1/frame_generator/next_fsm_state
add wave -noupdate -group FrameGenerator /synthi_top_tb/DUT/i2s_master_1/frame_generator/fsm_state
add wave -noupdate -group FrameGenerator /synthi_top_tb/DUT/i2s_master_1/frame_generator/width
add wave -noupdate -group FrameGenerator /synthi_top_tb/DUT/i2s_master_1/frame_generator/div_count
add wave -noupdate -group FrameGenerator /synthi_top_tb/DUT/i2s_master_1/frame_generator/div_next_count
add wave -noupdate -group FrameGenerator /synthi_top_tb/DUT/i2s_master_1/frame_generator/bit_counter
add wave -noupdate -group FrameGenerator /synthi_top_tb/DUT/i2s_master_1/frame_generator/next_bit_counter
add wave -noupdate -group FrameGenerator /synthi_top_tb/DUT/i2s_master_1/frame_generator/ws_int
add wave -noupdate -group FrameGenerator /synthi_top_tb/DUT/i2s_master_1/frame_generator/load_int
add wave -noupdate -group FrameGenerator /synthi_top_tb/DUT/i2s_master_1/frame_generator/bclk_int
add wave -noupdate -group FrameGenerator /synthi_top_tb/DUT/i2s_master_1/frame_generator/shift_l_int
add wave -noupdate -group FrameGenerator /synthi_top_tb/DUT/i2s_master_1/frame_generator/shift_r_int
add wave -noupdate -group I2sMaster /synthi_top_tb/DUT/i2s_master_1/clk_12m
add wave -noupdate -group I2sMaster /synthi_top_tb/DUT/i2s_master_1/reset_n
add wave -noupdate -group I2sMaster /synthi_top_tb/DUT/i2s_master_1/load_o
add wave -noupdate -group I2sMaster /synthi_top_tb/DUT/i2s_master_1/adcdat_pl_o
add wave -noupdate -group I2sMaster /synthi_top_tb/DUT/i2s_master_1/adcdat_pr_o
add wave -noupdate -group I2sMaster /synthi_top_tb/DUT/i2s_master_1/dacdat_pl_i
add wave -noupdate -group I2sMaster /synthi_top_tb/DUT/i2s_master_1/dacdat_pr_i
add wave -noupdate -group I2sMaster /synthi_top_tb/DUT/i2s_master_1/dacdat_s_o
add wave -noupdate -group I2sMaster /synthi_top_tb/DUT/i2s_master_1/bclk_o
add wave -noupdate -group I2sMaster /synthi_top_tb/DUT/i2s_master_1/ws_o
add wave -noupdate -group I2sMaster /synthi_top_tb/DUT/i2s_master_1/adcdat_s_i
add wave -noupdate -group I2sMaster /synthi_top_tb/DUT/i2s_master_1/load_int
add wave -noupdate -group I2sMaster /synthi_top_tb/DUT/i2s_master_1/bclk_int
add wave -noupdate -group I2sMaster /synthi_top_tb/DUT/i2s_master_1/shift_l_int
add wave -noupdate -group I2sMaster /synthi_top_tb/DUT/i2s_master_1/shift_r_int
add wave -noupdate -group I2sMaster /synthi_top_tb/DUT/i2s_master_1/ser_l_out
add wave -noupdate -group I2sMaster /synthi_top_tb/DUT/i2s_master_1/ser_r_out
add wave -noupdate -group I2sMaster /synthi_top_tb/DUT/i2s_master_1/clk_12m_int
add wave -noupdate -group I2sMaster /synthi_top_tb/DUT/i2s_master_1/adcdat_s_int
add wave -noupdate -group I2sMaster /synthi_top_tb/DUT/i2s_master_1/ws_int
add wave -noupdate -group I2sMaster /synthi_top_tb/DUT/i2s_master_1/reset_n_int
add wave -noupdate -group CodecControl /synthi_top_tb/DUT/codec_controller_1/mode
add wave -noupdate -group CodecControl /synthi_top_tb/DUT/codec_controller_1/write_done_i
add wave -noupdate -group CodecControl /synthi_top_tb/DUT/codec_controller_1/ack_error_i
add wave -noupdate -group CodecControl /synthi_top_tb/DUT/codec_controller_1/clk
add wave -noupdate -group CodecControl /synthi_top_tb/DUT/codec_controller_1/reset_n
add wave -noupdate -group CodecControl /synthi_top_tb/DUT/codec_controller_1/write_o
add wave -noupdate -group CodecControl /synthi_top_tb/DUT/codec_controller_1/write_data_o
add wave -noupdate -group CodecControl /synthi_top_tb/DUT/codec_controller_1/fsm_state
add wave -noupdate -group CodecControl /synthi_top_tb/DUT/codec_controller_1/next_fsm_state
add wave -noupdate -group CodecControl /synthi_top_tb/DUT/codec_controller_1/count
add wave -noupdate -group CodecControl /synthi_top_tb/DUT/codec_controller_1/next_count
add wave -noupdate -group AudioFrame /synthi_top_tb/DUT/i2s_master_1/clk_12m
add wave -noupdate -group AudioFrame /synthi_top_tb/DUT/i2s_master_1/frame_generator/bclk
add wave -noupdate -group AudioFrame /synthi_top_tb/DUT/i2s_master_1/frame_generator/bit_counter
add wave -noupdate -group AudioFrame /synthi_top_tb/DUT/i2s_master_1/ws_o
add wave -noupdate -group AudioFrame /synthi_top_tb/DUT/i2s_master_1/dacdat_pl_i
add wave -noupdate -group AudioFrame /synthi_top_tb/DUT/i2s_master_1/adcdat_pl_o
add wave -noupdate -group AudioFrame /synthi_top_tb/DUT/i2s_master_1/dacdat_pr_i
add wave -noupdate -group AudioFrame /synthi_top_tb/DUT/i2s_master_1/adcdat_pr_o
add wave -noupdate -group AudioFrame /synthi_top_tb/DUT/i2s_master_1/frame_generator/shift_l
add wave -noupdate -group AudioFrame /synthi_top_tb/DUT/i2s_master_1/frame_generator/shift_r
add wave -noupdate -group AudioFrame /synthi_top_tb/DUT/i2s_master_1/frame_generator/load
add wave -noupdate /synthi_top_tb/dacdat_check
add wave -noupdate -expand -group {New Group} /synthi_top_tb/DUT/i2s_master_1/adcdat_pl_o
add wave -noupdate -expand -group {New Group} /synthi_top_tb/DUT/i2s_master_1/adcdat_pr_o
add wave -noupdate -expand -group {New Group} /synthi_top_tb/DUT/i2s_master_1/dacdat_pl_i
add wave -noupdate -expand -group {New Group} /synthi_top_tb/DUT/i2s_master_1/dacdat_pr_i
add wave -noupdate -expand -group {New Group} /synthi_top_tb/DUT/i2s_master_1/dacdat_s_o
add wave -noupdate -expand -group {New Group} /synthi_top_tb/DUT/i2s_master_1/adcdat_s_i
add wave -noupdate -expand -group {New Group} /synthi_top_tb/DUT/path_control_1/sw_sync_3
add wave -noupdate -expand -group {New Group} /synthi_top_tb/DUT/path_control_1/dds_l_i
add wave -noupdate -expand -group {New Group} /synthi_top_tb/DUT/path_control_1/dds_r_i
add wave -noupdate -expand -group {New Group} /synthi_top_tb/DUT/path_control_1/adcdat_pl_i
add wave -noupdate -expand -group {New Group} /synthi_top_tb/DUT/path_control_1/adcdat_pr_i
add wave -noupdate -expand -group {New Group} /synthi_top_tb/DUT/path_control_1/dacdat_pl_o
add wave -noupdate -expand -group {New Group} /synthi_top_tb/DUT/path_control_1/dacdat_pr_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {23630 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 444
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
WaveRestoreZoom {0 ns} {66849 ns}
