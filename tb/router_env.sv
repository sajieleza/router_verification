class router_env extends uvm_env;
//factory registration
	`uvm_component_utils(router_env)
// Declare handles for ram_wr_agt_top, ram_rd_agt_top 
//and ram_virtual_sequencer as wagt_top,ragt_top and v_sequencer respectively
	router_wr_agt_top wagt_top;
	router_rd_agt_top ragt_top;
	router_virtual_sequencer v_sequencer;
//scoreboard handle
	router_scoreboard sb;
	// Declare handle for ram_env_config as m_cfg
   	router_env_config m_cfg;
	//------------------------------------------
	// Methods
	//------------------------------------------

	// Standard UVM Methods:
	extern function new(string name = "router_env", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);

endclass

	
//-----------------  constructor new method  -------------------//
// Define Constructor new() function
function router_env::new(string name = "router_env", uvm_component parent);
	super.new(name,parent);
endfunction

//build phase method
function void router_env::build_phase(uvm_phase phase);
	super.build_phase(phase);
	  //get configuration object ram_env_config from database using uvm_config_db() 
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
	//set the ram_wr_agent_config into the database
	//if config parameter has_wagent=1
	//set m_cfg.m_wr_cfg as the string ram_wr_agent_config using uvm_config_db
    	if(m_cfg.has_wagent) 
		begin
            			//create instance for ram_wr_agt_top
	        wagt_top=router_wr_agt_top::type_id::create("wagt_top",this);
        end
		
	//set the ram_rd_agent_config into the database
	//if config parameter has_ragent=1
	//set m_cfg.m_rd_cfg as the string ram_rd_agent_config using uvm_config_db
    if(m_cfg.has_ragent) 
		begin
            			//create instance for ram_rd_agt_top
	        ragt_top=router_rd_agt_top::type_id::create("ragt_top",this);
        end
    	
    if(m_cfg.has_virtual_sequencer)
		// Create the instance of v_sequencer handle 
	begin
	    v_sequencer=router_virtual_sequencer::type_id::create("v_sequencer",this);
	end
	if(m_cfg.has_scoreboard)
		begin
		sb=router_scoreboard::type_id::create("sb",this);
		end
endfunction
//connect phase method
function void router_env::connect_phase(uvm_phase phase);
	if(m_cfg.has_virtual_sequencer)
	begin
		if(m_cfg.has_wagent)
			begin
				for(int i=0;i<m_cfg.no_of_write_agent;i++)
				begin
				v_sequencer.wr_seqrh[i]=wagt_top.agnth[i].m_sequencer;
				end
			end
		if(m_cfg.has_ragent)
			begin
				for(int i=0;i<m_cfg.no_of_read_agent;i++)
				begin
				v_sequencer.rd_seqrh[i]=ragt_top.agnth[i].seqrh;
				end
			end

	end
	if(m_cfg.has_scoreboard)
	begin
		if(m_cfg.has_wagent)
			begin
				foreach(m_cfg.wr_agt_cfg[i])
				begin
				wagt_top.agnth[i].monh.monitor_port.connect(sb.fifo_wrh.analysis_export);
				end
			end
		if(m_cfg.has_ragent)
			begin
				foreach(m_cfg.rd_agt_cfg[i])
				begin
				ragt_top.agnth[i].monh.monitor_port.connect(sb.fifo_rdh[i].analysis_export);
				end
			end

	end

		
endfunction

