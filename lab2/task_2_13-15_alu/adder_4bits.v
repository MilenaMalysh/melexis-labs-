`timescale 1ns / 1ps
module adder_4bits(out_c, in_c, out_sum, in_a, in_b);
parameter WIDTH = 4;

output out_c; 
output [WIDTH-1 : 0] out_sum;
input in_c; 
input [WIDTH-1 : 0] in_a, in_b;

wire [WIDTH-2 : 0] outs;
genvar i;



generate for (i = 0; i< WIDTH; i=i+1) 
	begin : ADDER_4BITS
	if (i==0) 
		begin
      full_adder lower_bit(.out_c(outs[0]),
									.in_c(in_c),
									.out_sum(out_sum[0]),
									.in_a(in_a[0]),
									.in_b(in_b[0]));

		end 
	
	else if (i == WIDTH-1) 
		begin
      full_adder older_bit(.out_c(out_c),
									.in_c(outs[i-1]),
									.out_sum(out_sum[WIDTH-1]),
									.in_a(in_a[WIDTH-1]),
									.in_b(in_b[WIDTH-1]));
									
		end
	else  
		begin
      full_adder other_bits(.out_c(outs[i]),
									.in_c(outs[i-1]),
									.out_sum(out_sum[i]),
									.in_a(in_a[i]),
									.in_b(in_b[i]));
									
		end
	end
	endgenerate

endmodule 
