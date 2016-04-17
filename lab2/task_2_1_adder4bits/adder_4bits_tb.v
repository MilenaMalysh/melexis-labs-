`timescale 1ns / 1ps
module adder_4bits_tb;
parameter WIDTH = 4;
parameter DELAY = 1;
reg [WIDTH-1:0] in_a, in_b;
reg in_c;
wire [WIDTH-1:0] out_sum;
wire out_c;
integer i, j, error_counter;
adder_4bits #(.WIDTH(WIDTH)) add_inst(  .out_c(out_c),
					.in_c(in_c),
					.out_sum(out_sum),
					.in_a(in_a),
					.in_b(in_b));
initial 
begin
	in_a = 0;
	in_b = 0;
	error_counter = 0;
	for(i=0; i<(2**(WIDTH+1)); i=i+1) 
	begin
		for(j=0; j<(2**(WIDTH)); j=j+1) 
		begin
			{in_c, in_a} = i;
			in_b = j;
			#0
			if ({out_c, out_sum}!= (in_a + in_b + in_c)) 
				begin
				error_counter = error_counter+1;
				$display($time, " Desired value = %d, Real value = %d", in_a + in_b + in_c, {out_c, out_sum}); 
				end
 		end
	end
	$display("Amount of errors = %d", error_counter);
	$finish;
end


endmodule
