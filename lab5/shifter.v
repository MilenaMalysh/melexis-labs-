module shifter(shifted_out, shift_amount_in, b_in, shift_operation_in);

input [31:0] b_in;
input [4:0] shift_amount_in;
input [1:0] shift_operation_in;

output [31:0] shifted_out;

wire [62:0] extended_out;

wire [46:0] mx_out1;
wire [38:0] mx_out2;
wire [34:0] mx_out3;
wire [32:0] mx_out4;

genvar i;

extender extender(.extended_out(extended_out),
						.b_in(b_in), 
						.shift_operation_in(shift_operation_in));

assign mx_out1 = (shift_amount_in[4]^(~(shift_operation_in[1] | shift_operation_in[0])))? extended_out[46:0]: extended_out[62:16];
assign mx_out2 = (shift_amount_in[4]^(~(shift_operation_in[1] | shift_operation_in[0])))? mx_out1[38:0]: mx_out1[46:8];
assign mx_out3 = (shift_amount_in[4]^(~(shift_operation_in[1] | shift_operation_in[0])))? mx_out2[34:0]: mx_out2[38:4];
assign mx_out4 = (shift_amount_in[4]^(~(shift_operation_in[1] | shift_operation_in[0])))? mx_out3[32:0]: mx_out3[34:2];
assign shifted_out = (shift_amount_in[4]^(~(shift_operation_in[1] | shift_operation_in[0])))? mx_out4[31:0]: mx_out4[32:1];

endmodule




module extender(extended_out, b_in, shift_operation_in);

input [31:0] b_in;
input [1:0] shift_operation_in;

output reg [62:0] extended_out;

always @*
case(shift_operation_in)
			
	2'b00: extended_out = {b_in,{31{1'b0}}};//SLL
	2'b01: extended_out = {{31{1'b0}},b_in};//SRL
	2'b10: extended_out = {{31{b_in[31]}},b_in};//SRA
	2'b11: extended_out = {b_in[30:0],b_in};//ROR
				
endcase

endmodule