`timescale 1 us / 10 ns
`include "Tests/base.sv";

module tb_display;

DisplayTest dt;
bit clk;

display_bus intrf_dis(clk);

//tesing_block m_tb(intf_dis.tb);

display m_display(.i_clk(clk),
		.i_rst_n(intrf_dis.display.rst_n),
		.i_comm(intrf_dis.display.COMMAND),
		.i_data(intrf_dis.display.ASCII),
		.o_addr(intrf_dis.display.ADDR),
		.o_E(intrf_dis.display.E),
		.o_RS(intrf_dis.display.RS),
		.o_RW(intrf_dis.display.RW));

initial
begin
	dt = new(intrf_dis.tb);
	reset();
	test_port(15);
end

initial
begin
	clk = 0;
	forever #20 clk = ~clk;
end

initial
begin
	$dumpfile("display.vcd");
	$dumpvars;
	#10000 $finish;
end


endmodule
