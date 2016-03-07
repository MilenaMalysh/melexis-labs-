`timescale 1ns / 1ps
module nor_2_11_tb;
parameter DELAY = 1;
parameter WIDTH = 4;
reg [WIDTH-1:0] in_data1, in_data2;
wire [WIDTH-1:0] out_data;
integer i, j, error_counter;

nor_2_11 #(.WIDTH(WIDTH)) nor_inst(
				.out_data(out_data),
		    		.in_data1(in_data1), 
		   		 .in_data2(in_data2));

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
				if (out_data!=~(in_data1|in_data2))
				begin
					error_counter = error_counter+1;
					$display($time, " Desired value = %d, Real value = %d", ~(in_data1|in_data2), out_data);
				end 
			end
		end
	$display("Amount of errors = %d", error_counter);
	$finish;
end


endmodule
