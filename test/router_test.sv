class router_base_test extends uvm_test;
//factory registration
	`uvm_component_utils(router_base_test)

    // Declare the handles router_env, router_env_config, router_wr_agent_config and
    // router_rd_agent_config as r_envh, m_tb_cfg, m_wr_cfg & m_rd_cfg       	
   	router_env env;
	router_env_config e_cfg;
	router_wr_agt_config wcfg[];
	router_rd_agt_config rcfg[];
 
    // Declare has_ragent=1 & has_wagent=1 as int
    	bit has_ragent = 1;
    	bit has_wagent = 1;
	int no_of_read_agent=3;
	int no_of_write_agent=1;


	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
	extern function new(string name = "router_base_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
    	extern function void config_router();
	extern function void end_of_elaboration_phase(uvm_phase phase);

 endclass
//-----------------  constructor new method  -------------------//
// Define Constructor new() function
function router_base_test::new(string name = "router_base_test" , uvm_component parent);
	super.new(name,parent);
endfunction

//build phase method
function void router_base_test::build_phase(uvm_phase phase);
	e_cfg=router_env_config::type_id::create("e_cfg");
	 if(has_wagent)
		// Create the instance for  ram_wr_agent_config 
		begin
       		e_cfg.wr_agt_cfg=new[no_of_write_agent];
		end

    	if(has_ragent)
		// Create the instance for  ram_rd_agent_config
		begin
		e_cfg.rd_agt_cfg=new[no_of_read_agent];
		end
	//call function config_ram()
    	config_router();
 
	super.build_phase(phase);
	uvm_config_db #(router_env_config)::set(this,"*","router_env_config",e_cfg);
	// create the instance for router_env
	env=router_env::type_id::create("env", this);
	endfunction

function void router_base_test::config_router();
    if (has_wagent)
		begin 
			wcfg=new[no_of_write_agent];
			foreach(wcfg[i])
				begin
				wcfg[i]=router_wr_agt_config::type_id::create($sformatf("wagt[%0d]",i));
				if(!uvm_config_db #(virtual router_if)::get(this,"","vif",wcfg[i].vif))
				`uvm_fatal("VIF CONFIG-WRITE","cannot get() interface vif from uvm_config_db. Have you set() it?")
				wcfg[i].is_active=UVM_ACTIVE;
				e_cfg.wr_agt_cfg[i]=wcfg[i];
				end
		end

    if(has_ragent) 
		begin
				rcfg=new[no_of_read_agent];
			foreach(rcfg[i])
				begin
				rcfg[i]=router_rd_agt_config::type_id::create($sformatf("ragt[%0d]",i));
				if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("vif_%0d",i),rcfg[i].vif))
				`uvm_fatal("VIF CONFIG-WRITE","cannot get() interface vif from uvm_config_db. Have you set() it?")
				rcfg[i].is_active=UVM_ACTIVE;
				e_cfg.rd_agt_cfg[i]=rcfg[i];
				end
        	end
		// setting the env parameters
        	e_cfg.has_ragent=has_ragent;
		e_cfg.has_wagent=has_wagent;
		e_cfg.no_of_read_agent=no_of_read_agent;
		e_cfg.no_of_write_agent=no_of_write_agent;

endfunction
function void router_base_test::end_of_elaboration_phase(uvm_phase phase);
	uvm_top.print_topology();
endfunction


// Extend ram_single_addr_test from ram_base_test;
class small_test extends router_base_test;

  
   // Factory Registration
	`uvm_component_utils(small_test)

	// Declare the handle for  ram_single_vseq virtual sequence
    	router_small_vseq s_seqh;
	bit [1:0]addr;
	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
 	extern function new(string name = "small_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	
endclass

//-----------------  constructor new method  -------------------//

 // Define Constructor new() function
function small_test::new(string name = "small_test" , uvm_component parent);
	super.new(name,parent);
endfunction


//-----------------  build() phase method  -------------------//
            
function void small_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction

//function void small_test::end_of_elaboration_phase(uvm_phase phase);
//	uvm_top.print_topology();
//endfunction

task small_test::run_phase(uvm_phase phase);
 //raise objection
repeat(5)
begin

addr={$random}%3;
uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);
phase.raise_objection(this);
         
 //create instance for sequence
          s_seqh=router_small_vseq::type_id::create("s_seqh");
 //start the sequence wrt virtual sequencer
          s_seqh.start(env.v_sequencer);
         phase.drop_objection(this);
end

endtask

class medium_test extends router_base_test;

  
   // Factory Registration
	`uvm_component_utils(medium_test)

	// Declare the handle for  ram_single_vseq virtual sequence
    	router_medium_vseq m_seqh;
	bit [1:0]addr;
	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
 	extern function new(string name = "medium_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	//extern function void end_of_elaboration_phase(uvm_phase phase);

endclass

//-----------------  constructor new method  -------------------//

 // Define Constructor new() function
function medium_test::new(string name = "medium_test" , uvm_component parent);
	super.new(name,parent);
endfunction


//-----------------  build() phase method  -------------------//
            
function void medium_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction


task medium_test::run_phase(uvm_phase phase);
//raise objection
         phase.raise_objection(this);
 //create instance for sequence

repeat(20)
begin

addr={$random}%3;
uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);

          m_seqh=router_medium_vseq::type_id::create("m_seqh");
 //start the sequence wrt virtual sequencer
          m_seqh.start(env.v_sequencer);
//`uvm_info(get_type_name(),"in test run phase",UVM_LOW)
 end

 //drop objection
         phase.drop_objection(this);
//`uvm_info(get_type_name(),"in test run phase",UVM_LOW)

//`uvm_info(get_type_name(),"in test run phase small test repeat",UVM_LOW)

endtask
class big_test extends router_base_test;

  
   // Factory Registration
	`uvm_component_utils(big_test)

	// Declare the handle for  ram_single_vseq virtual sequence
    	router_big_vseq b_seqh;
	bit [1:0]addr;
	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
 	extern function new(string name = "big_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	//extern function void end_of_elaboration_phase(uvm_phase phase);

endclass

//-----------------  constructor new method  -------------------//

 // Define Constructor new() function
function big_test::new(string name = "big_test" , uvm_component parent);
	super.new(name,parent);
endfunction


//-----------------  build() phase method  -------------------//
            
function void big_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction


task big_test::run_phase(uvm_phase phase);
 //raise objection
         phase.raise_objection(this);

repeat(20)
begin

addr={$random}%3;
uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);

 //create instance for sequence
          b_seqh=router_big_vseq::type_id::create("b_seqh");
 //start the sequence wrt virtual sequencer
          b_seqh.start(env.v_sequencer);
//`uvm_info(get_type_name(),"in test run phase",UVM_LOW)
 end

 //drop objection
         phase.drop_objection(this);
//`uvm_info(get_type_name(),"in test run phase",UVM_LOW)

//`uvm_info(get_type_name(),"in test run phase small test repeat",UVM_LOW)

endtask
class rndm_test extends router_base_test;

  
   // Factory Registration
	`uvm_component_utils(rndm_test)

	// Declare the handle for  ram_single_vseq virtual sequence
    	router_rndm_vseq r_seqh;
	bit [1:0]addr;
	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
 	extern function new(string name = "rndm_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	//extern function void end_of_elaboration_phase(uvm_phase phase);

endclass

//-----------------  constructor new method  -------------------//

 // Define Constructor new() function
function rndm_test::new(string name = "rndm_test" , uvm_component parent);
	super.new(name,parent);
endfunction


//-----------------  build() phase method  -------------------//
            
function void rndm_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction


task rndm_test::run_phase(uvm_phase phase);
 //raise objection
         phase.raise_objection(this);

repeat(20)
begin

addr={$random}%3;
uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);

 //create instance for sequence
          r_seqh=router_rndm_vseq::type_id::create("r_seqh");
 //start the sequence wrt virtual sequencer
          r_seqh.start(env.v_sequencer);
//`uvm_info(get_type_name(),"in test run phase",UVM_LOW)
 end

 //drop objection
         phase.drop_objection(this);
//`uvm_info(get_type_name(),"in test run phase",UVM_LOW)


//`uvm_info(get_type_name(),"in test run phase small test repeat",UVM_LOW)

endtask

class error_test extends router_base_test;

  
   // Factory Registration
	`uvm_component_utils(error_test)

	// Declare the handle for  ram_single_vseq virtual sequence
    	router_error_vseq r1_seqh;
	bit [1:0]addr;
	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
 	extern function new(string name = "error_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	//extern function void end_of_elaboration_phase(uvm_phase phase);

endclass

//-----------------  constructor new method  -------------------//

 // Define Constructor new() function
function error_test::new(string name = "error_test" , uvm_component parent);
	super.new(name,parent);
endfunction


//-----------------  build() phase method  -------------------//
            
function void error_test::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction


task error_test::run_phase(uvm_phase phase);
 //raise objection
         phase.raise_objection(this);
repeat(20)
begin
addr={$random}%3;
uvm_config_db#(bit[1:0])::set(this,"*","bit[1:0]",addr);

 //create instance for sequence
          r1_seqh=router_error_vseq::type_id::create("r1_seqh");
 //start the sequence wrt virtual sequencer
          r1_seqh.start(env.v_sequencer);
`uvm_info(get_type_name(),"in test run phase",UVM_LOW)
 end

 //drop bjection
         phase.drop_objection(this);
`uvm_info(get_type_name(),"in test run phase",UVM_LOW)

`uvm_info(get_type_name(),"in test run phase small test repeat",UVM_LOW)

endtask

