# create system pico bus clock
create_generated_clock -name sys_picoclk -source [get_pins {PicoFramework|app|FrameworkPicoBus|s2pb|clk_gen|clk_reg|clk}] -divide_by 62 [get_pins {PicoFramework|app|FrameworkPicoBus|s2pb|clk_gen|clk_reg|q}]
set_clock_groups -asynchronous -group [get_clocks sys_picoclk]

# if there is user pico bus, create the clock
set usr_picoclk_pin [get_pins -nowarn {UserWrapper|UserModule_s2pb|s2pb|clk_gen|clk_reg|q}]
if {[get_collection_size $usr_picoclk_pin] > 0} {
    create_generated_clock -name usr_picoclk -source [get_pins {UserWrapper|UserModule_s2pb|s2pb|clk_gen|clk_reg|clk}] -divide_by 62 $usr_picoclk_pin
    set_clock_groups -asynchronous -group [get_clocks usr_picoclk]
}

# make user clock asynchronous to sys_clk to avoid timing error
set userclk [get_clocks *stratixv_hssi_gen3_pcie_hip|coreclkout]
set_clock_groups -asynchronous -group $userclk -group {sys_clk_p}
set ddr3_clocks [get_clocks -nowarn mem_if|*]
if {[get_collection_size $ddr3_clocks] > 0} {
    # make ddr3_clocks asynchronous to the user clock
    set_clock_groups -asynchronous -group $userclk -group $ddr3_clocks
}

