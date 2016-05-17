`timescale 1 ns / 1 ps
module latch(we, rst_n, data_in, data_out);
parameter width = 8;
input we, rst_n;
input [width-1:0] data_in;
output reg [width-1:0] data_out;
always @(we, rst_n, data_in) 
begin
	if(!rst_n) 
	begin
		data_out <= 0;
	end 
	else 
	if(we) 
	begin
		data_out <= data_in;
	end
end

endmodule

