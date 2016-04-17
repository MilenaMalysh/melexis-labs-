`timescale 1ns / 1ps
module edge_detector_tb;
parameter period = 2;
reg clk, n_rst;
reg in;
wire out;
edge_detector edge_detector_inst(.clk(clk),
				 .n_rst(n_rst),
				 .in(in),
				 .out(out) 
				 );
initial begin
clk = 0;
forever #(period/2) clk = ~clk;
end
initial begin
n_rst = 0;
in = 0;
@(negedge clk) n_rst = 1;
@(negedge clk) in = 1;
repeat(2) @(negedge clk);
in = 0;
repeat(3) @(negedge clk);
in = 1;
repeat(2) @(negedge clk);
$finish;
end
endmodule
