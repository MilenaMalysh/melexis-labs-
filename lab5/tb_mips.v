`timescale 1ns / 1ps
module tb_mips;
parameter CLK_PERIOD = 10;
reg clk, n_rst;
mips mips_instance(
						.clk(clk), 
						.n_rst(n_rst));

initial begin
	clk = 0;
	forever #(CLK_PERIOD/2) clk = ~clk;
end

initial begin
	$readmemb("tb_sources/test_000.dat", mips_instance.instr_inst.rom);
	n_rst = 0;
	@(negedge clk)	n_rst = 1;
	repeat(100) @(negedge clk);
	if (mips_instance.data_mem.ram[7*8:4*8]!==21)
		$display("!!!!TEST FAILED!!!!!. Expected result = 0x15, actual result = %h", mips_instance.data_mem.ram[7*8:4*8]);
	else $display("!!!!TEST SUCCEED!!!!!");

	$finish();
end



endmodule