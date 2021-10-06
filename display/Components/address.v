

module address #(parameter WIDTH=4, RST_ADDR_END=5)(input i_clk, i_rst_n, i_en,
		input [WIDTH-1:0] i_addr_begin, i_addr_end,
		output [WIDTH-1:0] o_addr,
		output o_overflow);


wire [WIDTH-1:0] addr_begin, addr_end;

wire [WIDTH-1:0] adder;
wire [WIDTH-1:0] counter;


wire [WIDTH-1:0] mux;
wire new_addr;

/*
 * input registers
 *
 */

register #(WIDTH) m_reg_addr_begin(.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		.i_en(o_overflow & i_en),
		.i_D(i_addr_begin),
		.o_Q(addr_begin));


register #(.WIDTH(WIDTH), .RST_DATA(RST_ADDR_END)) m_reg_addr_end(.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		.i_en(o_overflow & i_en),
		.i_D(i_addr_end),
		.o_Q(addr_end));


//counter 
assign adder = mux + 1'b1;


register #(WIDTH) m_reg_counter(.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		.i_en(i_en),
		.i_D(adder),
		.o_Q(counter));


mux2in1 #(WIDTH) m_mux2in1(.i_s0(new_addr),
		.i_data0(counter),
		.i_data1(addr_begin),
		.o_out(mux));


assign overflow = mux == addr_end;


register #(1) m_reg_mux_s0(.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		.i_en(i_en),
		.i_D(overflow),
		.o_Q(new_addr));

//
// formation of output
//

assign o_overflow = overflow;

register #(WIDTH) m_reg_o_addr(.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		.i_en(i_en),
		.i_D(mux),
		.o_Q(o_addr));


endmodule
