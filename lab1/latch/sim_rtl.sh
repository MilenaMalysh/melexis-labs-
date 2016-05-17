./cleanup.sh

mkdir ./INCA_libs
mkdir ./INCA_libs/worklib

ncvlog -message -work worklib latch.v latch_tb.v 

ncelab -message -neverwarn -snapshot verilog_snapshot worklib.latch_tb:module

ncsim -gui -message worklib.verilog_snapshot:module
