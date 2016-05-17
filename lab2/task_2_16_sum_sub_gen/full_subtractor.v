`timescale 1ns / 1ps
module full_subtractor(out_borrow, in_borrow, out_sub, in_a, in_b);
output out_borrow, out_sub;
input in_borrow, in_a, in_b;
wire sub, c_out1, c_out2;

	half_subtractor l1(.out_borrow(borrow_out1),
					  .out_sub(sub),
					  .in_a(in_a),
					  .in_b(in_b)
					  );
					  
	half_subtractor l2(.out_borrow(borrow_out2),
					  .out_sub(out_sub),
					  .in_a(sub),
					  .in_b(in_borrow)
					  );

	or l3 (out_borrow, borrow_out1, borrow_out2);

endmodule
