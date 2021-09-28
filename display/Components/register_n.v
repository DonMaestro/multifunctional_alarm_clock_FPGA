module register_n #(parameter WIDTH=8)(input i_clk, i_rst_n, //i_en
		input [WIDTH-1:0] i_D,
		output reg [WIDTH-1:0] o_Q);


always @(negedge i_clk, negedge i_rst_n)
begin
	if (!i_rst_n)
		o_Q <= 0;
	else begin
		if (!i_clk)
			o_Q <= i_D;
	end

end

endmodule
