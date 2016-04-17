`timescale 1ns / 1ps
module param_reg(clk, rst_n, data_in, data_out);
parameter width = 8;
input clk, rst_n;
input [width-1:0] data_in;
output reg [width-1:0] data_out;
	always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		data_out <= 0;
	end else begin
		data_out <= data_in;
	end
	end
endmodule

