`timescale 1ns / 1ps
module alu(
	a_in,
	b_in,
	signed_operation_in,
	type_of_operation_in,
	shift_operation_in,
	arithmetic_operation_in,
	logical_operation_in,
	alu_result_out, 
	zero_out,
	overflow_out);

//type_of_operation_in
parameter SHIFT = 2'b00;
parameter SLT = 2'b01;
parameter ARITH = 2'b10;
parameter LOGIC = 2'b11;

//shift_operation_in constants
parameter SLL = 2'b00;
parameter SRL = 2'b01;
parameter SRA = 2'b10;
parameter ROR = 2'b11;

//logic_operation_in constants
parameter AND = 2'b00;
parameter OR = 2'b01;
parameter XOR = 2'b10;
parameter NOR = 2'b11;

input [31:0] a_in, b_in;
reg [31:0] b_for_operation;
input [1:0] type_of_operation_in, shift_operation_in, logical_operation_in;
input arithmetic_operation_in, signed_operation_in;
wire substract;
assign substract = arithmetic_operation_in|type_of_operation_in[0];

output reg [31:0]alu_result_out;
output zero_out, overflow_out;
reg [31:0] logical_out, arith_out;
wire [31:0] shifted_out; 
reg signed [33:0] arith_out_ext, a_ext, b_ext; // for overflow detection
wire [4:0] shift_amount_in;
assign shift_amount_in = a_in[4:0];

reg overflow;
assign zero_out = alu_result_out?0:1;
assign overflow_out = overflow;

shifter shifter(.shifted_out(shifted_out),
					.shift_amount_in(shift_amount_in), 
					.b_in(b_in), 
					.shift_operation_in(shift_operation_in));
					
always @(*) begin
	case(type_of_operation_in)
		SHIFT	: alu_result_out = shifted_out;
		SLT	: alu_result_out = arith_out_ext[33];
		ARITH	: alu_result_out = arith_out;
		LOGIC	: alu_result_out = logical_out;
	endcase
end

always @ (*) begin
  a_ext = {{2{signed_operation_in & a_in[31]}}, a_in}; // a extension 
  b_for_operation = (substract)?(~b_in):b_in;
  //b_ext = {{2{signed_operation_in & b_for_operation[31]}}, b_for_operation}; // b extension
  b_ext = {{2{ b_for_operation[31]}}, b_for_operation}; // b extension
  arith_out_ext = b_ext + a_ext + substract;
  arith_out = arith_out_ext[31:0];
  overflow = signed_operation_in&(arith_out_ext[32]^arith_out_ext[31]);
end

always @(logical_operation_in or a_in or b_in) begin
	case(logical_operation_in)
				AND: logical_out = a_in & b_in;
				OR	: logical_out = a_in | b_in;
				NOR: logical_out = ~(a_in | b_in);
				XOR: logical_out = a_in ^ b_in;
	endcase
end

endmodule