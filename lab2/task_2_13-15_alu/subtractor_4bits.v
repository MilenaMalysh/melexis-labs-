`timescale 1ns / 1ps
module subtractor_4bits(out_borrow, in_borrow, out_sub, in_a, in_b);
parameter WIDTH = 4;
output out_borrow; 
output [WIDTH-1 : 0] out_sub;
input in_borrow; 
input [WIDTH-1 : 0] in_a, in_b;

wire [WIDTH-2 : 0] outs;
genvar i;


generate for (i = 0; i< WIDTH; i=i+1) 
	begin : SUBTRACTOR_4BITS
	if (i==0) 
		begin
      full_subtractor lower_bit( .out_borrow(outs[0]),
											.in_borrow(in_borrow),
											.out_sub(out_sub[0]),
											.in_a(in_a[0]),
											.in_b(in_b[0]));

		end 
	
	else if (i == WIDTH-1) 
		begin
      full_subtractor older_bit( .out_borrow(out_borrow),
											.in_borrow(outs[i-1]),
											.out_sub(out_sub[WIDTH-1]),
											.in_a(in_a[WIDTH-1]),
											.in_b(in_b[WIDTH-1]));
									
		end
	else  
		begin
      full_subtractor other_bits(.out_borrow(outs[i]),
											.in_borrow(outs[i-1]),
											.out_sub(out_sub[i]),
											.in_a(in_a[i]),
											.in_b(in_b[i]));
									
		end
	end
	endgenerate

endmodule 
