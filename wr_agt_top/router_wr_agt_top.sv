class router_wr_agt_top extends uvm_env;
 // Factory Registration
	`uvm_component_utils(router_wr_agt_top)
    
   //Declare the agent handle
    router_wr_agent agnth[];
	router_env_config e_cfg;
	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
	extern function new(string name = "router_wr_agt_top" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	
endclass
//-----------------  constructor new method  -------------------//
// Define Constructor new() function
function router_wr_agt_top::new(string name = "router_wr_agt_top" , uvm_component parent);
	super.new(name,parent);
endfunction

    
//-----------------  build() phase method  -------------------//
function void router_wr_agt_top::build_phase(uvm_phase phase);
    super.build_phase(phase);
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",e_cfg))
		`uvm_fatal(get_type_name(),"Env:write error")

	// Create the instance of ram_wr_agent
	agnth=new[e_cfg.no_of_write_agent];

	foreach(agnth[i])
		begin
			agnth[i]=router_wr_agent::type_id::create($sformatf("agnth[%0d]",i),this);
			uvm_config_db #(router_wr_agt_config)::set(this,$sformatf("agnth[%0d]*",i),"router_wr_agt_config",e_cfg.wr_agt_cfg[i]);
		end

  endfunction


//-----------------  run() phase method  -------------------//
// Print the topology
task router_wr_agt_top::run_phase(uvm_phase phase);
`uvm_info(get_full_name(),"in agt top",UVM_LOW)
endtask   


