`timescale 1ns / 1ps
module shift_reg_paral_load(clk, rst_n, mode, direction, data_in, data_out);
parameter width = 8;
input clk, rst_n, mode, direction;
//mode = 0, load
//mode = 1, shift
//direction = 0, left
//direction = 1, right
input [width-1:0] data_in;  
output reg [width-1:0] data_out;

always @(posedge clk, negedge rst_n) begin
	if(!rst_n) 
	begin
		data_out <= 0;  
	end 
	else 
	begin
		if (!mode) 
		begin
				data_out <= data_in;
		end
		else
		begin
			if (direction) data_out <= data_out<<1;
			else data_out <= data_out>>1;
		end
	end
end

endmodule
