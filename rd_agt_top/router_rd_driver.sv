class router_rd_driver extends uvm_driver#(read_xtn);
//factory registration
	`uvm_component_utils(router_rd_driver)
//virtual interface 
	virtual router_if.RDR_MP vif;
//agt configuration
	router_rd_agt_config m_cfg;

//standard uvm methods
	extern function new(string name="router_rd_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(read_xtn xtn);
	extern function void report_phase(uvm_phase phase);

endclass
//constructor
function router_rd_driver::new(string name="router_rd_driver",uvm_component parent);
super.new(name,parent);
endfunction
//build phase method
function void router_rd_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(router_rd_agt_config)::get(this,"","router_rd_agt_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
endfunction
//connect phase method
function void router_rd_driver::connect_phase(uvm_phase phase);
	vif=m_cfg.vif;
endfunction

task router_rd_driver::run_phase(uvm_phase phase);
forever
begin
	seq_item_port.get_next_item(req);
	send_to_dut(req);
	seq_item_port.item_done();
end
endtask

task router_rd_driver::send_to_dut(read_xtn xtn);
`uvm_info(get_type_name(),$sformatf("printing from driver \n %s",xtn.sprint()),UVM_LOW)

	@(vif.rdr_cb);
	while(vif.rdr_cb.vld_out!==1)
	@(vif.rdr_cb);
`uvm_info(get_type_name(),"read enable not asserted",UVM_LOW)
repeat(xtn.no_of_cycles)
	@(vif.rdr_cb);

	vif.rdr_cb.read_enb<=1;
//`uvm_info(get_type_name(),"read enable is 1",UVM_LOW)

//`uvm_info(get_type_name(),$sformatf("printing from driver \n %s",xtn.sprint()),UVM_LOW)


	//@(vif.rdr_cb);
	while(vif.rdr_cb.vld_out!==0)
	@(vif.rdr_cb);
//`uvm_info(get_type_name(),"read enable is 1",UVM_LOW)

	vif.rdr_cb.read_enb<=0;
//`uvm_info(get_type_name(),"read enable is 0",UVM_LOW)

	//repeat(2)
	//@(vif.rdr_cb);
	m_cfg.drv_data_count++;

endtask

function void router_rd_driver::report_phase(uvm_phase phase);
`uvm_info(get_type_name(),$sformatf("Report:Router destination sent %d xtns",m_cfg.drv_data_count),UVM_LOW)	
endfunction


