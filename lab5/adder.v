module adder(c_out, c_in, data_out, a_in, b_in);
output c_out; 
output [31 : 0] data_out;
input c_in; 
input [31 : 0] a_in, b_in;

wire [30 : 0] outs;
genvar i;

generate for (i = 0; i< 32; i=i+1) 
	begin : ADDER
	if (i==0) 
		begin
      full_adder lower_bit(.out_c(outs[0]),
									.in_c(c_in),
									.out_sum(data_out[0]),
									.in_a(a_in[0]),
									.in_b(b_in[0]));

		end 
	
	else if (i == 31) 
		begin
      full_adder older_bit(.out_c(c_out),
									.in_c(outs[i-1]),
									.out_sum(data_out[31]),
									.in_a(a_in[31]),
									.in_b(b_in[31]));
									
		end
	else  
		begin
      full_adder other_bits(.out_c(outs[i]),
									.in_c(outs[i-1]),
									.out_sum(data_out[i]),
									.in_a(a_in[i]),
									.in_b(b_in[i]));
									
		end
	end
	endgenerate

endmodule 

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

module half_adder (out_sum, out_c, in_a, in_b);
input in_a, in_b;
output out_c, out_sum;
xor (out_sum, in_a, in_b);
and (out_c, in_a, in_b);
endmodule

