`include "Tests/intrf.sv";
//enum OUT_STATE { OUT_EOK, OUT_EER };

class DisplayTest #(parameter SIZE=4);

localparam WIDTH_ASCII=$clog2(SIZE * 8);

virtual display_bus db;

static logic [10:0] buf_command [$];
static logic [WIDTH_ASCII-1:0] buf_ASCII [$];

function new(virtual display_bus.tb db);
	db.rst_n = 0;	
	db.COMMAND = 0;
	db.ASCII = 0;
	this.db = db;
endfunction

task reset;
	db.rst_n = 0;
	#40 db.rst_n = 1;
endtask

task test_port(input int number);
	reset();

	fork
		set_input(db, number);
		check_out(db, number);
	join
	
	$monitor("END\n");
endtask

task set_input(virtual display_bus db, input int number);
	repeat (number) @(db.ADDR)
	begin
		db.COMMAND = rand_option_port();
		buf_command.push_back(db.COMMAND);

		db.ASCII = $random();
		buf_ASCII.push_back(db.ASCII);
	end
endtask

function logic [10:0] rand_command;
	rand_command = $random;
	rand_command[9] = 1'b1;
endfunction



// output check

function byte find_ascii(input logic [WIDTH_ASCII-1:0] ASCII,
		input logic [9:0] number);
	bit [7:0] ascii [WIDTH_ASCII-1:0] = ASCII;
	find_ascii = ascii[number];
endfunction


task check_out(virtual display_bus db, input int number);
	//logic [$clog(SIZE)-1:0] old_ascii;
	logic [WIDTH_ASCII-1:0] old_ascii;
	logic [10:0] old_command;
	logic [9:0] out;
	byte old_data, data;

	int info_out;

	repeat (number) @(posedge db.E)
	begin
		old_command = buf_command.pop_front();
		old_ascii = buf_ASCII.pop_front();

		out = {db.RS, db.RW, db.DATA};
		old_data = find_ascii(old_ascii, old_command[9:0]);

		if (old_command[10])
			info_out = check_ascii(old_data, db.DATA);
		else
			info_out = check_command(old_command[9:0], out);
        
		if (old_command[8] != db.RW)
			$monitor("ERROR: RW");
        
		if (old_command[9] != db.RS)
			$monitor("ERROR: RS");
	end
endtask



function int check_ascii(input byte OLD_DATA, DATA);

	check_ascii = 1;

	if (OLD_DATA == DATA)
		check_ascii = 0;

endfunction

function int check_command(input logic [9:0] OLD_COMMAND, COMMAND);

	check_command = 1;

	if (OLD_COMMAND == COMMAND)
		check_command = 0;

endfunction

endclass
