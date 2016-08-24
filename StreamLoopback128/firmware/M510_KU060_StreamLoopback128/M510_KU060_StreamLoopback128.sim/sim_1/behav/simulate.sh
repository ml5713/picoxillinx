#!/bin/bash -f
xv_path="/opt/Xilinx/Vivado/2016.2"
ExecStep()
{
"$@"
RETVAL=$?
if [ $RETVAL -ne 0 ]
then
exit $RETVAL
fi
}
ExecStep $xv_path/bin/xsim Pico_Toplevel_behav -key {Behavioral:sim_1:Functional:Pico_Toplevel} -tclbatch Pico_Toplevel.tcl -log simulate.log
