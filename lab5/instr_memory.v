module instr_memory(// instruction_memory
	addr_in, 
	instr_out
	);
input [31:0] addr_in;
output reg [31:0] instr_out;

	//reg [8*2**16-1:0] rom;
	reg [31:0] rom [2**14-1:0];

	always @ (*)
	begin
		//instr_out = rom [8*addr_in[15:0]+:32]; // reading
		instr_out = rom [addr_in[15:2]]; // reading
	end
	
	initial $readmemb("tb_sources/test_000.dat", rom);
endmodule

