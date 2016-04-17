`timescale 1ns / 1ps
module johnson_counter(clk, rst_n, out);
parameter length = 4;
input clk, rst_n;
output reg [length-1:0] out;
always @(posedge clk, negedge rst_n) begin
  if(!rst_n) begin
    out <= 0;  
  end else begin
    out <= {~out[0],out[length-1:1]};
  end
end
endmodule
