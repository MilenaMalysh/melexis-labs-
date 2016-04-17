list:
	@echo ""

vending_machine: target=vending_machine.v vending_machine_tb.v
vending_machine: entity=vending_machine_tb
vending_machine: sim

sim: elab $(target) $(entity)
	ncsim -message -gui worklib.verilog_snapshot:module

elab: compile $(target)
	ncelab -message -access w -neverwarn -snapshot verilog_snapshot worklib.$(entity):module

compile: libs
	ncvlog -message -work worklib -sv $(target)

libs: clean
	mkdir ./INCA_libs
	mkdir ./INCA_libs/worklib
clean:
	rm -rf core *.key *.log* *.out *.df *.dsn *.trn *.shm *.rpt .cov *.cmd* INCA_libs .simvision
.PHONY: libs clean
.IGNORE: libs
