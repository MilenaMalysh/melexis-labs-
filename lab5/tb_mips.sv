`timescale 1ns / 1ps
module tb_mips;
localparam FILE_FOR_VERIFICATION_QUANTITY = 3;
localparam string FILE_FOR_VERIF [0: FILE_FOR_VERIFICATION_QUANTITY - 1]   = '{"test_000.dat", "test_001.dat", "test_003.dat"};		
parameter string PATH = "tb_sources/";	
parameter reg [31:0] memory_address [0: FILE_FOR_VERIFICATION_QUANTITY - 1] = '{4, 4 ,4};	
parameter reg [31:0] result [0: FILE_FOR_VERIFICATION_QUANTITY - 1] = '{21, 7, 8'h8f0ff00b};

parameter CLK_PERIOD = 10;												
reg clk, n_rst;

integer i;  //increment

mips mips_instance(
						.clk(clk), 
						.n_rst(n_rst));

initial begin
	clk = 0;
	forever #(CLK_PERIOD/2) clk = ~clk;
end

initial begin
	for (i = 0; i < FILE_FOR_VERIFICATION_QUANTITY; i = i + 1) begin
		initial_task(i);
		check_result(i);
	end
	$finish();
end

task initial_task;
input integer test_index;
	begin
	n_rst = 0;
	@(negedge clk)
	$readmemb({PATH, FILE_FOR_VERIF[test_index]}, mips_instance.instr_inst.rom);
	@(negedge clk)
	n_rst = 1;
	end
endtask

task check_result;
input integer test_index;
//reg [2**16-1:0] addr; //expected address
//reg [31:0] res; //expected result
integer addr; //expected address
integer res; //expected result
begin

	addr = memory_address[test_index];
	res = result[test_index];

	repeat(100) @(negedge clk);
	if (mips_instance.data_mem.ram[addr * 8+:32] !== res)
		$display("!!!!TEST %d FAILED!!!!!. Expected result = %h, actual result = %h",test_index, result[test_index], (mips_instance.data_mem.ram[((memory_address[test_index]) * 8)+:31]));
	else $display("!!!!TEST %d SUCCEEDED!!!!!", test_index);
end
endtask
endmodule