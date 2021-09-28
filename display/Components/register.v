module register #(parameter WIDTH=8, RST_DATA=0) (input i_clk, i_rst_n, i_en,
		input [WIDTH-1:0] i_D,
		output reg [WIDTH-1:0] o_Q);


always @(posedge i_clk, negedge i_rst_n)
begin
	if (!i_rst_n)
		o_Q <= RST_DATA;
	else begin
		if (i_en)
			o_Q <= i_D;
	end

end

endmodule
