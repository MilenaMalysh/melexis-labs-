`timescale 1ns / 1ps
module mips(
	clk, 
	n_rst
	);

input clk, n_rst;

//instruction memory, current instruction and it's sections
wire [31:0] instruction;
wire [6:0] special;
wire [4:0] rs, rt, rd, sa;
wire [5:0] func;
wire rotr_srl_switch;
wire [5:0] shift_amount;
wire [15:0] immediate;
	assign special = instruction[31:26];
	assign rs = instruction[25:21];
	assign rt = instruction [20:16];
	//for R type
	assign rd = instruction[15:11];
	assign sa = instruction[10:6];
	assign func = instruction[5:0];
	assign rotr_srl_switch = func[3]?sa[0]:rs[0];
	//for immediate type
	assign immediate = instruction[15:0];
	
reg [31:0] prog_counter;
reg [31:0] jump_address;
reg we_are_jumping;


instr_memory instr_inst( 
					.addr_in(prog_counter), 
					.instr_out(instruction)
					);
//------------------------------------------------------				

//register file and it's command signals
reg [4:0]  reg_a_addr, reg_b_addr, reg_write_addr;
reg [31:0] reg_write_data;
reg reg_we;
wire [31:0] reg_a, reg_b;

register_file reg_inst( 
					.clk(clk), 
					.ra_in(reg_a_addr), 
					.rb_in(reg_b_addr), 
					.rw_in(reg_write_addr), 
					.write_en_in(reg_we), 
					.bus_w_in(reg_write_data), 
					.bus_a_out(reg_a), 
					.bus_b_out(reg_b)
					);
//-------------------------------------------------------

//ALU and it's command signals
reg [31:0] alu_a, alu_b;
wire [31:0] alu_out;
reg alu_signed_operation;
reg [1:0] alu_type_of_operation;
reg [1:0] alu_shift_operation;
reg alu_arith_operation;
reg [1:0] alu_logic_operation;
wire zero_out, overflow_out;//alu output
assign shift_amount = func[3]?reg_a[4:0]:sa;

alu alu_inst( 
					.a_in(alu_a),
					.b_in(alu_b), 
					.signed_operation_in(alu_signed_operation),
					.type_of_operation_in(alu_type_of_operation),
					.shift_operation_in(alu_shift_operation),
					.arithmetic_operation_in(alu_arith_operation),
					.logical_operation_in(alu_logic_operation),
					.alu_result_out(alu_out), 
					.zero_out(zero_out),
					.overflow_out(overflow_out)
					);	
					
//--------------------------------------------------

//data memory and it's command signals
wire [31:0] mem_out;//data memory output


wire [31:0] ext_imm16;//result after extender
reg mem_we;
data_memory data_mem(	
					.data_in(reg_b),
					.addr_in(alu_out),
					.we(mem_we), 
					.clk(clk),
					.data_out(mem_out)
					);
					
//--------------------------------------------
	
//program counter
always @(posedge clk or negedge n_rst)
begin
	if (!n_rst)
	prog_counter = 0;
	else if (we_are_jumping)
		prog_counter <=jump_address;
	else
		prog_counter[31:2]<= prog_counter[31:2]+1;
end

assign ext_imm16 = {{16{alu_signed_operation & immediate[15]}}, immediate[15:0]};

always @(*) begin
	reg_a_addr = rs;
	reg_b_addr = rt;
	reg_write_data = alu_out;
	reg_we = 1;
	mem_we = 0;
	//defaults to avoid inferring latches
	reg_write_addr = rd;
	alu_logic_operation = special[1:0];
	alu_arith_operation = special[1];
	alu_signed_operation = special[0];
	//there is no immediate shift intruction
	//synopsis parallel_case
			case(func[1:0])
				2'b00: alu_shift_operation = alu_inst.SLL;
				2'b10: if(rotr_srl_switch)
							alu_shift_operation = alu_inst.ROR;
						 else
							alu_shift_operation = alu_inst.SRL;
				default: alu_shift_operation = alu_inst.SRA;
			endcase
			
	//usually, we are not jumping, but when we jumping - the default is j
	we_are_jumping = 0;
	jump_address = {prog_counter[31:28], instruction[25:0], 2'b00};
	
	if(!special) begin //r_type
		reg_write_addr = rd;
		alu_b = reg_b;
		alu_logic_operation = func[1:0];
		alu_arith_operation = func[1];
		//alu_signed_operation = ~func[0];
		if (!func[5:3]) begin //shift instruction with sa
			alu_type_of_operation = alu_inst.SHIFT;
			alu_signed_operation = 0;
			alu_a = shift_amount;
		end else begin //other instruction
			alu_a = reg_a;
			if(func[2])//logical instruction
			begin
				alu_type_of_operation = alu_inst.LOGIC;
				alu_signed_operation = 0;
			end
			else begin 
			alu_signed_operation = 1;
				if (func[5]^func[3]) begin //arithmetial instruction or jr
					alu_type_of_operation = alu_inst.ARITH;
					we_are_jumping = func[3];
				end else begin
					alu_type_of_operation = alu_inst.SLT;
				end
			end
		end
	end else if (special[5:3]) begin // immediate instruction
		reg_write_addr = rt;
		alu_a = reg_a;
		alu_b = ext_imm16;
		alu_type_of_operation = alu_inst.ARITH;
		if (special[5]) begin //sw and lw
			reg_write_data = mem_out;
			mem_we = special[3];
			reg_we = ~special[3];
			alu_arith_operation = 0;
			alu_signed_operation = 0;
		end else if (&special[3:0]) begin //lui
			alu_b = {immediate, {16{1'b0}}};
			alu_arith_operation = 0;
			alu_signed_operation = 0;
		end else begin	//immediate arithmetial and logical
			//alu_signed_operation = ~special[0];
			if(special[2])//logical instruction
			begin
				alu_type_of_operation = alu_inst.LOGIC;
				alu_signed_operation = 0;
			end
			else begin //arithmetial instruction or jr
				alu_type_of_operation = alu_inst.ARITH;
				alu_signed_operation = 1;
			end 
		end
	end else begin
		reg_we = 0;
		alu_a = reg_a;
		alu_b = reg_b;
		alu_type_of_operation = alu_inst.ARITH;
		alu_arith_operation = 1;
		alu_signed_operation = 0;
		if (special[2]) begin	
			jump_address = prog_counter + {{14{immediate[15]}}, immediate[15:0]+1, 2'b00};
			we_are_jumping = zero_out^special[0];
		end else begin
			we_are_jumping = 1;
		end
		
	end
	
end
endmodule

