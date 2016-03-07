`timescale 1ns/1ps
module nor_2_11(out_data, in_data1, in_data2);
parameter WIDTH = 4;
input [WIDTH-1:0] in_data1, in_data2;
output [WIDTH-1:0] out_data;
genvar i;
generate
for (i=0; i<WIDTH; i=i+1)
	begin: each_bit
		wire or_out;
		or or_o(or_out, in_data1[i], in_data2[i]);
		not(out_data[i], or_out);
	end
endgenerate

endmodule

