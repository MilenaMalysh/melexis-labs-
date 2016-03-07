`timescale 1ns/1ps
module nand_2_9(out_data, in_data1, in_data2);
parameter WIDTH = 4;
input [WIDTH-1:0] in_data1, in_data2;
output [WIDTH-1:0] out_data;
genvar i;
generate
for (i=0; i<WIDTH; i=i+1)
	begin: each_bit
		wire and_out;
		and a_o(and_out, in_data1[i], in_data2[i]);
		not(out_data[i], and_out);
	end
endgenerate

endmodule

