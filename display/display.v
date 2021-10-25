//
//	SIZE is number DATA
//	DATA[0] == command
//	CLOCK is input clock
//
//	OUTPUT
//	[---08---][09][10][11]
//	DATA[7:0], RW, RS, E
//	SIZE multiple 4
//
//	interfase --> reg --> combination logic --> reg --> output
//	CLK = 25KHz


module display #(parameter SIZE=4, WIDTH_MEM_MAX=4, CLOCK=2614) (input i_clk, i_rst_n,
		input [10:0] i_command,
		input [((SIZE-1)<<3)-1:0] i_data,
		input [WIDTH_MEM_MAX-1:0] i_addr_begin, i_addr_end,
		output o_overflow,
		output [WIDTH_MEM_MAX-1:0] o_addr,
		output [7:0] o_data,
		output o_E, o_RS, o_RW);



genvar i;

wire [7:0] byte [1:SIZE-1];
reg [SIZE-1:0] en;

wire	[10:0]	command;
wire	[7:0]	data [0:SIZE-1];
wire	[7:0]	o_mux [0:(SIZE>>2)];
wire	[7:0]	mux;

wire enable;

wire	[SIZE-1:0] o_decoder;



control #(.WIDTH_MEM(WIDTH_MEM_MAX), .CLOCK(CLOCK)) m_control (.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		.i_command(i_command),
		.i_addr_begin(4'd6),
		.i_addr_end(4'd9),
		.o_addr(o_addr),
		.o_enable(enable),
		.o_overflow(o_overflow),
		.o_E(o_E));



//
// decode i_data
//

///*
generate
	for(i = 0; i < SIZE-1; i = i+1)
	begin
		assign byte[i+1] = i_data[i*8+7:i*8];
	end
endgenerate
//*/



/*
 * create input registers
 *
 */

// create register command
register #(11) m_reg_comm(.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		.i_en(enable),
		.i_D(i_command),
		.o_Q(command));

// resgister data
generate
	for(i = 1; i < SIZE; i = i+1)
	begin
		register m_reg_data(.i_clk(i_clk),
				.i_rst_n(i_rst_n),
				.i_en(enable),
				.i_D(byte[i]),
				.o_Q(data[i]));
	end
endgenerate


/*
 * Block combinating logic
 */



decoder #(.WIDTH(SIZE)) m_decoder(.i_A(command[SIZE>>2:0]),
		.o_P(o_decoder));


/*
*
* formation of en
*
*/
integer j;
always @(*)
begin
	en[0] = ~command[10];
	for(j = 1; j < SIZE; j = j+1)
	begin
		en[j] = command[10] && o_decoder[j-1];
	end
end



//
// create multiplaxer
//

mux4in1 mux0 (.i_en(en),
		.i_D0(command[7:0]),
		.i_D1(data[1]),
		.i_D2(data[2]),
		.i_D3(data[3]),
		.o_Q(o_mux[0]));

generate
	assign mux = o_mux[0];
	for(i=1; i < (SIZE >> 2); i = i+1)
	begin
		mux4in1 m_mux (.i_en(en),
				.i_D0(data[0+i*4]),
				.i_D1(data[1+i*4]),
				.i_D2(data[2+i*4]),
				.i_D3(data[3+i*4]),
				.o_Q(o_mux[i]));

		assign mux = mux | o_mux[i];
	end
endgenerate




/*
 * formation of the output signal
 *
 */

register m_reg_o_data(.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		.i_en(1'b1),
		.i_D(mux),
		.o_Q(o_data));

register #(1) m_reg_o_rw(.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		.i_en(1'b1),
		.i_D(command[8]),
		.o_Q(o_RW));

register #(1) m_reg_o_rs(.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		.i_en(1'b1),
		.i_D(command[9]),
		.o_Q(o_RS));

endmodule
