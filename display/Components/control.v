
module control #(parameter SIZE_COUNT=16, CLOCK=2614, WIDTH_MEM=4) (input i_clk, i_rst_n,
		input [10:0] i_command,
		input [WIDTH_MEM-1:0] i_addr_begin,
		input [WIDTH_MEM-1:0] i_addr_end,
		output [WIDTH_MEM-1:0] o_addr,
		output o_overflow,
		output o_E);

localparam CLEAR_DISPLAY = 11'b00000000001;
localparam RETURN_HOME = 11'b00000000010;

localparam WAIT_TACT = $clog2(CLOCK * 0.00153);

reg [(WAIT_TACT)-1:0] counter;
supply1 [(WAIT_TACT)-1:0] set_counter;

wire [10:0] command;


wire equal;
wire enable, en_E;


register #(.WIDTH(11)) m_reg_command(.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		.i_en(enable),
		.i_D(i_command),
		.o_Q(command));


assign en_counter = command == (CLEAR_DISPLAY || RETURN_HOME);

always @(posedge i_clk, negedge i_rst_n)
begin
	if (!i_rst_n)
		counter <= 0;
	else
	begin
		if (en_counter)
			counter <= counter + 1'b1;
	end
end


assign equal = counter == set_counter;


mux2in1 #(1) m_mux2in1 (.i_s0(en_counter),
		.i_data0(1'b1),
		.i_data1(equal),
		.o_out(enable));


address #(.WIDTH(WIDTH_MEM), .RST_ADDR_END(5)) m_address(.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		.i_en(enable),
		.i_addr_begin(i_addr_begin),
		.i_addr_end(i_addr_end),
		.o_overflow(o_overflow),
		.o_addr(o_addr));




register_n #(1) m_reger_n(.i_clk(i_clk),
		.i_rst_n(i_rst_n),
		.i_D(enable),
		.o_Q(en_E));

assign o_E = en_E & i_clk;



endmodule
