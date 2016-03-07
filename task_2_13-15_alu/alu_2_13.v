`timescale 1ns/1ps
module alu_2_13(control, in_data1, in_data2, out_data);
parameter WIDTH =4;
input [2:0] control;
input [WIDTH-1:0] in_data1, in_data2;
output [2*WIDTH-1:0] out_data;
wire [WIDTH-1:0] arr_res [4:0];
wire [2*WIDTH-1:0] mult_res;

adder_4bits #(.WIDTH(WIDTH)) adder(.out_c(),
					.in_c(0), 
					.out_sum(arr_res[0]), 
					.in_a(in_data1), 
					.in_b(in_data2));
											
subtractor_4bits #(.WIDTH(WIDTH)) subtractor(.out_borrow(),
						.in_borrow(0), 
						.out_sub(arr_res[1]), 
						.in_a(in_data1), 
						.in_b(in_data2));
											
multiplier_2_5 #(.WIDTH(WIDTH)) multiplier(.out_c(mult_res),
						.in_a(in_data1), 
						.in_b(in_data2));
														
nor_2_11 #(.WIDTH(WIDTH)) nor_ins (.out_data(arr_res[3]),
					.in_data1(in_data1), 
					.in_data2(in_data2));
														
nand_2_9 #(.WIDTH(WIDTH)) nand_ins (.out_data(arr_res[4]),
					.in_data1(in_data1), 
					.in_data2(in_data2));
											

multiplexor_2_7 #(.WIDTH(WIDTH)) mx_inst(.control(control),
						.in_data(arr_res), 
						.out_data(out_data));
assign arr_res[2] = mult_res[WIDTH:0];
assign out_data[WIDTH+:WIDTH] = (control==2)?mult_res[WIDTH+:WIDTH]:0; 


endmodule
