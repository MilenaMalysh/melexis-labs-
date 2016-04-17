`timescale 1ns / 1ps
module subtractor_4bits_tb;
parameter WIDTH = 4;
parameter DELAY = 10;
reg [WIDTH-1:0] in_a, in_b;
reg in_borrow;
wire [WIDTH-1:0] out_sub;
wire out_borrow;
integer i, j, error_counter;
subtractor_4bits #(.WIDTH(WIDTH)) add_inst(	.out_borrow(out_borrow),
						.in_borrow(in_borrow),
						.out_sub(out_sub),
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
			{in_borrow, in_a} = i;
			in_b = j;
			#DELAY;
			if ({out_borrow, out_sub}!= (in_a - in_b - in_borrow)) 
				begin
				error_counter = error_counter+1;
				$display("$time Desired value = %d, Real value = %d", in_a - in_b - in_borrow, {out_borrow, out_sub}); 
				end
 		end
	end
	$display("Amount of errors = %d", error_counter);
	$finish;
end



endmodule
