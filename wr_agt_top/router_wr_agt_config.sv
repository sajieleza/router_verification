class router_wr_agt_config extends uvm_object;
// UVM Factory Registration Macro
	`uvm_object_utils(router_wr_agt_config)


	//------------------------------------------
	// Data Members
	//------------------------------------------
	// Declare parameter is_active of type uvm_active_passive_enum and assign it to UVM_ACTIVE
	uvm_active_passive_enum is_active = UVM_ACTIVE;

	// Declare the virtual interface handle for ram_if as "vif"
	virtual router_if vif;
	
	// Declare the mon_rcvd_xtn_cnt as static int and initialize it to zero  
	static int mon_rcvd_xtn_cnt = 0;

	// Declare the drv_data_sent_cnt as static int and initialize it to zero 
	static int drv_data_sent_cnt = 0;

	//------------------------------------------
	// Methods
	//------------------------------------------
	// Standard UVM Methods:
	extern function new(string name = "router_wr_agt_config");

endclass
//-----------------  constructor new method  -------------------//

function router_wr_agt_config::new(string name = "router_wr_agt_config");
  super.new(name);
endfunction

