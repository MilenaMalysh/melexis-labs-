`timescale 1ns / 1ps
module multiplier_2_5(out_c, in_a, in_b);
parameter WIDTH = 4;
output [2*WIDTH-1 : 0] out_c;
input [WIDTH-1 : 0] in_a, in_b;

genvar i, j;


generate 
	for (i = 0; i< WIDTH; i=i+1) 
		begin : MULTIPLIERS
		wire [WIDTH-1:0] mult_vectors;
		wire [WIDTH-1:0] part_sum;
		wire [WIDTH-1:0] outs;
		for (j = 0; j< WIDTH; j=j+1)
			begin : MULT_PART
				and (mult_vectors[j],in_b[i],in_a[j]);
			end


		if (i==0) 
			begin
				assign part_sum = MULTIPLIERS[0].mult_vectors;
				assign out_c[0] = MULTIPLIERS[0].mult_vectors[0];
				assign outs[WIDTH-1] = 0;
			end


		else for (j = 0; j<WIDTH; j=j+1)
			begin: SUM_PART

				if (j==0) 
						full_adder add(		.out_c(MULTIPLIERS[i].outs[0]),
									.in_c(0),
									.out_sum(out_c[i]),
									.in_a(MULTIPLIERS[i].mult_vectors[j]),
									.in_b(MULTIPLIERS[i-1].part_sum[j+1]));
				else if (j==WIDTH-1)
						full_adder add(  	.out_c(MULTIPLIERS[i].outs[j]),
									.in_c(MULTIPLIERS[i].outs[j-1]),
									.out_sum(MULTIPLIERS[i].part_sum[j]),
									.in_a(MULTIPLIERS[i].mult_vectors[j]),
									.in_b(MULTIPLIERS[i-1].outs[WIDTH-1]));

				else
						full_adder add(  	.out_c(MULTIPLIERS[i].outs[j]),
									.in_c(MULTIPLIERS[i].outs[j-1]),
									.out_sum(MULTIPLIERS[i].part_sum[j]),
									.in_a(MULTIPLIERS[i].mult_vectors[j]),
									.in_b(MULTIPLIERS[i-1].part_sum[j+1]));
			end
		

	end
	
endgenerate

assign out_c[WIDTH+: (WIDTH-1)] = MULTIPLIERS[WIDTH-1].part_sum[1+:(WIDTH-1)];
assign out_c[2*WIDTH-1] = MULTIPLIERS[WIDTH-1].outs[WIDTH-1];
		
		
endmodule

