create_generated_clock -name sys_picoclk -divide_by 60 -source [get_pins PicoFramework/app/FrameworkPicoBus/s2pb/clk_gen/clk_reg_reg/C] [get_pins PicoFramework/app/FrameworkPicoBus/s2pb/clk_gen/inst/O]
set_clock_groups -async -group [get_clocks sys_picoclk]
if {[llength [get_pins -quiet UserWrapper/UserModule_s2pb/s2pb/clk_gen/clk_reg_reg/C]]>0} {
    create_generated_clock -name usr_picoclk -divide_by 60 -source [get_pins UserWrapper/UserModule_s2pb/s2pb/clk_gen/clk_reg_reg/C] [get_pins UserWrapper/UserModule_s2pb/s2pb/clk_gen/inst/O]
    set_clock_groups -async -group [get_clocks usr_picoclk]
}

