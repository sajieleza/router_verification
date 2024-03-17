class write_xtn extends uvm_sequence_item;
//factory registration
`uvm_object_utils(write_xtn)
//properties
rand bit [7:0]header;
rand bit [7:0]payload_data[];
bit [7:0]parity;
bit error;
//bit busy;
//methods
extern function new(string name="write_xtn");
extern function void do_print(uvm_printer printer);
extern function void post_randomize();
//constraints
constraint c1{header[1:0]!=3;}
constraint c2{payload_data.size==header[7:2];}
constraint c3{header[7:2]!=0;}


endclass

//new constructor
function write_xtn::new(string name="write_xtn");
	super.new(name);
endfunction
//print method
function void write_xtn::do_print(uvm_printer printer);
	super.do_print(printer);
	printer.print_field( "header", 		this.header, 	    8,		 UVM_DEC		);
	foreach(payload_data[i])
    	printer.print_field( $sformatf("payload_data[%0d]",i), 		this.payload_data[i], 	    8,		 UVM_DEC		);
    	printer.print_field( "parity", 		this.parity, 	    8,		 UVM_DEC		);
		printer.print_field( "error", 		this.error, 	    1,		 UVM_BIN		);

	
endfunction
//post_randomize method
function void write_xtn::post_randomize();
	parity=0^header;
	foreach(payload_data[i])
		parity=payload_data[i]^parity;
endfunction

class write_xtn2 extends write_xtn;
`uvm_object_utils(write_xtn2)

extern function new(string name="write_xtn2");
extern function void post_randomize();
endclass
//new constructor
function write_xtn2::new(string name="write_xtn2");
	super.new(name);
endfunction

function void write_xtn2::post_randomize();
	parity=$urandom;
endfunction




	
