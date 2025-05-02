# Clock: 100 MHz (W5)
set_property -dict { PACKAGE_PIN W5   IOSTANDARD LVCMOS33 } [get_ports { clk }];

# Reset: Center button (U18), active-high
set_property -dict { PACKAGE_PIN U18  IOSTANDARD LVCMOS33 } [get_ports { reset }];

# Target: 4-bit switches (W17, W16, W15, V15 for target[3..0])
set_property -dict { PACKAGE_PIN W17  IOSTANDARD LVCMOS33 } [get_ports { target[3] }];
set_property -dict { PACKAGE_PIN W16  IOSTANDARD LVCMOS33 } [get_ports { target[2] }];
set_property -dict { PACKAGE_PIN W15  IOSTANDARD LVCMOS33 } [get_ports { target[1] }];
set_property -dict { PACKAGE_PIN V15  IOSTANDARD LVCMOS33 } [get_ports { target[0] }];

# LED: LD0 (U16)
set_property -dict { PACKAGE_PIN U16  IOSTANDARD LVCMOS33 } [get_ports { led }];