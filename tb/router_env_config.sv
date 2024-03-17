class router_env_config extends uvm_object;
//factory registration
	`uvm_object_utils(router_env_config)
// Whether env analysis components are used:
	//bit has_functional_coverage = 0;
	//bit has_wagent_functional_coverage = 0;
	// Whether the various agents are used:
	
	bit has_wagent = 1;
	bit has_ragent = 1;
	int no_of_write_agent=1;
	int no_of_read_agent=3;
	// Whether the virtual sequencer is used:
	bit has_virtual_sequencer = 1;
	bit has_scoreboard = 1;

	// Configuration handles for the sub_components
	router_wr_agt_config wr_agt_cfg[];
	router_rd_agt_config rd_agt_cfg[];




	//------------------------------------------
	// Methods
	//------------------------------------------
	// Standard UVM Methods:
	extern function new(string name = "router_env_config");

endclass
//-----------------  constructor new method  -------------------//

function router_env_config::new(string name = "router_env_config");
  super.new(name);
endfunction


	



