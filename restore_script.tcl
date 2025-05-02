# This tcl script could, in principle restore the project.
create_project pid_controller ./vivado_project -part xc7a35tcpg236-1
set_property source_mgmt_mode All [current_project]
add_files -norecurse ./src/pid_top.vhd
add_files -norecurse ./src/error_calc.vhd
add_files -norecurse ./src/pid_pterm.vhd
add_files -norecurse ./src/plant2.vhd
add_files -norecurse ./src/pid_top_tb.vhd
add_files -fileset constrs_1 -norecurse ./constrs/basys3_constraints.xdc
set_property top pid_top [current_fileset]
set_property top pid_top_tb [get_filesets sim_1]
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1
