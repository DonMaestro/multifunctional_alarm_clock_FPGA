
module decoder #(parameter WIDTH=4)(input [WIDTH>>2:0] i_A,
		output [WIDTH-1:0] o_P);


assign o_P = 1 << i_A;

/*
always @(*)
begin
	o_P = 1 << i_A;
end
*/
endmodule
