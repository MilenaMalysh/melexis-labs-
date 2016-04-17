`timescale 1ns / 1ps
module traffic_light(clk, reset, o_red, o_yellow1, o_green, o_yellow2);

	input	clk, reset;
	output reg o_red, o_yellow1, o_green, o_yellow2;


	// Declare state register
	reg		[1:0]state;
	
	wire [5:0] counter;

	// Declare states
	parameter RED = 0, YELLOW1 = 1, GREEN = 2, YELLOW2 = 3;
	parameter RED_DURATION = 4, YELLOW1_DURATION = 3, GREEN_DURATION = 2, YELLOW2_DURATION = 3;
	
	timer #(.RED_DURATION(RED_DURATION),
			  .YELLOW1_DURATION(YELLOW1_DURATION),
			  .GREEN_DURATION(GREEN_DURATION),
			  .YELLOW2_DURATION(YELLOW2_DURATION) 
			) timer(
				.clk(clk),
				.reset(reset), 
				.red(o_red), 
				.yellow1(o_yellow1), 
				.green(o_green),
				.yellow2(o_yellow2),
				.temp(counter)
			);
	
	// Determine the next state
	always @ (posedge clk or negedge reset) begin
		if (!reset)
			begin
				state <= RED;
				o_red <= 1'b1;
				o_yellow1 <= 1'b0;
				o_green <= 1'b0;
				o_yellow2 <= 1'b0;
			end
		else begin
			o_red <= 1'b0;
			o_yellow1 <= 1'b0;
			o_green <= 1'b0;
			o_yellow2 <= 1'b0;
			case (state)
				RED:
					if (counter!=1)
						begin
							state <= RED;
							o_red <= 1'b1;
						end
					else
						begin
							state <= YELLOW1;
							o_yellow1 <= 1'b1;
						end
				YELLOW1:
					if (counter!=1)
						begin
							state <= YELLOW1;
							o_yellow1 <= 1'b1;
						end
					else
						begin
							state <= GREEN;
							o_green <= 1'b1;
						end
				GREEN:
					if (counter!=1)
						begin
							state <= GREEN;
							o_green <= 1'b1;
						end
					else
						begin
							state <= YELLOW2;
							o_yellow2 <= 1'b1;
						end
				YELLOW2:
					if (counter!=1)
						begin
							state <= YELLOW2;
							o_yellow2 <= 1'b1;
						end
					else
						begin
							state <= RED;
							o_red <= 1'b1;
						end
			endcase
		end
	end

endmodule


module timer(clk, reset, red, yellow1, green, yellow2, temp);

	input	clk, reset, red, yellow1, yellow2, green;
	output reg [5:0] temp;

	parameter RED_DURATION = 4, YELLOW1_DURATION = 3, GREEN_DURATION = 2, YELLOW2_DURATION = 3;
	always @(posedge clk or negedge reset)
	begin
			if(!reset)
				begin
					temp<= RED_DURATION+1;
				end
			else
				if (temp==0)
					case (1'b1) // synopsys  parallel_case 
						red:
							temp<= RED_DURATION-1;
						yellow1:
							temp<= YELLOW1_DURATION-1;
						green:
							temp<= GREEN_DURATION-1;
						yellow2:
							temp<= YELLOW2_DURATION-1;
					endcase
				else 
					temp<=temp - 1'b1;
	end
endmodule

