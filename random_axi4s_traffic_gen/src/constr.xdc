# Main Clock constraint
set_property -dict {PACKAGE_PIN H16 IOSTANDARD LVCMOS33} [get_ports sysclk]
create_clock -period 8.000 -name sys_clk_pin -waveform {0.000 4.000} -add [get_ports sysclk]
create_generated_clock -name clk_out1 -source [get_ports sysclk] -multiply_by 1 -add -master_clock sysclk [get_ports sysclk]

# CDC
set_clock_groups -physically_exclusive -group [get_clocks -include_generated_clocks sys_clk_pin] -group [get_clocks -include_generated_clocks sysclk]
set_clock_groups -physically_exclusive -group [get_clocks -include_generated_clocks clkfbout_top_clk_wiz_0_0] -group [get_clocks -include_generated_clocks clkfbout_top_clk_wiz_0_0_1] -group [get_clocks -include_generated_clocks clkfbout_top_clk_wiz_0_0_2]
set_clock_groups -physically_exclusive -group [get_clocks -include_generated_clocks clk_out1_top_clk_wiz_0_0] -group [get_clocks -include_generated_clocks clk_out1_top_clk_wiz_0_0_1] -group [get_clocks -include_generated_clocks clk_out1_top_clk_wiz_0_0_2]
set_clock_groups -logically_exclusive -group [get_clocks -include_generated_clocks {clk_out1_top_clk_wiz_0_0_1 clkfbout_top_clk_wiz_0_0_1}] -group [get_clocks -include_generated_clocks {clk_out1_top_clk_wiz_0_0_2 clkfbout_top_clk_wiz_0_0_2}] -group [get_clocks -include_generated_clocks {clk_out1_top_clk_wiz_0_0 clkfbout_top_clk_wiz_0_0}]