`timescale 1 us / 100 ns

module tb_display;

parameter SIZE=4, WIDTHADDR=4, CLOCK=25000;

reg clk, rst_n;

reg [7:0] data [0:SIZE-1];
reg [((SIZE-1)<<3)-1:0] data_all;

wire [3:0] addr_mem;
wire [10:0] command;


wire E, RW, RS;
wire [7:0] DATA;

always @(*)
begin
	data_all = {data[2], data[1], data[0]};
end


rom #(.WIDTHADDR(WIDTHADDR), .WIDTHDATA(11)) m_rom(.i_clk(clk),
		.i_addr(addr_mem),
		.o_data(command));


display #(.SIZE(SIZE), .WIDTH_MEM_MAX(WIDTHADDR), .CLOCK(CLOCK)) m_display(.i_clk(clk),
		.i_rst_n(rst_n),
		.i_command(command),
		.i_data(data_all),
		.i_addr_begin(4'd6),
		.i_addr_end(4'd9),
		.o_addr(addr_mem),
		.o_data(DATA),
		.o_E(E),
		.o_RS(RS),
		.o_RW(RW));



initial
begin
	data[2] = 8'b0;
	data[3] = 8'b0;
	data[0] = 8'hff;
	data[1] = 8'h0f;
	#60
	data[0] = 8'h00;
	data[1] = 8'hf0;
end


initial
begin
	#0 rst_n = 0;
	#1 rst_n = 1;
end


initial 
begin
	clk = 0;
	forever #20 clk = ~clk;
end

initial 
begin
	$dumpfile("Debug/display.vcd");
	$dumpvars;
	#10000 $finish;
end


endmodule
