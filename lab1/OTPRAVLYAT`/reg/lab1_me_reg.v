`timescale 1ns / 1ps
module lab1_me_reg(clk, rst_n, data_in, data_out, we_n);
input clk, rst_n;
input [7:0] data_in;
input we_n;
output reg [7:0] data_out;
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		data_out <= 0;
	end else begin
		if (!we_n)data_out <= data_in;
	end
end

endmodule

