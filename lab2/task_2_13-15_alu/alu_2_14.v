`timescale 1ns/1ps
module alu_2_14(control, in_data1, in_data2, out_data);
parameter WIDTH =4;
input [2:0] control;
input [WIDTH-1:0] in_data1, in_data2;
output reg [2*WIDTH-1:0] out_data;
wire [2*WIDTH-1:0] arr_res [4:0];

always @* begin
	case (control) //synopsis full_case parallel_case
		0: out_data = { {WIDTH{1'b0}}, in_data1+in_data2};
		1: out_data = { {WIDTH{1'b0}}, in_data1-in_data2};
		2: out_data = in_data1*in_data2;
		3: out_data = { {WIDTH{1'b0}},~(in_data1|in_data2)};
		4: out_data = { {WIDTH{1'b0}},~(in_data1&in_data2)};
	endcase
end
endmodule
