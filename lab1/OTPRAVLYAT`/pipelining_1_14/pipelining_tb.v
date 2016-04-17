`timescale 1ns / 1ps
module pipelining_tb;
parameter period = 2;
parameter width = 4;					
reg clk, rst_n;
reg [width-1:0] a, b, c;
wire [width-1:0] q, q_pipe;

without_pipelining #(.width(width)) pip_inst1(  .clk(clk), 
						.rst_n(rst_n), 
 						.a_in(a), 
						.b_in(b), 
						.c_in(c), 
						.q_out(q)
						);
with_pipelining #(.width(width)) pip_inst2(     .clk(clk), 
						.rst_n(rst_n), 
 						.a_in(a), 
						.b_in(b), 
						.c_in(c), 
						.q_pipe_out(q_pipe)
						);
initial begin
	clk = 0;
	forever #(period/2) clk = ~clk;
end
initial begin
	rst_n = 0;
	a = 0;
	b = 0;
	c = 0;
	@(negedge clk) rst_n = 1;
	repeat (14) 
	begin
		@(negedge clk);
		a = $random();
		b = $random();
		c = $random();
	end
	@(posedge clk);
	$finish;  
end
endmodule

