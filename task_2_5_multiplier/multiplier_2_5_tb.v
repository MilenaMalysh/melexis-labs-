`timescale 1ns / 1ps
module multiplier_2_5_tb;
parameter WIDTH = 4;
parameter DELAY = 1;
reg [WIDTH-1:0] in_a, in_b;
wire [2*WIDTH-1:0] out_c;
integer i, j, error_counter;
multiplier_2_5 #(.WIDTH(WIDTH)) add_inst(.out_c(out_c),
					 .in_a(in_a),
					 .in_b(in_b));
initial 
begin
	in_a = 0;
	in_b = 0;
	error_counter = 0;
	for(i=0; i<(2**(WIDTH)); i=i+1) 
	begin
		for(j=0; j<(2**(WIDTH)); j=j+1) 
		begin
			in_a = i;
			in_b = j;
			#DELAY
			if (out_c!= in_a * in_b) 
				begin
				error_counter = error_counter+1;
				$display($time, " Desired value = %d, Real value = %d", in_a * in_b, out_c); 
				end
 		end
	end
	$display("Amount of errors = %d", error_counter);
	$finish;
end


endmodule
