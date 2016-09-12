`timescale 1ns / 1ps
module mips_pipeline(
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
reg [31:0] ext_pr_counter;
reg [15:0] next_instr;
reg [31:0] jump_address;
reg we_are_jumping;


// registers for pipeline
reg stall;
reg we_stall, we_bypass;
reg a_src;
reg re1, re2;

//fetch phase
reg [31:0] instruction_register_pip;
//decode & register fetch phase
reg [31:0] alu_a_pip, alu_b_pip, data_mem_in_exec_pip;//.._exec_pip - register for execute phase 
	//control signals
reg [1:0] alu_type_of_operation_exec_pip;
reg alu_signed_operation_exec_pip;
reg mem_we_exec_pip;
reg reg_we_exec_pip;
reg alu_arith_operation_exec_pip;
reg [1:0] alu_shift_operation_exec_pip;
reg [1:0] alu_logic_operation_exec_pip;
reg [4:0] reg_write_addr_exec_pip;
reg we_bypass_exec;
reg we_stall_exec;
//execute phase
reg [31:0] data_mem_addr_pip, data_mem_in_mem_pip;//.._mem_pip - register for memory phase
reg [4:0] reg_write_addr_mem_pip;
	//control signals
reg mem_we_mem_pip;
reg reg_we_mem_pip;

//memory phase
reg [31:0] reg_write_data_pip;

	//control signals
reg reg_we_wrtbck_pip; //.._wrtbck_pip - register for writeback phase
reg [4:0] reg_write_addr_wrtbck_pip;
//writeback phase




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
					.rw_in(reg_write_addr_wrtbck_pip), 
					.write_en_in(reg_we), 
					.bus_w_in(reg_write_data_pip), 
					.bus_a_out(reg_a), 
					.bus_b_out(reg_b)
					);
//-------------------------------------------------------

//ALU and it's command signals
reg [31:0] alu_a, alu_b;
wire [31:0] alu_out;
reg [31:0] alu_a_mx;
reg alu_signed_operation;
reg [1:0] alu_type_of_operation;
reg [1:0] alu_shift_operation;
reg alu_arith_operation;
reg [1:0] alu_logic_operation;
wire zero_out, overflow_out;//alu output
assign shift_amount = func[3]?reg_a[4:0]:sa;

alu alu_inst( 
					.a_in(alu_a_pip),
					.b_in(alu_b_pip), 
					.signed_operation_in(alu_signed_operation_exec_pip),
					.type_of_operation_in(alu_type_of_operation_exec_pip),
					.shift_operation_in(alu_shift_operation_exec_pip),
					.arithmetic_operation_in(alu_arith_operation_exec_pip),
					.logical_operation_in(alu_logic_operation_exec_pip),
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
					.data_in(data_mem_in_mem_pip),
					.addr_in(data_mem_addr_pip),
					.we(mem_we), 
					.clk(clk),
					.data_out(mem_out)
					);
					
//--------------------------------------------
	
//program counter
always @(posedge clk or negedge n_rst)
begin
	if (!n_rst)
	prog_counter <= 0;
	else if (!stall)
	begin
		if (we_are_jumping)
			prog_counter <=jump_address;
		else
			prog_counter[31:2]<= prog_counter[31:2]+1;
	end
end


// registers for pipeline

//common control signals




//fetch phase
//reg [31:0] instruction_register_pip;


always @(posedge clk)
begin
	if (!stall)
		instruction_register_pip <= instruction;
end

//decode & register fetch phase
//reg [31:0] alu_a_pip, alu_b_pip, data_mem_in_exec_pip//.._exec_pip - register for execute phase 
/*
	reg [1:0] alu_type_of_operation_exec_pip;
	reg alu_signed_operation_exec_pip;
	reg mem_we_exec_pip;
	reg reg_we_exec_pip;
	reg alu_arith_operation_exec_pip;
	reg [1:0] alu_shift_operation_exec_pip;
	reg [1:0] alu_logic_operation_exec_pip;

*/

always @(*)
begin
	if (a_src)
		alu_a_mx <= alu_out;
	else
		alu_a_mx <= alu_a;
end


always @(posedge clk)
begin
		alu_a_pip <= alu_a_mx;
end

always @(posedge clk)
begin
		alu_b_pip <= alu_b;
end

always @(posedge clk)
begin
		data_mem_in_exec_pip <= reg_b;
end

always @(posedge clk)
begin
		alu_type_of_operation_exec_pip <= alu_type_of_operation;
end

always @(posedge clk)
begin
		alu_signed_operation_exec_pip <= alu_signed_operation;
end

always @(posedge clk)
begin
		alu_arith_operation_exec_pip <= alu_arith_operation;
end

always @(posedge clk)
begin
		alu_shift_operation_exec_pip <= alu_shift_operation;
end

always @(posedge clk)
begin
		alu_logic_operation_exec_pip <= alu_logic_operation;
end

always @(posedge clk)
begin
	if (stall)
		mem_we_exec_pip <= 0;
	else
		mem_we_exec_pip <= mem_we;
end

always @(posedge clk)
begin
	if (stall)
		reg_we_exec_pip <= 0;
	else
		reg_we_exec_pip <= reg_we;
end


always @(posedge clk)
begin
		reg_write_addr_exec_pip <= reg_write_addr;
end

always @(posedge clk, negedge n_rst)
begin
	if (!n_rst)
		we_bypass_exec <= 0;
	else
		we_bypass_exec <= we_bypass;
end


always @(posedge clk, negedge n_rst)
begin
	if (!n_rst)
		we_stall_exec <= 0;
	else
		we_stall_exec <= we_stall;
end



assign a_src = ((rs ==reg_write_addr_exec_pip)?1:0)&& we_bypass_exec && re1;


assign stall = (((rs ==reg_write_addr_exec_pip)?1:0)&&we_stall_exec || ((rs ==reg_write_addr_mem_pip)?1:0)&&reg_we_mem_pip || ((rs ==reg_write_addr_wrtbck_pip)?1:0)&&reg_we_wrtbck_pip)&&re1 ||(((rt ==reg_write_addr_exec_pip)?1:0)&& reg_we_exec_pip ||((rt ==reg_write_addr_mem_pip)?1:0)&&reg_we_mem_pip ||((rt ==reg_write_addr_wrtbck_pip)?1:0)&&reg_we_wrtbck_pip)&& re2;
//execute phase
//reg [31:0] data_mem_addr_pip, data_mem_in_mem_pip//.._mem_pip - register for memory phase

	/*
	reg mem_we_mem_pip;
	reg reg_we_mem_pip;
	*/
	
	
always @(posedge clk)
begin
		data_mem_addr_pip <= alu_out;
end

always @(posedge clk)
begin
		data_mem_in_mem_pip <= data_mem_in_exec_pip;
end

always @(posedge clk)
begin
	if (stall)
		mem_we_mem_pip <= 0;
	else
		mem_we_mem_pip <= mem_we_exec_pip;
end

always @(posedge clk)
begin
	if (stall)
		reg_we_mem_pip <= 0;
	else
		reg_we_mem_pip <= reg_we_exec_pip;
end

always @(posedge clk)
begin
		reg_write_addr_mem_pip <= reg_write_addr_exec_pip;
end

//memory phase
//reg [31:0] reg_write_data_pip;

always @(posedge clk)
begin
		reg_write_data_pip <= reg_write_data;
end

always @(posedge clk)
begin
		reg_write_addr_wrtbck_pip <= reg_write_addr_mem_pip;
end

	//reg reg_we_wrtbck_pip;
	
	
always @(posedge clk)
begin
	if (stall)
		reg_we_wrtbck_pip <= 0;
	else
		reg_we_wrtbck_pip <= reg_we_mem_pip;
end

//writeback phase




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
/*				2'b00: alu_shift_operation = alu_inst.SLL;
				2'b10: if(rotr_srl_switch)
							alu_shift_operation = alu_inst.ROR;
						 else
							alu_shift_operation = alu_inst.SRL;
				default: alu_shift_operation = alu_inst.SRA;
				
*/
				2'b00: alu_shift_operation = alu.SLL;
				2'b10: if(rotr_srl_switch)
							alu_shift_operation = alu.ROR;
						 else
							alu_shift_operation = alu.SRL;
				default: alu_shift_operation = alu.SRA;
			endcase
			
	//usually, we are not jumping, but when we jumping - the default is j
	we_are_jumping = 0;
	jump_address = {prog_counter[31:28], instruction[25:0], 2'b00};
	we_bypass = 0;
	we_stall = 0;
	re1 = 1;
	re2 = 0;
	
	if(!special) begin //r_type
		re2 = 1;
		we_bypass = 1;
		reg_write_addr = rd;
		alu_b = reg_b;
		alu_logic_operation = func[1:0];
		alu_arith_operation = func[1];
		//alu_signed_operation = ~func[0];
		if (!func[5:3]) begin //shift instruction with sa
			alu_type_of_operation = alu.SHIFT;
			alu_signed_operation = 0;
			if (func[2]) 
				alu_a = reg_a;
			else 
				alu_a = shift_amount;
		end else begin //other instruction
			alu_a = reg_a;
			if(func[2])//logical instruction
			begin
				alu_type_of_operation = alu.LOGIC;
				alu_signed_operation = 0;
			end
			else begin 
			alu_signed_operation = 1;
				if (func[5]^func[3]) begin //arithmetical instruction or jr
					alu_type_of_operation = alu.ARITH;
					we_are_jumping = func[3];
				end else begin
					alu_type_of_operation = alu.SLT;
					if (func[0]) alu_signed_operation = 0;
				end
			end
		end
	end else if (special[5:3]) begin // immediate instruction
		reg_write_addr = rt;
		alu_a = reg_a;
		alu_b = ext_imm16;
		alu_type_of_operation = alu.ARITH;
		we_bypass = 1;
		if (special[5]) begin //sw and lw
			we_bypass = 0;
			reg_write_data = mem_out;
			mem_we = special[3];
			reg_we = ~special[3];
			alu_arith_operation = 0;
			alu_signed_operation = 0;
			we_stall = ~special[3];
			re2 = special[3];
		end else if (&special[3:0]) begin //lui
			alu_b = {immediate, {16{1'b0}}};
			alu_arith_operation = 0;
			alu_signed_operation = 0;
		end else begin	//immediate arithmetial and logical
			//alu_signed_operation = ~special[0];
			if(special[2])//logical instruction
			begin
				alu_type_of_operation = alu.LOGIC;
				alu_signed_operation = 0;
			end
			else begin //arithmetial instruction or jr
				alu_type_of_operation = alu.ARITH;
				alu_signed_operation = 1;
			end 
		end
	end else begin
		we_bypass = 1;
		reg_we = 0;
		alu_a = reg_a;
		alu_b = reg_b;
		alu_type_of_operation = alu.ARITH;
		alu_arith_operation = 1;
		alu_signed_operation = 0;
		if (special[2]) begin	
			next_instr = immediate[15:0]+1;
			ext_pr_counter = {{14{immediate[15]}}, next_instr, 2'b00};
			jump_address = prog_counter + ext_pr_counter;
			we_are_jumping = zero_out^special[0];
		end else begin
			we_are_jumping = 1;
			re1 = 0;
		end
		
	end
	
end
endmodule

