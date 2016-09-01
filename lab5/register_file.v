module register_file (
	clk, 
	ra_in, 
	rb_in, 
	rw_in, 
	write_en_in, 
	bus_w_in, 
	bus_a_out, 
	bus_b_out
	);
	
	
input clk, write_en_in;
input [4:0] ra_in, rb_in, rw_in;
input [31:0] bus_w_in;
output reg [31:0] bus_a_out, bus_b_out;

reg [31:0] reg_file [31:0];


always @ (*)//reading
begin
	bus_a_out = (ra_in) ? reg_file[ra_in] : 0;
	bus_b_out = (rb_in) ? reg_file[rb_in] : 0;
end

always @ (posedge clk)//writing
begin
	if (write_en_in)
			reg_file[rw_in] <= bus_w_in;	
end

endmodule