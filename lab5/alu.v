module alu(a_in, b_in, type_of_operation_in, shift_operation_in, arithmetic_operation_in, logical_operation_in, alu_result_out, zero_out);

input [31:0] a_in, b_in;
input [1:0] type_of_operation_in, shift_operation_in, logical_operation_in;
input arithmetic_operation_in;


output reg [31:0]alu_result_out;
output zero_out;

wire [31:0] shifted_out, arith_out, logical_out;
wire [4:0] shift_amount_in;
wire overflow;


shifter shifter(.shifted_out(shifted_out),
					.shift_amount_in(shift_amount_in), 
					.b_in(b_in), 
					.shift_operation_in(shift_operation_in));
					
adder adder(   .c_out(overflow),
					.data_out(arith_out),
					.a_in(a_in),
					.b_in(b_in^{32{arithmetic_operation_in}}), 
					.c_in(arithmetic_operation_in),
					);

always@ *

begin

case(type_of_operation_in)

2'b00: alu_result_out = shifted_out;
2'b01: alu_result_out = overflow^arith_out[31];
2'b10: alu_result_out = arith_out;
2'b11: begin
			case(logical_operation_in)
			
				2'b00: alu_result_out = a_in & b_in;
				2'b01: alu_result_out = a_in | b_in;
				2'b10: alu_result_out = ~(a_in | b_in);
				2'b11: alu_result_out = a_in ^ b_in;
				
			endcase

			//alu_result_out = logical_out;

		 end

endcase

end

endmodule