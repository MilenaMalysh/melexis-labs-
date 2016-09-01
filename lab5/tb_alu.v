`timescale 1ns / 1ps
module tb_alu;
reg [31:0] a, b;
reg [1:0] type_of_operation, shift_operation, logical_operation;
reg arithmetic_operation;
wire [31:0] alu_result;
wire zero, overflow;
alu alu_inst(
	.a_in(a),
	.b_in(b), 
	.type_of_operation_in(type_of_operation),
	.shift_operation_in(shift_operation),
	.arithmetic_operation_in(arithmetic_operation),
	.logical_operation_in(logical_operation),
	.alu_result_out(alu_result), 
	.zero_out(zero),
	.overflow_out(overflow));
integer i, j;

initial begin
	check_arith();
	$stop();
end

task check_arith; 
begin
  //testing arithmetical operations
	type_of_operation = alu_inst.ARITH;
	for(i=-10;i<10; i=i+1)begin
		for(j=-10;j<10; j=j+1) begin
			a = i;
			b = j;
			arithmetic_operation = 0;
			#10;
			check_arith_error();
			arithmetic_operation = 1;
			#10;
			check_arith_error();
			end
		end
		#10;
		arithmetic_operation = 0;
		a = 32'h7FFFFFFF;
		b = 32'h7FFFFFFA;
		#10;
		check_arith_error();
		a = 32'h80000000;
		b = 32'h8000000F;
		#10;
		check_arith_error();
		arithmetic_operation = 1;
		a = 32'h80000000;
		b = 32'h7FFFFFFA;
		#10;
		check_arith_error();
		a = 32'h7FFFFFFF;
		b = 32'h8000000F;
		#10;
		check_arith_error();
end
endtask
task check_logic;
begin
  //testing logical operations
	type_of_operation = alu_inst.LOGIC;
end
endtask
task check_arith_error; 
begin
  if(arithmetic_operation) begin
    if(($signed(alu_result)!=i-j)&&!overflow)
      $display("Error in arithmetic operation when substituting %d from %d. Expected %d, got %d", i, j, i+j, $signed(alu_result));
    if((i>0&&j<0&&i-j<0||i<0&&j>0&&i-j>0)^overflow)
      $display("Error in arithmetic operation when substituting %d from %d. Expected overflow %b, got %b", i, j, ~overflow, overflow);
  end else begin
    if($signed(alu_result)!=i+j)
			$display("Error in arithmetic operation when adding %d to %d. Expected %d, got %d", i, j, i+j, $signed(alu_result));
		if((i>0&&j>0&&i+j<0||i<0&&j<0&&i+j>0)^overflow)
			$display("Error in arithmetic operation when adding %d to %d. Expected overflow %b, got %b", i, j, ~overflow, overflow);
	end
end
endtask
endmodule