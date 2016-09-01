
module data_memory 
(
	data_in,
	addr_in,
	we, 
	clk,
	data_out
);

	input [31:0] data_in;
	input [31:0] addr_in;
	input we, clk;
	output [31:0] data_out;

	reg [8*2**16-1:0] ram;
	reg [31:0] addr_in_reg;

	always @ (posedge clk)
	begin
		// Write
		if (we)
			ram[8*addr_in+:32] <= data_in;
	end
	
	always @ (posedge clk)
	begin
		// Write
		addr_in_reg <= addr_in;
	end

	// Continuous assignment implies read returns NEW data.
	// This is the natural behavior of the TriMatrix memory
	// blocks in Single Port mode.  
	assign data_out = ram[8*addr_in_reg[15:0]+:32];

endmodule
