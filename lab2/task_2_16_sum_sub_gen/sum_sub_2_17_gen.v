`timescale 1ns / 1ps
module sum_sub_2_16(out_bit, in_bit, out_data, in_a, in_b);
parameter WIDTH = 4;
parameter mode = 1;
output out_bit; 
output [WIDTH-1 : 0] out_data;
input in_bit; 
input [WIDTH-1 : 0] in_a, in_b;

wire [WIDTH-2 : 0] outs;
generate
if (mode)
adder_4bits #(.WIDTH(WIDTH)) adder(.out_c(out_bit),
					.in_c(in_bit), 
					.out_sum(out_data), 
					.in_a(in_a), 
					.in_b(in_b));
											

else
subtractor_4bits #(.WIDTH(WIDTH)) subtractor(.out_borrow(out_bit),
						.in_borrow(in_bit), 
						.out_sub(out_data), 
						.in_a(in_a), 
						.in_b(in_b));

endgenerate

endmodule 
