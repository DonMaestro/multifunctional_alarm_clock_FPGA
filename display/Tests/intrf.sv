interface display_bus #(SIZE=4, WIDTH_MEM_MAX=4) (input bit clk);
	logic rst_n;
	logic COMMAND;
	logic [(SIZE<<3)-1:0] ASCII;
	logic [7:0] DATA;
	logic [WIDTH_MEM_MAX-1:0] ADDR;
	logic E, RS, RW;
	modport display (
			input clk, rst_n,
			input COMMAND, ASCII,
			output DATA, E, RS, RW,
			output ADDR);
	modport tb (
			input clk,
			input ADDR,
			input DATA, E, RS, RW,
			output rst_n,
			output COMMAND, ASCII);
endinterface


