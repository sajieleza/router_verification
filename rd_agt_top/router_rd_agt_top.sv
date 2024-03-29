class router_rd_agt_top extends uvm_env;
//factory registration
	`uvm_component_utils(router_rd_agt_top)
//create agent handle
	router_rd_agent agnth[];
	router_env_config m_cfg;
//standard uvm methods	
	extern function new(string name="router_rd_agt_top",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);

endclass
//constructor new method
function router_rd_agt_top::new(string name="router_rd_agt_top",uvm_component parent);
	super.new(name,parent);
endfunction
//build phase method
function void router_rd_agt_top::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
		`uvm_fatal(get_type_name(),"Env:read error")
	agnth=new[m_cfg.no_of_read_agent];

	foreach(agnth[i])
		begin
			agnth[i]=router_rd_agent::type_id::create($sformatf("agnth[%0d]",i),this);
			uvm_config_db #(router_rd_agt_config)::set(this,$sformatf("agnth[%0d]*",i),"router_rd_agt_config",m_cfg.rd_agt_cfg[i]);
		end
	
endfunction


//-----------------  run() phase method  -------------------//
// Print the topology
task router_rd_agt_top::run_phase(uvm_phase phase);
	//uvm_top.print_topology;
endtask   


