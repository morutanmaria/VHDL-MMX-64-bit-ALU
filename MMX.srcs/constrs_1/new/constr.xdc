## Clock signal
set_property PACKAGE_PIN W5 [get_ports CLK]							
	set_property IOSTANDARD LVCMOS33 [get_ports CLK]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports CLK]
 
## Switches
# SW[0] and SW[1] - Select which 16-bit part of the result to view
set_property PACKAGE_PIN V17 [get_ports {SW[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SW[0]}]
set_property PACKAGE_PIN V16 [get_ports {SW[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SW[1]}]

# SW[13], SW[14], SW[15] - Select the Operation (OPCODE)
set_property PACKAGE_PIN U1 [get_ports {SW[13]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SW[13]}]
set_property PACKAGE_PIN T1 [get_ports {SW[14]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SW[14]}]
set_property PACKAGE_PIN R2 [get_ports {SW[15]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SW[15]}]
 
## LEDs
# LED[0-3] show the current ROM Address
set_property PACKAGE_PIN U16 [get_ports {LED[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]
set_property PACKAGE_PIN E19 [get_ports {LED[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}]
set_property PACKAGE_PIN U19 [get_ports {LED[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
set_property PACKAGE_PIN V19 [get_ports {LED[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]
# Status LEDs
set_property PACKAGE_PIN W18 [get_ports {LED[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED[4]}]
set_property PACKAGE_PIN U15 [get_ports {LED[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED[5]}]
set_property PACKAGE_PIN U14 [get_ports {LED[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED[6]}]
set_property PACKAGE_PIN V14 [get_ports {LED[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {LED[7]}]
	
## 7 segment display
set_property PACKAGE_PIN W7 [get_ports {SEG[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SEG[0]}]
set_property PACKAGE_PIN W6 [get_ports {SEG[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SEG[1]}]
set_property PACKAGE_PIN U8 [get_ports {SEG[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SEG[2]}]
set_property PACKAGE_PIN V8 [get_ports {SEG[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SEG[3]}]
set_property PACKAGE_PIN U5 [get_ports {SEG[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SEG[4]}]
set_property PACKAGE_PIN V5 [get_ports {SEG[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SEG[5]}]
set_property PACKAGE_PIN U7 [get_ports {SEG[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {SEG[6]}]

set_property PACKAGE_PIN U2 [get_ports {AN[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {AN[0]}]
set_property PACKAGE_PIN U4 [get_ports {AN[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {AN[1]}]
set_property PACKAGE_PIN V4 [get_ports {AN[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {AN[2]}]
set_property PACKAGE_PIN W4 [get_ports {AN[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {AN[3]}]

## Buttons
# Center button - Cycle memory pairs
set_property PACKAGE_PIN U18 [get_ports BTN]						
	set_property IOSTANDARD LVCMOS33 [get_ports BTN]
# Right button - System Reset
set_property PACKAGE_PIN T17 [get_ports BTNRST]						
	set_property IOSTANDARD LVCMOS33 [get_ports BTNRST]