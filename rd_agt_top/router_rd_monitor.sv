class router_rd_monitor extends uvm_monitor;
//factory registration
	`uvm_component_utils(router_rd_monitor)
//virtual interface 
	virtual router_if.RMON_MP vif;
//agt configuration
	router_rd_agt_config m_cfg;
//analysis port to connect monitor to scoreboard
	uvm_analysis_port #(read_xtn) monitor_port;

//standard uvm methods
	extern function new(string name="router_rd_monitor",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	extern function void report_phase(uvm_phase phase);

endclass
//constructor
function router_rd_monitor::new(string name="router_rd_monitor",uvm_component parent);
	super.new(name,parent);
	monitor_port=new("monitor_port",this);
endfunction
//build phase method
function void router_rd_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(router_rd_agt_config)::get(this,"","router_rd_agt_config",m_cfg))
		`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
endfunction
//connect phase method
function void router_rd_monitor::connect_phase(uvm_phase phase);
	vif=m_cfg.vif;
endfunction


task router_rd_monitor::run_phase(uvm_phase phase);
forever
begin
	
	collect_data();
end
endtask

task router_rd_monitor::collect_data();	
	read_xtn xtn1;
	xtn1=read_xtn::type_id::create("xtn1");

	@(vif.rmon_cb);
	@(vif.rmon_cb);

	while(vif.rmon_cb.read_enb!==1)
	@(vif.rmon_cb);
	@(vif.rmon_cb);
	xtn1.header=vif.rmon_cb.data_out;
//`uvm_info(get_type_name(),$sformatf("printing from monitor \n %s",xtn1.sprint()),UVM_LOW)


	xtn1.payload_data=new[xtn1.header[7:2]];
@(vif.rmon_cb);


	foreach(xtn1.payload_data[i])
	begin

	xtn1.payload_data[i]=vif.rmon_cb.data_out;
@(vif.rmon_cb);
//`uvm_info(get_type_name(),$sformatf("printing from monitor \n %s",xtn1.sprint()),UVM_LOW)



		end
	
	xtn1.parity=vif.rmon_cb.data_out;
	@(vif.rmon_cb);

	monitor_port.write(xtn1);
//$display("send xtn to sb");
	m_cfg.mon_data_count++;
`uvm_info(get_type_name(),$sformatf("printing from monitor \n %s",xtn1.sprint()),UVM_LOW)

endtask

function void router_rd_monitor::report_phase(uvm_phase phase);
`uvm_info(get_type_name(),$sformatf("Report:Router destination received %d xtns",m_cfg.mon_data_count),UVM_LOW)	
endfunction


