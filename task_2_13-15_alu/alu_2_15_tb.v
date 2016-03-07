`timescale 1ns / 1ps
module nor_2_11_tb;
parameter DELAY = 1;
parameter WIDTH = 4;
reg [2:0] control;
reg [WIDTH-1:0] in_data1, in_data2;
wire [2*WIDTH-1:0] out_data1, out_data2;
integer i, j, error_counter;

alu_2_13 #(.WIDTH(WIDTH)) alu_inst(
				.control(control),
				.in_data1(in_data1),
				.in_data2(in_data2), 
				.out_data(out_data1));


alu_2_14 #(.WIDTH(WIDTH)) alu_inst(
				.control(control),
				.in_data1(in_data1),
				.in_data2(in_data2), 
				.out_data(out_data2));

initial 
begin
error_counter = 0;
	for (i=0; i<WIDTH;i=i+1)
		begin 
			in_data1=i;
			for(j=0; j<WIDTH; j=j+1) 
			begin
				in_data2 = j;
				#DELAY;
				for(c=0; c<5; c=c+1) 
					begin
						control = c;
						#DELAY;
						if (out_data1!=out_data2)
						begin
							error_counter = error_counter+1;
							$display($time, " Desired value = %d, Real value = %d", ~(in_data1|in_data2), out_data);
						end 
					end
			end
		end
	$display("Amount of errors = %d", error_counter);
	$finish;
end


endmodule
