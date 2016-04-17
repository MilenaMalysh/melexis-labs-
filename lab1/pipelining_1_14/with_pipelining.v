`timescale 1ns / 1ps
module with_pipelining(clk, rst_n, a_in, b_in, c_in, q_pipe_out);
parameter width = 4;
input clk, rst_n;
input [width-1:0] a_in, b_in, c_in;
reg [width-1:0] a_ff, b_ff, c_ff, ab_sum_ff, c_temp_ff;
output reg [width-1:0] q_pipe_out;
always @(posedge clk, negedge rst_n) begin
	if(!rst_n) begin
		a_ff <= 0; 
		b_ff <= 0; 
		c_ff <= 0; 
		ab_sum_ff <= 0;
		c_temp_ff <= 0;
		q_pipe_out <= 0;  
	end else begin
		a_ff <= a_in; 
		b_ff <= b_in; 
		c_ff <= c_in; 
		ab_sum_ff <= a_ff+b_ff;
		c_temp_ff <= c_ff;
		q_pipe_out <= ab_sum_ff ^ c_temp_ff;
	end
end
endmodule

