`timescale 1ns / 1ps
module shift_reg_paral_load_tb;
parameter period = 8;
parameter width = 16;
reg clk, rst_n, mode, direction;
//mode = 0, load
//mode = 1, shift
//direction = 0, left
//direction = 1, right
reg [width-1:0] data_in;  
wire[width-1:0] data_out1;

shift_reg_paral_load #(.width(width)) shift_reg_inst1(.clk(clk),
																		.rst_n(rst_n),
																		.mode(mode),
																		.direction(direction),
																		.data_in(data_in),
																		.data_out(data_out1)
																		);

initial
begin
	clk = 0;
	forever #(period/2) clk = ~clk;
end

initial
begin
	rst_n = 0;
	data_in = 0; 
	mode = 0;
	direction = 1;
	repeat(2) @ (negedge clk); 
	rst_n = 1;
	data_in =1;
	repeat(3) @ (negedge clk);
	mode = 1;
	repeat(3) @ (negedge clk);
	direction = 0;
	repeat(3) @ (negedge clk);
	data_in = 7;
	@ (negedge clk)
	mode = 0;
	repeat(6) @(negedge clk);
	$finish;  

end

endmodule






																		
