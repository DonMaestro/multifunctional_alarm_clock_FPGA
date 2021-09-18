module mux4in1 #(parameter WIDHT=8) (input wire [3:0] i_en,
		input wire [WIDHT-1:0] i_D0,
		input wire [WIDHT-1:0] i_D1,
		input wire [WIDHT-1:0] i_D2,
		input wire [WIDHT-1:0] i_D3,
		output reg [WIDHT-1:0] o_Q);



always @(*)
begin

	case(1) 
		i_en[0]: o_Q <= i_D0;
		i_en[1]: o_Q <= i_D1;
		i_en[2]: o_Q <= i_D2;
		i_en[3]: o_Q <= i_D3;
	endcase

end


endmodule
