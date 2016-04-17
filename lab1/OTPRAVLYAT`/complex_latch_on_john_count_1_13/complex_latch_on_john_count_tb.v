`timescale 1ns / 1ps
module complex_latch_on_john_count_tb;
parameter period = 2;
parameter length_latch  = 4;
reg clk, rst_n;
reg [length_latch-1:0] data_in;
wire [length_latch-1:0] data_out;
complex_latch_on_john_count #(.length_latch(length_latch)) reg_inst1(    .clk(clk), 
                                  					 .rst_n(rst_n), 
				 					 .data_in(data_in),
                                 					 .data_out(data_out));
initial begin
	clk = 0;
	forever #(period/2) clk = ~clk;
end
initial begin
	rst_n = 0;
	data_in = 4;
	@(negedge clk);
	rst_n = 1;
	repeat(2)@(negedge clk);
	data_in = 1;
	@(negedge clk);
	data_in = 9;
	@(negedge clk);
	data_in = 3;
	@(negedge clk);
	data_in = 13;
	repeat(2)@(negedge clk);
	data_in = 5;
	@(negedge clk);
	data_in = 2;

	@(posedge clk);
	$finish;  
end  
endmodule

