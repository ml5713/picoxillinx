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
ExecStep $xv_path/bin/xelab -wto 6ad63c80d201465087a74b59905df876 -m64 --debug typical --relax --mt 8 -L xil_defaultlib -L xpm -L fifo_generator_v13_1_1 -L gtwizard_ultrascale_v1_5_4 -L unisims_ver -L unimacro_ver -L secureip --snapshot Pico_Toplevel_behav xil_defaultlib.Pico_Toplevel xil_defaultlib.glbl -log elaborate.log
