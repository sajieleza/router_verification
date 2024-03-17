class router_wr_sequencer extends uvm_sequencer#(write_xtn);
// Factory registration using `uvm_component_utils
	`uvm_component_utils(router_wr_sequencer)

	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
	extern function new(string name = "router_wr_sequencer",uvm_component parent);
	extern task run_phase(uvm_phase phase);
endclass

//-----------------  constructor new method  -------------------//
function router_wr_sequencer::new(string name="router_wr_sequencer",uvm_component parent);
	super.new(name,parent);
endfunction
task router_wr_sequencer::run_phase(uvm_phase phase);
	`uvm_info(get_type_name(),"router write sequencer", UVM_LOW)

endtask

