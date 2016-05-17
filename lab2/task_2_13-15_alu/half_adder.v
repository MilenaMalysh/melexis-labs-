`timescale 1ns / 1ps
module half_adder (out_sum, out_c, in_a, in_b);
input in_a, in_b;
output out_c, out_sum;
xor (out_sum, in_a, in_b);
and (out_c, in_a, in_b);
endmodule
