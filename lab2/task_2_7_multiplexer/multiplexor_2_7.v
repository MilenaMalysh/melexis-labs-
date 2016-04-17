`timescale 1ns/1ps
module multiplexor_2_7(control, in_data, out_data);
parameter WIDTH =4;
input [2:0] control;
input [3:0] in_data [4:0];
output [3:0] out_data;
wire [3:0] lev1_mx1, lev1_mx2, lev2_mx1;

param_mx_1b #(.WIDTH(WIDTH)) mx1_1(.out_data(lev1_mx1), 
											.in_data1(in_data[0]),
											.in_data2(in_data[1]),
											.ctrl(control[0]));

param_mx_1b #(.WIDTH(WIDTH)) mx1_2(.out_data(lev1_mx2), 
											.in_data1(in_data[2]),
											.in_data2(in_data[3]),
											.ctrl(control[0]));
											
param_mx_1b #(.WIDTH(WIDTH)) mx2_1(.out_data(lev2_mx1), 
											.in_data1(lev1_mx1),
											.in_data2(lev1_mx2),
											.ctrl(control[1]));
											
param_mx_1b #(.WIDTH(WIDTH)) mx3_1(.out_data(out_data), 
											.in_data1(lev2_mx1),
											.in_data2(in_data[4]),
											.ctrl(control[2]));
endmodule


module param_mx_1b(out_data, in_data1, in_data2, ctrl);
parameter WIDTH = 4;
input [(WIDTH-1):0] in_data1, in_data2;
input ctrl;
output [(WIDTH-1):0] out_data;
wire n_ctrl;
wire [(WIDTH-1):0] and_1, and_2;

not not_ctrl(n_ctrl, ctrl);

andv #(.WIDTH(WIDTH)) and1(.and_out(and_1), 
				.and_in(in_data1), 
				.ctrl(n_ctrl)
				);

andv #(.WIDTH(WIDTH)) and2(.and_out(and_2), 
				.and_in(in_data2), 
				.ctrl(ctrl)
				);
									
									
orv #(.WIDTH(WIDTH)) mx (.or_out(out_data),
				.or_in1(and_1),
				.or_in2(and_2)
				);

																

									
									
endmodule

module andv(and_out, and_in, ctrl);
parameter WIDTH = 4;
input [3:0] and_in;
input ctrl;
output [3:0] and_out;
genvar i;
generate
for (i=0; i<WIDTH; i=i+1)
	begin: each_bit
		and a_o(and_out[i], and_in[i], ctrl);
	end
endgenerate

endmodule

module orv(or_out, or_in1, or_in2);
parameter WIDTH = 4;
input [WIDTH-1:0] or_in1, or_in2;
output [WIDTH-1:0] or_out;
genvar i;
generate
for (i=0; i<4; i=i+1)
	begin: each_bit
		or or_o(or_out[i], or_in1[i], or_in2[i]);
	end
endgenerate

endmodule

