`timescale 1ns / 1ps
module multiplexor_2_7_tb;
parameter DELAY = 1;
reg [2:0] control;
reg [3:0] in_data [4:0];
wire [3:0] out_data;
integer i, error_counter;


multiplexor_2_7  mx_inst(.control(control),
			.in_data(in_data),
			.out_data(out_data));
initial 
begin
	for (i=0; i<5;i=i+1)
		in_data[i]=0;
	control = 0;
	error_counter = 0;
	for(i=0; i<5; i=i+1) 
	begin
		in_data[i] = 2**i;
		#DELAY;
		control = i;
		#DELAY;
		if (out_data!=in_data[control])
		begin
			error_counter = error_counter+1;
			$display($time, " Desired value = %d, Real value = %d", in_data[control], out_data);
		end 
	end
	$display("Amount of errors = %d", error_counter);
	$finish;
end


endmodule
