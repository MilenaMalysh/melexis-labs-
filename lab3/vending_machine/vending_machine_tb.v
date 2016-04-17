`timescale 1ns / 1ps
module vending_machine_tb;
parameter PERIOD = 4;
parameter PRODUCTS_QUANTITY = 5;
parameter DENOMINATION_QUANTITY = 9;


reg clk, reset, product_purchasing_in, currency_strode_in;
reg [$clog2(PRODUCTS_QUANTITY)-1: 0] code_of_product_in; 
reg [$clog2(DENOMINATION_QUANTITY-1) : 0] type_of_banknote_in;
reg [8:0]amount_of_banknote_in;
wire busy, changing_out, giving_product_out;
wire [$clog2(DENOMINATION_QUANTITY-1) : 0]type_of_banknote_out;
wire [$clog2(PRODUCTS_QUANTITY)-1: 0]code_of_product_out; 



vending_machine #(.PRODUCTS_QUANTITY(PRODUCTS_QUANTITY),
		.DENOMINATION_QUANTITY(DENOMINATION_QUANTITY))

vending_machine_inst1(.clk(clk),
					.reset(reset),
					.code_of_product_in(code_of_product_in), 
					.type_of_banknote_in(type_of_banknote_in), 
					.amount_of_banknote_in(amount_of_banknote_in), 
					.product_purchasing_in(product_purchasing_in), 
					.currency_strode_in(currency_strode_in),
					.busy(busy), 
					.type_of_banknote_out(type_of_banknote_out), 
					.changing_out(changing_out), 
					.code_of_product_out(code_of_product_out), 
					.giving_product_out(giving_product_out)
			     );


initial begin
	clk = 0;
	forever #(PERIOD/2) clk = ~clk;
end



initial begin
	reset = 0;
	product_purchasing_in = 0; //
	currency_strode_in = 0;//
	code_of_product_in = 0;//
	type_of_banknote_in = 0;//
	amount_of_banknote_in =  0;
	@(negedge clk)
	code_of_product_in = 3;
	repeat (4) @(negedge clk) reset = 1;
	@(negedge clk)
	product_purchasing_in = 1;
	@(negedge clk)
	product_purchasing_in = 0;
	@(negedge clk)
	type_of_banknote_in = 3;
	amount_of_banknote_in = 2;
	@(negedge clk)
	currency_strode_in = 1;
	@(negedge clk)
	currency_strode_in = 0;

	repeat (10) @(negedge clk);

	reset = 0;
	product_purchasing_in = 0; //
	currency_strode_in = 0;//
	code_of_product_in = 0;//
	type_of_banknote_in = 0;//
	amount_of_banknote_in =  0;
	@(negedge clk)
	code_of_product_in = 4;
	repeat (4) @(negedge clk) reset = 1;
	@(negedge clk)
	product_purchasing_in = 1;
	@(negedge clk)
	product_purchasing_in = 0;
	@(negedge clk)
	type_of_banknote_in = 2;
	amount_of_banknote_in = 1;
	@(negedge clk)
	currency_strode_in = 1;
	@(negedge clk)
	currency_strode_in = 0;
	@(negedge clk)
	type_of_banknote_in = 3;
	amount_of_banknote_in = 1;
	@(negedge clk)
	currency_strode_in = 1;
	@(negedge clk)
	currency_strode_in = 0;

	
	repeat (100) @(negedge clk);
	$finish;
end

endmodule


