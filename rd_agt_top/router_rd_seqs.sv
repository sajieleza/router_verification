//router read seq
class router_rd_seq extends uvm_sequence#(read_xtn);
//factory registration
	`uvm_object_utils(router_rd_seq)
//standard function
	extern function new(string name="router_rd_seq");
endclass
//function new
function router_rd_seq::new(string name="router_rd_seq");
	super.new(name);
endfunction
//...............rxtns1...............
class router_rxtns1 extends router_rd_seq;
//factory registration
	`uvm_object_utils(router_rxtns1)
//standard methods
	extern function new(string name="router_rxtns1");
	extern task body();
endclass
//function new
function router_rxtns1::new(string name="router_rxtns1");
	super.new(name);
endfunction
//task body
task router_rxtns1::body();
	req=read_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {no_of_cycles inside{[1:28]}; });
	//`uvm_info("router_rd_sequence",$sformatf("Printing from sequence \n %s",req.sprint()),UVM_LOW)
	finish_item(req);
	`uvm_info(get_type_name(),"AFTER FINISH ITEM INSIDE SEQUENCE",UVM_HIGH)

endtask
//...............rxtns2...............
class router_rxtns2 extends router_rd_seq;
//factory registration
	`uvm_object_utils(router_rxtns2)
//standard methods
	extern function new(string name="router_rxtns2");
	extern task body();
endclass
//function new
function router_rxtns2::new(string name="router_rxtns2");
	super.new(name);
endfunction
//task body
task router_rxtns2::body();
	req=read_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {no_of_cycles inside {[29:32]}; });
	//`uvm_info("router_rd_sequence",$sformatf("Printing from sequence \n %s",req.sprint()),UVM_LOW)
	finish_item(req);
	`uvm_info(get_type_name(),"AFTER FINISH ITEM INSIDE SEQUENCE",UVM_HIGH)

endtask


