`timescale 1ns / 1ps
module unsigned_comparator_tb;
parameter width = 4;
parameter delay = 10;


reg signed [width-1:0] a, b;
reg sign;

wire equal, greater, lower;
integer i, j;
unsigned_comparator #(.width(width)) cmp_inst1( .a(a),
						.b(b),
						.equal(equal),
						.greater(greater),
						.lower(lower)
						);
initial 
begin

	sign = 0;

	a = 0;
	b = 0;
	for(i=0; i<2**width; i=i+1) 
	begin
		for(j=0; j<2**width; j=j+1) 
		begin
			#delay;
			

			sign = $random;
			if (sign) begin a = i; end
			else begin a = -i; end
			sign = $random;
			if (sign) begin b = j; end
			else begin b = -j; end

			//a = i;
			//b = j;
		end
	end
	$finish;
end

endmodule
