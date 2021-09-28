
module rom #(parameter WIDTHADDR=2, WIDTHDATA=8) (input i_clk,
		input [WIDTHADDR-1:0] i_addr,
		output [WIDTHDATA-1:0] o_data);

reg [WIDTHDATA-1:0] memory[0:(1<<WIDTHADDR)-1];

initial $readmemb("rom.dat", memory);


assign o_data = memory[i_addr];


endmodule
