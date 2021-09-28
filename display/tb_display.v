`timescale 1 ns / 10 ps

module tb_display;

parameter SIZE=4;

reg clk, rst_n;

reg [7:0] data [0:SIZE-1];
reg [(SIZE<<3)-1:0] data_all;

wire [3:0] addr_mem;
wire [10:0] command;


wire E;

integer i;
always @(*)
begin
	data_all = {data[3], data[2], data[1], data[0]};
	for(i = 0; i < SIZE; i = i+1)
	begin
		//data_all[(8*i)+7:8*i] = data[i];
	end
end


rom #(.WIDTHADDR(4), .WIDTHDATA(11)) m_rom(.i_clk(clk),
		.i_addr(addr_mem),
		.o_data(command));


display #(.SIZE(SIZE)) m_display(.i_clk(clk),
		.i_rst_n(rst_n),
		.i_comm(command),
		.i_data(data_all),
		.o_addr(addr_mem),
		.o_E(E));



initial
begin
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
	#1000 $finish;
end


endmodule
