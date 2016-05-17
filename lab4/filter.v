// -------------------------------------------------------------
//
// Module: filter
// Generated by MATLAB(R) 8.5 and the Filter Design HDL Coder 2.9.7.
// Generated on: 2016-05-15 17:20:31
// -------------------------------------------------------------

// -------------------------------------------------------------
// HDL Code Generation Options:
//
// ResetType: Synchronous
// TargetDirectory: D:\μελεκρθρ\labs\my_labs\LAB4_Malysheva
// SerialPartition: 9
// TargetLanguage: Verilog
// TestBenchStimulus: impulse step ramp chirp noise 
// GenerateCoSimModel: Incisive

// -------------------------------------------------------------
// HDL Implementation    : Fully Serial
// Multipliers           : 1
// Folding Factor        : 9
// -------------------------------------------------------------
// Filter Settings:
//
// Discrete-Time FIR Filter (real)
// -------------------------------
// Filter Structure  : Direct-Form FIR
// Filter Length     : 11
// Stable            : Yes
// Linear Phase      : Yes (Type 1)
// Arithmetic        : fixed
// Numerator         : s6,5 -> [-1 1)
// Input             : s18,17 -> [-1 1)
// Filter Internals  : Specify Precision
//   Output          : s18,17 -> [-1 1)
//   Product         : s26,24 -> [-2 2)
//   Accumulator     : s26,24 -> [-2 2)
//   Round Mode      : convergent
//   Overflow Mode   : saturate
// -------------------------------------------------------------

`timescale 1 ns / 1 ns

module filter
               (
                clk,
                clk_enable,
                reset,
                filter_in,
                filter_out
                );

  input   clk; 
  input   clk_enable; 
  input   reset; 
  input   signed [17:0] filter_in; //sfix18_En17
  output  signed [17:0] filter_out; //sfix18_En17

////////////////////////////////////////////////////////////////
//Module Architecture: filter
////////////////////////////////////////////////////////////////
  // Local Functions
  // Type Definitions
  // Constants
  parameter signed [5:0] coeff1 = 6'b111101; //sfix6_En5
  parameter signed [5:0] coeff2 = 6'b111000; //sfix6_En5
  parameter signed [5:0] coeff3 = 6'b111000; //sfix6_En5
  parameter signed [5:0] coeff4 = 6'b000000; //sfix6_En5
  parameter signed [5:0] coeff5 = 6'b001011; //sfix6_En5
  parameter signed [5:0] coeff6 = 6'b010000; //sfix6_En5
  parameter signed [5:0] coeff7 = 6'b001011; //sfix6_En5
  parameter signed [5:0] coeff8 = 6'b000000; //sfix6_En5
  parameter signed [5:0] coeff9 = 6'b111000; //sfix6_En5
  parameter signed [5:0] coeff10 = 6'b111000; //sfix6_En5
  parameter signed [5:0] coeff11 = 6'b111101; //sfix6_En5

  // Signals
  reg  [3:0] cur_count; // ufix4
  wire phase_14; // boolean
  wire phase_0; // boolean
  reg  signed [17:0] delay_pipeline [0:10] ; // sfix18_En17
  wire signed [17:0] inputmux_1; // sfix18_En17
  reg  signed [23:0] acc_final; // sfix26_En24
  reg  signed [23:0] acc_out_1; // sfix26_En24
  wire signed [23:0] product_1; // sfix26_En24
  wire signed [5:0] product_1_mux; // sfix6_En5
  wire signed [21:0] mul_temp; // sfix24_En22
  wire signed [21:0] mul_unsigned_temp;
  wire signed [23:0] prod_typeconvert_1; // sfix26_En24
  wire signed [23:0] add_temp; // sfix26_En24
  wire signed [23:0] acc_in_1; // sfix26_En24
  wire signed [23:0] add_signext; // sfix26_En24
  wire signed [23:0] add_signext_1; // sfix26_En24
  wire signed [17:0] output_typeconvert; // sfix18_En17
  reg  signed [17:0] output_register; // sfix18_En17

  // Block Statements
  always @ ( posedge clk)
    begin: Counter_process
      if (reset == 1'b1) begin
        cur_count <= 4'b1110;
      end
      else begin
        if (clk_enable == 1'b1) begin
          if (cur_count == 4'b1110) begin
            cur_count <= 4'b0000;
          end
          else begin
            cur_count <= cur_count + 1;
          end
        end
      end
    end // Counter_process

  assign  phase_14 = (cur_count == 4'b1110 && clk_enable == 1'b1)? 1 : 0;

  assign  phase_0 = (cur_count == 4'b0000 && clk_enable == 1'b1)? 1 : 0;

  always @( posedge clk)
    begin: Delay_Pipeline_process
      if (reset == 1'b1) begin
        delay_pipeline[0] <= 0;
        delay_pipeline[1] <= 0;
        delay_pipeline[2] <= 0;
        delay_pipeline[3] <= 0;
        delay_pipeline[4] <= 0;
        delay_pipeline[5] <= 0;
        delay_pipeline[6] <= 0;
        delay_pipeline[7] <= 0;
        delay_pipeline[8] <= 0;
        delay_pipeline[9] <= 0;
        delay_pipeline[10] <= 0;
      end
      else begin
        if (phase_14 == 1'b1) begin
          delay_pipeline[0] <= filter_in;
          delay_pipeline[1] <= delay_pipeline[0];
          delay_pipeline[2] <= delay_pipeline[1];
          delay_pipeline[3] <= delay_pipeline[2];
          delay_pipeline[4] <= delay_pipeline[3];
          delay_pipeline[5] <= delay_pipeline[4];
          delay_pipeline[6] <= delay_pipeline[5];
          delay_pipeline[7] <= delay_pipeline[6];
          delay_pipeline[8] <= delay_pipeline[7];
          delay_pipeline[9] <= delay_pipeline[8];
          delay_pipeline[10] <= delay_pipeline[9];
        end
      end
    end // Delay_Pipeline_process


	assign mul_unsigned_temp = (cur_count == 4'b0000) ? delay_pipeline[0] :
                     (cur_count == 4'b0001) ? delay_pipeline[0]<<1 :
                     (cur_count == 4'b0010) ? delay_pipeline[1]<<3 :
                     (cur_count == 4'b0011) ? delay_pipeline[2]<<3 :
                     (cur_count == 4'b0100) ? delay_pipeline[4]<<3 :
                     (cur_count == 4'b0101) ? delay_pipeline[4]<<1:
                     (cur_count == 4'b0110) ? delay_pipeline[4] :
                     (cur_count == 4'b0111) ? delay_pipeline[5]<<4 :
					 (cur_count == 4'b1000) ? delay_pipeline[6]<<3 :
                     (cur_count == 4'b1001) ? delay_pipeline[6]<<1 :
                     (cur_count == 4'b1010) ? delay_pipeline[6] :
                     (cur_count == 4'b1011) ? delay_pipeline[8]<<3 :
                     (cur_count == 4'b1100) ? delay_pipeline[9]<<3 :
                     (cur_count == 4'b1101) ? delay_pipeline[10] :
					delay_pipeline[10]<<<1;
					
	assign mul_temp = (cur_count >= 4'b0100 && cur_count <= 4'b1010) ? mul_unsigned_temp :
						(mul_unsigned_temp==22'b1000000000000000000000)?22'b0111111111111111111111:
						~mul_unsigned_temp+1;

  //   ------------------ Serial partition # 1 ------------------

  /*assign product_1_mux = (cur_count == 4'b0000) ? coeff1 :
                        (cur_count == 4'b0001) ? coeff2 :
                        (cur_count == 4'b0010) ? coeff3 :
                        (cur_count == 4'b0011) ? coeff5 :
                        (cur_count == 4'b0100) ? coeff6 :
                        (cur_count == 4'b0101) ? coeff7 :
                        (cur_count == 4'b0110) ? coeff9 :
                        (cur_count == 4'b0111) ? coeff10 :
                        coeff11;*/
  //assign mul_temp = inputmux_1 * product_1_mux;
  assign product_1 = $signed(mul_temp);

  assign prod_typeconvert_1 = product_1;

  assign add_signext = prod_typeconvert_1;
  assign add_signext_1 = acc_out_1;
  assign add_temp = add_signext + add_signext_1;
 

  assign acc_in_1 = (phase_0 == 1'b1) ? prod_typeconvert_1 :
                   add_temp;

  always @ ( posedge clk)
    begin: Acc_reg_1_process
      if (reset == 1'b1) begin
        acc_out_1 <= 0;
      end
      else begin
        if (clk_enable == 1'b1) begin
          acc_out_1 <= acc_in_1;
        end
      end
    end // Acc_reg_1_process

  always @ ( posedge clk)
    begin: Finalsum_reg_process
      if (reset == 1'b1) begin
        acc_final <= 0;
      end
      else begin
        if (phase_0 == 1'b1) begin
          acc_final <= acc_out_1;
        end
      end
    end // Finalsum_reg_process

 /* assign output_typeconvert = ((acc_final[24] == 1'b0 & acc_final[23] != 1'b0) || (acc_final[24] == 1'b0 && acc_final[23:7] == 18'b011111111111111111) // special case0
) ? 18'b011111111111111111 : 
      (acc_final[24] == 1'b1 && acc_final[23] != 1'b1) ? 18'b100000000000000000 : (acc_final[23:0] + {acc_final[7], {6{~acc_final[7]}}})>>>7;
*/
//assign output_typeconvert = (acc_final[22] != acc_final[21])? ((acc_final[23]==0)?18'b011111111111111111:18'b100000000000000000):({acc_final[24],acc_final[21:0]} + {acc_final[5], {4{~acc_final[5]}}})>>>5;

  assign output_typeconvert = ((acc_final[23] == 1'b0 & acc_final[22] != 1'b0) || (acc_final[23] == 1'b0 && acc_final[22:5] == 18'b011111111111111111) // special case0
) ? 18'b011111111111111111 : 
      (acc_final[23] == 1'b1 && acc_final[22] != 1'b1) ? 18'b100000000000000000 : (acc_final[22:0] + {acc_final[5], {4{~acc_final[5]}}})>>>5;


  always @ ( posedge clk)
    begin: Output_Register_process
      if (reset == 1'b1) begin
        output_register <= 0;
      end
      else begin
        if (phase_14 == 1'b1) begin
          output_register <= output_typeconvert;
        end
      end
    end // Output_Register_process

  // Assignment Statements
  assign filter_out = output_register;
endmodule  // filter
