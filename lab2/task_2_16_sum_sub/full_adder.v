`timescale 1ns / 1ps
module full_adder(out_c, in_c, out_sum, in_a, in_b);
output out_c, out_sum;
input in_c, in_a, in_b;
wire sum, c_out1, c_out2;

	half_adder l1(.out_c(c_out1),
					  .out_sum(sum),
					  .in_a(in_a),
					  .in_b(in_b)
					  );
					  
	half_adder l2(.out_c(c_out2),
					  .out_sum(out_sum),
					  .in_a(sum),
					  .in_b(in_c)
					  );

	or l3 (out_c, c_out1, c_out2);

endmodule
