
module mux2in1 #(parameter WIDTH=8)(input i_s0,
		input [WIDTH-1:0] i_data0, i_data1,
		output reg [WIDTH-1:0] o_out);


always @(*)
begin
	case (i_s0)
		1'b0: o_out = i_data0;
		1'b1: o_out = i_data1;
	endcase
end

endmodule

