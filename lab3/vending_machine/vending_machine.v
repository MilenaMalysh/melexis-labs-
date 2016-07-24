`timescale 1ns / 1ps
module vending_machine
(
	clk, reset_n, code_of_product_in, type_of_banknote_in, amount_of_banknote_in, product_purchasing_in, currency_strode_in,
	busy, type_of_banknote_out, changing_out, code_of_product_out, giving_product_out, acknowledgment_money
);




	

	localparam MAX_PRICE = 200;
	parameter INITIAL = 0, BUSY_SET = 1, TEMP_CURR_WAIT = 2, INPUT_MONEY_CALCULATION = 3 , TEMP_STATE = 4, SUB_CHANGE = 5, SUB_BANK = 6, GIVING_PRODUCT = 7;
	
	localparam PRODUCTS_QUANTITY = 5;
	parameter reg[10:0] PRODUCTS_PRICES [4 : 0]   = '{5, 7, 200, 2, 235};
	
	parameter BANKNOTS_QUANTITY_AFTER_RESET = 2;
	localparam DENOMINATION_QUANTITY = 10;
	parameter reg[10:0] DENOMINATIONS [9 : 0]   = '{500, 200, 100, 50, 20, 10, 5, 2, 1, 0};//0 - out for no appropriate baknote for change
	
	
	
	input clk, reset_n, product_purchasing_in, currency_strode_in;
	input [$clog2(PRODUCTS_QUANTITY)-1: 0] code_of_product_in; 
	input [$clog2(DENOMINATION_QUANTITY-1) : 0] type_of_banknote_in;
	input [8:0]amount_of_banknote_in;
	output reg	busy, changing_out, giving_product_out;
	output reg [$clog2(DENOMINATION_QUANTITY-1) : 0]type_of_banknote_out;
	output reg [$clog2(PRODUCTS_QUANTITY)-1: 0]code_of_product_out; 
	// Declare state register
	output reg acknowledgment_money;
	
	
	reg [2:0]state_out;
	reg [10:0] banknots_quantity [DENOMINATION_QUANTITY-1 : 0];
	reg [8:0] banknote_amount [DENOMINATION_QUANTITY-1 : 0];
	reg [$clog2(PRODUCTS_QUANTITY)-1: 0] selected_product;
	reg [$clog2(MAX_PRICE+500)-1: 0] inserted_money_storage;
	
	
	integer i;
	

	

	// Determine the next state
	always @ (posedge clk or negedge reset_n) begin
		if (!reset_n)
		begin
			//initialization
			state_out <= INITIAL;
			for (i = 0; i<DENOMINATION_QUANTITY; i= i+1)
						begin
							banknots_quantity[i] <= BANKNOTS_QUANTITY_AFTER_RESET;//banknots quantity array initialization
						end
			selected_product <= 0;
			inserted_money_storage <= 0;
			changing_out <=0;
			giving_product_out <=0;
			busy<=0;
			type_of_banknote_out <= 0;
			code_of_product_out <= 0;
			acknowledgment_money<=0;
			
			
		end
		else
		begin
		
			changing_out <=0;
			giving_product_out <=0;
		
			case (state_out)
				INITIAL:
				begin
					selected_product <= 0;
					inserted_money_storage <= 0;
					changing_out <=0;
					giving_product_out <=0;
					busy<=0;
					acknowledgment_money<=0;
				
					if (product_purchasing_in)
						state_out <= BUSY_SET;
					else 
						state_out <= INITIAL;
				end
				BUSY_SET://the beginning of work 
				begin
				

					busy <= 1;
					selected_product <= code_of_product_in;
					state_out <= TEMP_CURR_WAIT;

				end
				TEMP_CURR_WAIT:
				begin
				
					if (currency_strode_in)// the signal of currency insertion
						state_out <= INPUT_MONEY_CALCULATION;
					else 
						state_out <= TEMP_CURR_WAIT;
				end
				
				INPUT_MONEY_CALCULATION:// inserted money analysis
				begin
				
				
				inserted_money_storage <= inserted_money_storage + DENOMINATIONS[type_of_banknote_in] * amount_of_banknote_in;
				banknots_quantity[type_of_banknote_in] <= banknots_quantity[type_of_banknote_in] + amount_of_banknote_in;
				
				
					if (inserted_money_storage + DENOMINATIONS[type_of_banknote_in] * amount_of_banknote_in< PRODUCTS_PRICES[selected_product])
						state_out <= TEMP_CURR_WAIT;
					else 
					begin
						state_out <= TEMP_STATE;
						acknowledgment_money<=1;
					end
				end
				TEMP_STATE:
				begin
				
				
			
					if (inserted_money_storage == PRODUCTS_PRICES[selected_product])// if no money for user needed
						state_out <= GIVING_PRODUCT;
					else 
						state_out <= SUB_CHANGE;
				end
				SUB_CHANGE:
				begin
				type_of_banknote_out <= 0;
				for (i = 1; i<DENOMINATION_QUANTITY; i= i+1)// trying to find suitable denomination
						begin
						
							if ((DENOMINATIONS[i]<=(inserted_money_storage - PRODUCTS_PRICES[selected_product]))&&(banknots_quantity[i]>0))
								begin
									inserted_money_storage <= inserted_money_storage - DENOMINATIONS[i];
									type_of_banknote_out <= i;
								end
						end

					state_out <= SUB_BANK;
				end
				
				
				SUB_BANK:
				begin
				changing_out<=1;
					
					if (type_of_banknote_out!=0)
						begin
						banknots_quantity[type_of_banknote_out] <= banknots_quantity[type_of_banknote_out]-1;//reduce the number of banknotes
						state_out <= TEMP_STATE;
						end
					else // if no money needed
						state_out <= GIVING_PRODUCT;
				end

				GIVING_PRODUCT:// product return 
				begin
					giving_product_out <= 1;
					code_of_product_out <= selected_product;
					busy <= 0;
				
				
					state_out <= INITIAL;	
				end
			endcase
		end
	end
endmodule


