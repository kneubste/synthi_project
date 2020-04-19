onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /synthi_top_tb/SW
add wave -noupdate -group tonegen /synthi_top_tb/DUT/tone_generator_1/clk_12m
add wave -noupdate -group tonegen /synthi_top_tb/DUT/tone_generator_1/rst_n
add wave -noupdate -group tonegen /synthi_top_tb/DUT/tone_generator_1/tone_on_i
add wave -noupdate -group tonegen /synthi_top_tb/DUT/tone_generator_1/step_i
add wave -noupdate -group tonegen /synthi_top_tb/DUT/tone_generator_1/note_i
add wave -noupdate -group tonegen /synthi_top_tb/DUT/tone_generator_1/velocity_i
add wave -noupdate -group tonegen /synthi_top_tb/DUT/tone_generator_1/dds_l_o
add wave -noupdate -group tonegen /synthi_top_tb/DUT/tone_generator_1/dds_r_o
add wave -noupdate -group tonegen /synthi_top_tb/DUT/tone_generator_1/dds_tone_gene
add wave -noupdate -expand -group dds /synthi_top_tb/DUT/tone_generator_1/dds_1/clk_12m
add wave -noupdate -expand -group dds /synthi_top_tb/DUT/tone_generator_1/dds_1/reset_n
add wave -noupdate -expand -group dds /synthi_top_tb/DUT/tone_generator_1/dds_1/step_i
add wave -noupdate -expand -group dds /synthi_top_tb/DUT/tone_generator_1/dds_1/tone_on_i
add wave -noupdate -expand -group dds /synthi_top_tb/DUT/tone_generator_1/dds_1/phi_incr_i
add wave -noupdate -expand -group dds /synthi_top_tb/DUT/tone_generator_1/dds_1/attenu_i
add wave -noupdate -expand -group dds -format Analog-Step -height 74 -max 4095.0 -min -4096.0 -radix decimal /synthi_top_tb/DUT/tone_generator_1/dds_1/dds_o
add wave -noupdate -expand -group dds -radix decimal -radixshowbase 0 /synthi_top_tb/DUT/tone_generator_1/dds_1/count
add wave -noupdate -expand -group dds -radix decimal -radixshowbase 0 /synthi_top_tb/DUT/tone_generator_1/dds_1/next_count
add wave -noupdate -expand -group dds -format Analog-Step -height 74 -max 4095.0 -min -4096.0 -radix decimal -radixshowbase 0 /synthi_top_tb/DUT/tone_generator_1/dds_1/lut_val
add wave -noupdate -expand -group dds /synthi_top_tb/DUT/tone_generator_1/dds_1/lut_addr
add wave -noupdate -expand -group dds /synthi_top_tb/DUT/tone_generator_1/dds_1/atte
add wave -noupdate -format Analog-Step -height 74 -max 4095.0 -min -4096.0 -radix decimal /synthi_top_tb/DUT/i2s_master_1/dacdat_pl_i
add wave -noupdate -format Analog-Step -height 74 -max 4095.0 -min -4096.0 -radix decimal /synthi_top_tb/DUT/i2s_master_1/dacdat_pr_i
add wave -noupdate -group path /synthi_top_tb/DUT/path_control_1/sw_sync_3
add wave -noupdate -group path /synthi_top_tb/DUT/path_control_1/dds_l_i
add wave -noupdate -group path /synthi_top_tb/DUT/path_control_1/dds_r_i
add wave -noupdate -group path /synthi_top_tb/DUT/path_control_1/adcdat_pl_i
add wave -noupdate -group path /synthi_top_tb/DUT/path_control_1/adcdat_pr_i
add wave -noupdate -group path /synthi_top_tb/DUT/path_control_1/dacdat_pl_o
add wave -noupdate -group path /synthi_top_tb/DUT/path_control_1/dacdat_pr_o
add wave -noupdate -group i2s /synthi_top_tb/DUT/i2s_master_1/clk_12m
add wave -noupdate -group i2s /synthi_top_tb/DUT/i2s_master_1/reset_n
add wave -noupdate -group i2s /synthi_top_tb/DUT/i2s_master_1/load_o
add wave -noupdate -group i2s /synthi_top_tb/DUT/i2s_master_1/adcdat_pl_o
add wave -noupdate -group i2s /synthi_top_tb/DUT/i2s_master_1/adcdat_pr_o
add wave -noupdate -group i2s /synthi_top_tb/DUT/i2s_master_1/dacdat_s_o
add wave -noupdate -group i2s /synthi_top_tb/DUT/i2s_master_1/bclk_o
add wave -noupdate -group i2s /synthi_top_tb/DUT/i2s_master_1/ws_o
add wave -noupdate -group i2s /synthi_top_tb/DUT/i2s_master_1/adcdat_s_i
add wave -noupdate -group i2s /synthi_top_tb/DUT/i2s_master_1/load_int
add wave -noupdate -group i2s /synthi_top_tb/DUT/i2s_master_1/bclk_int
add wave -noupdate -group i2s /synthi_top_tb/DUT/i2s_master_1/shift_l_int
add wave -noupdate -group i2s /synthi_top_tb/DUT/i2s_master_1/shift_r_int
add wave -noupdate -group i2s /synthi_top_tb/DUT/i2s_master_1/ser_l_out
add wave -noupdate -group i2s /synthi_top_tb/DUT/i2s_master_1/ser_r_out
add wave -noupdate -group i2s /synthi_top_tb/DUT/i2s_master_1/clk_12m_int
add wave -noupdate -group i2s /synthi_top_tb/DUT/i2s_master_1/adcdat_s_int
add wave -noupdate -group i2s /synthi_top_tb/DUT/i2s_master_1/ws_int
add wave -noupdate -group i2s /synthi_top_tb/DUT/i2s_master_1/reset_n_int
add wave -noupdate /synthi_top_tb/AUD_DACDAT
add wave -noupdate /synthi_top_tb/AUD_ADCDAT
add wave -noupdate /synthi_top_tb/dacdat_check
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {617550 ns} 0}
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
WaveRestoreZoom {1094281 ns} {9390732 ns}
