`timescale 1ns / 1ps
module vending_machine_tb;
parameter PERIOD = 4;
parameter PRODUCTS_QUANTITY = 5;
parameter DENOMINATION_QUANTITY = 10;
parameter integer DENOMINATIONS [9 : 0]   = '{500, 200, 100, 50, 20, 10, 5, 2, 1, 0};//0 - out for no appropriate baknote for change
parameter integer PRODUCTS_PRICES [4 : 0]   = '{5, 7, 200, 2, 235};


reg clk, reset_n, product_purchasing_in, currency_strode_in;
reg [$clog2(PRODUCTS_QUANTITY)-1: 0] code_of_product_in; 
reg [$clog2(DENOMINATION_QUANTITY-1) : 0] type_of_banknote_in;
reg [8:0]amount_of_banknote_in;
wire busy, changing_out, giving_product_out;
wire [$clog2(DENOMINATION_QUANTITY-1) : 0]type_of_banknote_out;
wire [$clog2(PRODUCTS_QUANTITY)-1: 0]code_of_product_out; 
wire [3:0] state_out;

reg [$clog2(PRODUCTS_QUANTITY)-1: 0] i;
integer inserted_money;
integer product_cost;
reg no_money;



vending_machine vending_machine_inst1(			
					.clk(clk),
					.reset_n(reset_n),
					.state_out(state_out),
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
	reset_task();

	for (i = 0; i < PRODUCTS_QUANTITY; i = i + 1) begin
		initial_task();
		product_choise(i);
		currency_in();
		currency_out_processing();
		@(negedge clk);	
	end
	$finish;
end



task reset_task;
	begin
	$display("\n_____________________________RESET_STATE_____________________________");
	reset_n = 0;
	repeat (2) @(negedge clk)
	reset_n = 1;
	end
endtask

task initial_task;
	begin
	$display("\n_____________________________INITIAL_STATE_____________________________");
	product_purchasing_in = 0; 
	currency_strode_in = 0;
	code_of_product_in = 0;
	type_of_banknote_in = 0;
	amount_of_banknote_in =  0;
	// local variables 
	product_cost = 0;
	inserted_money = 0;
	no_money = 0;
	end
endtask


task product_choise;
	input reg [$clog2(PRODUCTS_QUANTITY)-1: 0] product;
	begin
	$display("\n___________________________PRODUCT_CHOISE____________________________");
	@(negedge clk)
	code_of_product_in = product;
	$display("\n product #%0d is chosen (%0d hryvnas)", product, PRODUCTS_PRICES[code_of_product_in]);
	product_cost = PRODUCTS_PRICES[code_of_product_in];
	repeat (5) @(negedge clk)
	product_purchasing_in = 1;
	@(negedge clk)
	product_purchasing_in = 0;
	end
endtask

task currency_in;
	begin
	$display("\n__________________________MONEY_PROCESSING___________________________");
	@(negedge clk)
	while (state_out!=4) begin
		type_of_banknote_in = $unsigned($random) % DENOMINATION_QUANTITY; 
		amount_of_banknote_in = $unsigned($random) % 2+1;
		inserted_money = inserted_money + DENOMINATIONS[type_of_banknote_in] * amount_of_banknote_in;
		$display ("%0d banknots %0d hryvna each were inserted", amount_of_banknote_in, DENOMINATIONS[type_of_banknote_in]);
		@(negedge clk)
		currency_strode_in = 1;
		@(negedge clk)
		currency_strode_in = 0;
		@(negedge clk);
	end
	
	end
endtask

task currency_out_processing;
integer currency_out;
	begin
	currency_out=0;
	$display("\n________________________MONEY_OUT_PROCESSING_________________________");
	@(negedge clk)
	@(negedge clk)
	while (!giving_product_out) begin
		@(posedge changing_out)
		if (!type_of_banknote_out)begin
		$display ("....ran out of cash....");
		no_money = 1;
		break;
		end
		currency_out = currency_out+DENOMINATIONS[type_of_banknote_out];
		@(negedge clk)
		@(negedge clk)
		@(negedge clk);
	end
	if (currency_out == 0) begin
	$display ("no money returned");
	end else begin
	$display ("%0d hryvnas were returned", currency_out);
		if (currency_out == inserted_money - product_cost) begin
		$display ("!!TEST SUCCEEDED!!");
		end else if (!no_money) begin
		$display ("??TEST FAILED??");
		end
	end
	
	end
endtask



endmodule


