`timescale 1ns / 1ps
module complex_latch_on_john_count(clk, rst_n, data_in, data_out);
parameter length_latch = 4;
localparam length_count = 4;
input clk, rst_n;
input [length_latch-1:0] data_in;
output reg [length_latch-1:0] data_out;

reg [length_count-1:0] jcnt_out;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		jcnt_out <= 0;  
	end else begin
		jcnt_out <= {~jcnt_out[0],jcnt_out[length_count-1:1]};
	end
end

always @(rst_n, jcnt_out, data_in) begin
	if(!rst_n) begin
		data_out <= 0;   
	end else if(!jcnt_out[0]^jcnt_out[length_count-1]) begin
		data_out <= data_in;
	end
end

endmodule
