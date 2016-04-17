`timescale 1 ns / 1 ps
module latch_tb;
parameter width = 8;
parameter delay = 10;
reg we, rst_n;
reg [width-1:0] data_in;
wire [width-1:0] data_out;
integer i;
latch #(.width(width)) latch_inst1(     .we(we),
					.rst_n(rst_n),
					.data_in(data_in),
					.data_out(data_out)
					);
initial 
begin
	rst_n = 0;
	we = 0;
	data_in = 0;
	#delay rst_n = 1;
	for(i=0; i<2**width; i=i+1) 
	begin
		#delay;
		we = $random();
		data_in = i;
	end
	$finish;
end

endmodule
