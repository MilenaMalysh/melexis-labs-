`timescale 1ns / 1ps
module traffic_light_tb;
parameter period = 4;
reg clk, rst_n;
wire o_red, o_yellow1, o_yellow2, o_green;
traffic_light traffic_light_inst1(.clk(clk),
				.reset(rst_n),
				.o_red(o_red),
				.o_yellow1(o_yellow1),
				.o_yellow2(o_yellow2),
				.o_green (o_green)
			     );


initial begin
	clk = 0;
	forever #(period/2) clk = ~clk;
end



initial begin
	rst_n = 0;
	@(negedge clk) rst_n = 1;
	repeat (100) @(negedge clk);
	$finish;
end

endmodule
