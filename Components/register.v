module register #(parameter WIDHT=8)(input i_clk, i_rst_n,
		input [WIDHT-1:0] i_D,
		output reg [WIDHT-1:0] o_Q);


always @(posedge i_clk, negedge i_rst_n)
begin
	if (!i_rst_n)
		o_Q <= 0;
	else begin
		o_Q <= i_D;
	end

end

endmodule
