`timescale 1ns / 1ps
module param_reg_tb;
parameter period = 4;
parameter width = 4;
reg clk, rst_n;
reg [width-1:0] data_in;
wire [width-1:0] data_out;
integer i;
param_reg #(.width(width)) reg_inst1(   .clk(clk),
					.rst_n(rst_n),
					.data_in(data_in),
					.data_out(data_out)
					);
initial begin
	clk = 0;
	forever #(period/2) clk = ~clk;
end

initial begin
	rst_n = 0;
	data_in = 0;
	@(negedge clk) rst_n = 1;

	for (i=0; i<2**width; i=i+1) begin
		@(negedge clk) data_in = i;
	end
	@(negedge clk);
	$finish;
end

endmodule
