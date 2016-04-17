`timescale 1ns / 1ps
module edge_detector_prot_metas(clk, n_rst, in, out);
input clk, n_rst, in;
output out;
reg reg1, reg2, reg3;
	always @(posedge clk, negedge n_rst) begin
		if (!n_rst) begin
			reg1 <= 1'b0;
			reg2 <= 1'b0;
			reg3 <= 1'b0;
		end 
		else 
		begin
			reg1 <= in;
			reg2 <= reg1;
			reg3 <= reg2;
		end
	end

assign out = reg2 & ~reg3;

endmodule
