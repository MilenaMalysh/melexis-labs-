`timescale 1ns / 1ps
module half_subtractor (out_sub, out_borrow, in_a, in_b);
input in_a, in_b;
output out_borrow, out_sub;
xor (out_sub, in_a, in_b);
not(n_in_a, in_a);
and (out_borrow, n_in_a, in_b);
endmodule
