`timescale 1 ns / 1 ns

module filter
               (
                clk,
                n_reset,
                filter_in,
                filter_out
                );

  input   clk; 
  input   n_reset; 
  input   signed [17:0] filter_in; 
  output reg signed [17:0] filter_out; 
  
  
  //local variables
  wire shft_clock;// signal for shift
  reg [21:0] main_MX;
  wire [21:0] inv_MX;
  wire [24:0] added_result;
  wire signed[24:0] ext_inv_MX;
  wire [19:0] shifted_accumulator;
  wire [17:0] saturated_result;
  
  reg  signed [17:0] shift_register [0:10];
  reg [3:0] shft_clock_cntr; // counter for generation shft_clock signal
  reg signed [24:0] accumulator;
//  reg [17:0] output_register;
  
  integer i;//iterator
  
  
	always @(posedge clk, negedge n_reset)
		if (!n_reset) begin
			shft_clock_cntr <= 4'b1110 ; 
		end else begin
			if (shft_clock_cntr == 4'b1110)
				shft_clock_cntr <= 4'b0000;
			else
				shft_clock_cntr <= shft_clock_cntr + 1;
		end
		
		
	
	always @(posedge clk, negedge n_reset)
		begin
		if (!n_reset)
			for(i = 0; i < 11; i = i + 1)// shift register nulling 
				shift_register[i] <= 0;
		else
			begin
				if (shft_clock_cntr==4'b1110) begin
					shift_register[0] <= filter_in;
					for(i = 10; i > 0; i = i - 1)
						shift_register[i] <= shift_register[i-1];
				end
			end
		end
		
		

	always @ *
		begin
			
			case (shft_clock_cntr)
				4'b0000: main_MX = shift_register[0];
				4'b0001: main_MX = shift_register[0]<<1 ;
                     		4'b0010: main_MX = shift_register[1]<<3 ;
                     		4'b0011: main_MX = shift_register[2]<<3 ;
                     		4'b0100: main_MX = shift_register[4]<<3 ;
                     		4'b0101: main_MX = shift_register[4]<<1;
                     		4'b0110: main_MX = shift_register[4] ;
                     		4'b0111: main_MX = shift_register[5]<<4 ;
		     		4'b1000: main_MX = shift_register[6]<<3 ;
                     		4'b1001: main_MX = shift_register[6]<<1 ;
                     		4'b1010: main_MX = shift_register[6] ;
                     		4'b1011: main_MX = shift_register[8]<<3 ;
                     		4'b1100: main_MX = shift_register[9]<<3 ;
                     		4'b1101: main_MX = shift_register[10] ;
				default: main_MX = shift_register[10]<<<1;
			endcase
		end

	
	

							
							
	assign inv_MX = (shft_clock_cntr >= 4'b0100 && shft_clock_cntr <= 4'b1010) ? main_MX:
						(main_MX==22'b1000000000000000000000)?22'b0111111111111111111111:
						~main_MX+1;
						
	assign ext_inv_MX = $signed(inv_MX);//extended MX output
					
	assign added_result = (shft_clock_cntr==4'b0000)? $unsigned(ext_inv_MX) : ($unsigned(accumulator) + $unsigned(ext_inv_MX));
					
					
	always @(posedge clk, negedge n_reset)
		begin
		if (!n_reset)
				accumulator <= 0;
		else
			begin
				accumulator <= added_result;
			end
		end
	
	
	//assign shifted_accumulator = accumulator >>5;
	assign shifted_accumulator = (accumulator + {accumulator[5], {4{~accumulator[5]}}}) >>> 5;// for rounding
	
	
	assign saturated_result = (shifted_accumulator[19] == 1'b1 & ~(shifted_accumulator[18] & shifted_accumulator[17])) ? 18'b100000000000000000 : (shifted_accumulator[18] == 1'b0 & (shifted_accumulator[18] | shifted_accumulator[17] )) ? 18'b011111111111111111 : shifted_accumulator[17:0];//overflow checking
	
	always @ (posedge clk, negedge n_reset)//output_register
		begin
		if (!n_reset) begin
			filter_out <= 0;
		end
		else begin
		if (shft_clock_cntr==4'b0000)
          filter_out <= saturated_result;
      end
    end // Output_Register_process
					
endmodule  // filter

