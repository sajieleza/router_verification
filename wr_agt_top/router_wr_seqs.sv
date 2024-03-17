//............router write seq.............
class router_wr_seq extends uvm_sequence#(write_xtn);
//factory registration
	`uvm_object_utils(router_wr_seq)
//standard methods
	extern function new(string name="router_wr_seq");
endclass
//new constructor
function router_wr_seq::new(string name="router_wr_seq");
	super.new(name);
endfunction

//......................................small pkt................
class router_wxtns_small_pkt extends router_wr_seq;
//factory registration
`uvm_object_utils(router_wxtns_small_pkt)
bit[1:0]addr;
//standard methods
extern function new(string name="router_wxtns_small_pkt");
extern task body();
endclass
//new constructor
function router_wxtns_small_pkt::new(string name="router_wxtns_small_pkt");
	super.new(name);
endfunction
//task body
task router_wxtns_small_pkt::body();
//repeat(20) begin
	if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
		`uvm_fatal(get_type_name(),"getting the configuration failed,check if it is set properly")
	req=write_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {header[7:2] inside {[1:15]} && header[1:0] == addr;});
	`uvm_info("router_wr_sequence",$sformatf("Printing from sequence \n %s",req.sprint()),UVM_HIGH)
	finish_item(req);
`uvm_info(get_type_name(),"Small packet end",UVM_LOW)
//end	
endtask
//......................................medium pkt................
class router_wxtns_medium_pkt extends router_wr_seq;
//factory registration
`uvm_object_utils(router_wxtns_medium_pkt)
bit[1:0]addr;
//standard methods
extern function new(string name="router_wxtns_medium_pkt");
extern task body();
endclass
//new constructor
function router_wxtns_medium_pkt::new(string name="router_wxtns_medium_pkt");
	super.new(name);
endfunction
//task body
task router_wxtns_medium_pkt::body();
	if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
		`uvm_fatal(get_type_name(),"getting the configuration failed,check if it is set properly")
	req=write_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {header[7:2] inside {[16:30]} && header[1:0] ==addr; });
	`uvm_info("router_wr_sequence",$sformatf("Printing from sequence \n %s",req.sprint()),UVM_HIGH)
	finish_item(req);
	
endtask
//......................................big pkt................
class router_wxtns_big_pkt extends router_wr_seq;
//factory registration
`uvm_object_utils(router_wxtns_big_pkt)
bit[1:0]addr;
//standard methods
extern function new(string name="router_wxtns_big_pkt");
extern task body();
endclass
//new constructor
function router_wxtns_big_pkt::new(string name="router_wxtns_big_pkt");
	super.new(name);
endfunction
//task body
task router_wxtns_big_pkt::body();
	if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
		`uvm_fatal(get_type_name(),"getting the configuration failed,check if it is set properly")
	req=write_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {header[7:2] inside {[31:63]} && header[1:0] ==addr; });
	`uvm_info("router_wr_sequence",$sformatf("Printing from sequence \n %s",req.sprint()),UVM_HIGH)
	finish_item(req);
	
endtask
//......................................small pkt................
class router_wxtns_rndm_pkt extends router_wr_seq;
//factory registration
`uvm_object_utils(router_wxtns_rndm_pkt)
bit[1:0]addr;
//standard methods
extern function new(string name="router_wxtns_rndm_pkt");

extern task body();
endclass
//new constructor
function router_wxtns_rndm_pkt::new(string name="router_wxtns_rndm_pkt");
	super.new(name);
endfunction
//task body
task router_wxtns_rndm_pkt::body();
	if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
		`uvm_fatal(get_type_name(),"getting the configuration failed,check if it is set properly")
	req=write_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {header[1:0] ==addr; });
	`uvm_info("router_wr_sequence",$sformatf("Printing from sequence \n %s",req.sprint()),UVM_HIGH)
	finish_item(req);
	
endtask

class router_error_pkt extends uvm_sequence#(write_xtn2);
//factory registration
	`uvm_object_utils(router_error_pkt)
bit[1:0]addr;
//standard methods
	extern function new(string name="router_error_pkt");
	extern task body();
endclass
//new constructor
function router_error_pkt::new(string name="router_error_pkt");
	super.new(name);
endfunction
//task body
task router_error_pkt::body();
	if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
		`uvm_fatal(get_type_name(),"getting the configuration failed,check if it is set properly")
	req=write_xtn2::type_id::create("req");
	start_item(req);
	assert(req.randomize() with {header[1:0] ==addr; });
	`uvm_info("router_wr_sequence",$sformatf("Printing from sequence \n %s",req.sprint()),UVM_HIGH)
	finish_item(req);
	
endtask





	
