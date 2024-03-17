class router_rd_agent extends uvm_agent;
//factory registration
	`uvm_component_utils(router_rd_agent)
//declare handles of configuration object
	router_rd_agt_config m_cfg;
//declare handles of router_rd_monitor,router_rd_driver,router_rd_sequencer
	router_rd_monitor monh;
	router_rd_driver drvh;
	router_rd_sequencer seqrh;
//standard uvm methods:
	extern function new(string name="router_rd_agent",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass
//constructor new method
function router_rd_agent::new(string name="router_rd_agent",uvm_component parent);
	super.new(name,parent);
endfunction
//build phase method
function void router_rd_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(router_rd_agt_config)::get(this,"","router_rd_agt_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it")
	monh=router_rd_monitor::type_id::create("monh",this);
	if(m_cfg.is_active==UVM_ACTIVE)
		begin
			drvh=router_rd_driver::type_id::create("drvh",this);
			seqrh=router_rd_sequencer::type_id::create("seqrh",this);
		end	
endfunction
//connect phase method
function void router_rd_agent::connect_phase(uvm_phase phase);
	if(m_cfg.is_active==UVM_ACTIVE)
		begin
			drvh.seq_item_port.connect(seqrh.seq_item_export);
		end
endfunction

