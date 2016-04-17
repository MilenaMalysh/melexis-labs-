`timescale 1ns / 1ps
module vending_machine
(
	clk, reset, code_of_product_in, type_of_banknote_in, amount_of_banknote_in, product_purchasing_in, currency_strode_in,
	busy, type_of_banknote_out, changing_out, code_of_product_out, giving_product_out
);




	// Declare state register
	reg		[3:0]state;

	parameter MAX_PRICE = 200;
	parameter INITIAL = 0, BUSY_SET = 1, TEMP_CURR_WAIT = 2, INPUT_MONEY_CALCULATION = 3 , TEMP_STATE = 4, SUB_CHANGE = 5, SUB_BANK = 6, GIVING_PRODUCT = 7;
	
	parameter PRODUCTS_QUANTITY = 5;
	parameter integer PRODUCTS_PRICES [PRODUCTS_QUANTITY-1 : 0]   = '{5, 7, 200, 2, 235};
	
	parameter BANKNOTS_QUANTITY_AFTER_RESET = 20;
	parameter DENOMINATION_QUANTITY = 10;
	parameter integer DENOMINATIONS [9 : 0]   = '{500, 200, 100, 50, 20, 10, 5, 2, 1, 0};//0 - out for no appropriate baknote for change
	
	
	
	input clk, reset, product_purchasing_in, currency_strode_in;
	input [$clog2(PRODUCTS_QUANTITY)-1: 0] code_of_product_in; 
	input [$clog2(DENOMINATION_QUANTITY-1) : 0] type_of_banknote_in;
	input [8:0]amount_of_banknote_in;
	output reg	busy, changing_out, giving_product_out;
	output reg [$clog2(DENOMINATION_QUANTITY-1) : 0]type_of_banknote_out;
	output reg [$clog2(PRODUCTS_QUANTITY)-1: 0]code_of_product_out; 
	
	
	
	
	integer banknots_quantity [DENOMINATION_QUANTITY-1 : 0];
	reg [8:0] banknote_amount [DENOMINATION_QUANTITY-1 : 0];
	reg [$clog2(PRODUCTS_QUANTITY)-1: 0] selected_product;
	reg [$clog2(MAX_PRICE+500)-1: 0] inserted_money_storage;
	reg [$clog2(MAX_PRICE+500)-1: 0] temp_inserted_money;
	
	integer i;
	

	

	// Determine the next state
	always @ (posedge clk or posedge reset) begin
		if (!reset)
		begin
			state <= INITIAL;
			selected_product <= 0;
			inserted_money_storage <= 0;
			temp_inserted_money <= 0;
			changing_out <=0;
			giving_product_out <=0;
			busy<=0;
			for (i = 0; i<DENOMINATION_QUANTITY; i= i+1)
						begin
							banknots_quantity[i] <= BANKNOTS_QUANTITY_AFTER_RESET;
						end
			
		end
		else
		begin
		
			changing_out <=0;
			giving_product_out <=0;
		
			case (state)
				INITIAL:
				begin
			
				
					if (product_purchasing_in)
						state <= BUSY_SET;
					else 
						state <= INITIAL;
				end
				BUSY_SET:
				begin
				

					busy <= 1;
					selected_product <= code_of_product_in;
					state <= TEMP_CURR_WAIT;

				end
				TEMP_CURR_WAIT:
				begin
				
				

				
					if (currency_strode_in)
						state <= INPUT_MONEY_CALCULATION;
					else 
						state <= TEMP_CURR_WAIT;
				end
				
				INPUT_MONEY_CALCULATION:
				begin
				
				
				inserted_money_storage <= inserted_money_storage + DENOMINATIONS[type_of_banknote_in] * amount_of_banknote_in;
				
				
					if (inserted_money_storage + DENOMINATIONS[type_of_banknote_in] * amount_of_banknote_in< PRODUCTS_PRICES[selected_product])
						state <= TEMP_CURR_WAIT;
					else 
						state <= TEMP_STATE;
				end
				TEMP_STATE:
				begin
				
				
			
					if (inserted_money_storage == PRODUCTS_PRICES[selected_product])
						state <= GIVING_PRODUCT;
					else 
						state <= SUB_CHANGE;
				end
				SUB_CHANGE:
				begin
				type_of_banknote_out <= 0;
				for (i = 1; i<DENOMINATION_QUANTITY; i= i+1)
						begin
						
							if ((DENOMINATIONS[i]<=(inserted_money_storage - PRODUCTS_PRICES[selected_product]))&&(banknots_quantity[i]>0))
								begin
									inserted_money_storage <= inserted_money_storage - DENOMINATIONS[i];
									type_of_banknote_out <= i;
								end
						end

					state <= SUB_BANK;
				end
				
				
				SUB_BANK:
				begin
				banknots_quantity[type_of_banknote_out] <= banknots_quantity[type_of_banknote_out]-1;
				changing_out<=1;
					
					if (type_of_banknote_out!=0)
						state <= TEMP_STATE;
					else 
						state <= GIVING_PRODUCT;
				end

				GIVING_PRODUCT:
				begin
					giving_product_out <= 1;
					code_of_product_out <= selected_product;
					busy <= 0;
				
				
					state <= INITIAL;	
				end
			endcase
		end
	end
endmodule


