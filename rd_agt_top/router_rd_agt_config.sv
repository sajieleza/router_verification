class router_rd_agt_config extends uvm_object;
//factory registration
`uvm_object_utils(router_rd_agt_config)
//declare virtual interface handle
	virtual router_if vif;
	static int drv_data_count=0;
	static int mon_data_count=0;
//set uvm_active
	uvm_active_passive_enum is_active=UVM_ACTIVE;

	// Standard UVM Methods:
	extern function new(string name = "router_rd_agt_config");

endclass

function router_rd_agt_config::new(string name = "router_rd_agt_config");
  super.new(name);
endfunction
