`timescale 1ns / 1ps
module johnson_counter_tb;
parameter period = 2;
parameter length  = 4;
reg clk, rst_n;
wire [length-1:0] out;
johnson_counter #(.length(length)) reg_inst1(   .clk(clk), 
                                           	.rst_n(rst_n), 
                                           	.out(out) );
initial begin
	clk = 0;
	forever #(period/2) clk = ~clk;
end
initial begin
	rst_n = 0;
	repeat(2) @(negedge clk);
	rst_n = 1;
	repeat(13) @(posedge clk);
	$finish;  
end  
endmodule

