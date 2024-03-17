class router_vbase_seq extends uvm_sequence#(uvm_sequence_item);
// Factory registration
	`uvm_object_utils(router_vbase_seq)  
  // Declare dynamic array of handles for write sequencer and read sequencer as wr_seqrh[] & rd_seqrh[]
        router_wr_sequencer wr_seqrh[];
	router_rd_sequencer rd_seqrh[];
  // Declare handle for virtual sequencer
        router_virtual_sequencer vsqrh;
  // Declare dynamic array of Handles for all the sequences
	//router_random_wr_xtns random_wxtns;
	//router_random_rd_xtns random_rxtns;
//	router_wxtns_small_pkt small_wxtns;
//	router_wxtns_medium_pkt medium_wxtns;
//	router_wxtns_big_pkt big_wxtns;
//	router_wxtns_rndm_pkt rndm_wxtns;
//	router_rxtns1 rxtns1;
//	router_rxtns1 rxtns2;



	
  // Declare handle for ram_env_config
	router_env_config m_cfg;


	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
 	extern function new(string name = "router_vbase_seq");
	extern task body();
endclass 
//-----------------  constructor new method  -------------------//

// Add constructor 
function router_vbase_seq::new(string name ="router_vbase_seq");
	super.new(name);
endfunction
//-----------------  task body() method  -------------------//


task router_vbase_seq::body();
	// get the config object using uvm_config_db 
	if(!uvm_config_db #(router_env_config)::get(null,get_full_name(),"router_env_config",m_cfg))
	`uvm_fatal("CONFIG","cannot get() m_cfg from uvm_config_db. Have you set() it?")
	// initialize the dynamic arrays for write & read sequencers and all the write & read sequences declared above to m_cfg.no_of_duts
	wr_seqrh = new[m_cfg.no_of_write_agent];
	rd_seqrh = new[m_cfg.no_of_read_agent]; 
  	assert($cast(vsqrh,m_sequencer))
	else
		begin
		`uvm_error("BODY","Error in $cast of virtual sequencer")
		end
	foreach(wr_seqrh[i])
	wr_seqrh[i]=vsqrh.wr_seqrh[i];
	foreach(rd_seqrh[i])
	rd_seqrh[i]=vsqrh.rd_seqrh[i];
	

	
endtask: body

   

//------------------------------------------------------------------------------
//                  random sequence

//------------------------------------------------------------------------------
// Extend router_random_vseq from ram_vbase_seq
class router_small_vseq extends router_vbase_seq;

    // Define Constructor new() function
	`uvm_object_utils(router_small_vseq)
	bit[1:0]addr;
	router_wxtns_small_pkt wxtns;
	router_rxtns1 rxtns;
    //------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
 	extern function new(string name = "router_small_vseq");
	extern task body();
endclass 
//-----------------  constructor new method  -------------------//

// Add constructor 
function router_small_vseq::new(string name ="router_small_vseq");
	super.new(name);
endfunction
//-----------------  task body() method  -------------------//

task router_small_vseq::body();
	super.body();

       if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))   
	`uvm_fatal(get_type_name(),"getting the configuration failed,check if it is set properly")               
	if(m_cfg.has_wagent)	begin
		wxtns=router_wxtns_small_pkt::type_id::create("wxtns");
	end
     if(m_cfg.has_ragent) 	begin
		rxtns=router_rxtns1::type_id::create("rxtns");

	end
fork
begin
wxtns.start(wr_seqrh[0]);
end
begin
if(addr==2'b00)
rxtns.start(rd_seqrh[0]);
if(addr==2'b01)
rxtns.start(rd_seqrh[1]);
if(addr==2'b10)
rxtns.start(rd_seqrh[2]);


end
join

 endtask

// Extend router_random_vseq from ram_vbase_seq
class router_medium_vseq extends router_vbase_seq;

    // Define Constructor new() function
	`uvm_object_utils(router_medium_vseq)
	bit[1:0]addr;
	router_wxtns_medium_pkt wxtns1;
	router_rxtns1 rxtns;
    //------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
 	extern function new(string name = "router_medium_vseq");
	extern task body();
endclass 
//-----------------  constructor new method  -------------------//

// Add constructor 
function router_medium_vseq::new(string name ="router_medium_vseq");
	super.new(name);
endfunction
//-----------------  task body() method  -------------------//

task router_medium_vseq::body();
	super.body();

       if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))   
	`uvm_fatal(get_type_name(),"getting the configuration failed,check if it is set properly")               
	if(m_cfg.has_wagent)	begin
		wxtns1=router_wxtns_medium_pkt::type_id::create("wxtns1");
	end
     if(m_cfg.has_ragent) 	begin
		rxtns=router_rxtns1::type_id::create("rxtns");

	end
fork
begin
wxtns1.start(wr_seqrh[0]);
end
begin
if(addr==2'b00)
rxtns.start(rd_seqrh[0]);
if(addr==2'b01)
rxtns.start(rd_seqrh[1]);
if(addr==2'b10)
rxtns.start(rd_seqrh[2]);


end
join

 endtask

// Extend router_random_vseq from ram_vbase_seq
class router_big_vseq extends router_vbase_seq;

    // Define Constructor new() function
	`uvm_object_utils(router_big_vseq)
	bit[1:0]addr;
	router_wxtns_big_pkt wxtns2;
	router_rxtns1 rxtns;
    //------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
 	extern function new(string name = "router_big_vseq");
	extern task body();
endclass 
//-----------------  constructor new method  -------------------//

// Add constructor 
function router_big_vseq::new(string name ="router_big_vseq");
	super.new(name);
endfunction
//-----------------  task body() method  -------------------//

task router_big_vseq::body();
	super.body();

       if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))   
	`uvm_fatal(get_type_name(),"getting the configuration failed,check if it is set properly")               
	if(m_cfg.has_wagent)	begin
		wxtns2=router_wxtns_big_pkt::type_id::create("wxtns2");
	end
     if(m_cfg.has_ragent) 	begin
		rxtns=router_rxtns1::type_id::create("rxtns");

	end
fork
begin
wxtns2.start(wr_seqrh[0]);
end
begin
if(addr==2'b00)
rxtns.start(rd_seqrh[0]);
if(addr==2'b01)
rxtns.start(rd_seqrh[1]);
if(addr==2'b10)
rxtns.start(rd_seqrh[2]);


end
join

 endtask

// Extend router_random_vseq from ram_vbase_seq
class router_rndm_vseq extends router_vbase_seq;

    // Define Constructor new() function
	`uvm_object_utils(router_rndm_vseq)
	bit[1:0]addr;
	router_wxtns_rndm_pkt wxtns3;
	router_rxtns2 rxtns;
    //------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
 	extern function new(string name = "router_rndm_vseq");
	extern task body();
endclass 
//-----------------  constructor new method  -------------------//

// Add constructor 
function router_rndm_vseq::new(string name ="router_rndm_vseq");
	super.new(name);
endfunction
//-----------------  task body() method  -------------------//

task router_rndm_vseq::body();
	super.body();

       if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))   
	`uvm_fatal(get_type_name(),"getting the configuration failed,check if it is set properly")               
	if(m_cfg.has_wagent)	begin
		wxtns3=router_wxtns_rndm_pkt::type_id::create("wxtns3");
	end
     if(m_cfg.has_ragent) 	begin
		rxtns=router_rxtns2::type_id::create("rxtns");

	end
fork
begin
wxtns3.start(wr_seqrh[0]);
end
begin
if(addr==2'b00)
rxtns.start(rd_seqrh[0]);
if(addr==2'b01)
rxtns.start(rd_seqrh[1]);
if(addr==2'b10)
rxtns.start(rd_seqrh[2]);


end
join

 endtask


// Extend router_random_vseq from ram_vbase_seq
class router_error_vseq extends router_vbase_seq;

    // Define Constructor new() function
	`uvm_object_utils(router_error_vseq)
	bit[1:0]addr;
	router_error_pkt wxtns4;
	router_rxtns1 rxtns1;
    //------------------------------------------
	// METHODS
	//------------------------------------------

	// Standard UVM Methods:
 	extern function new(string name = "router_error_vseq");
	extern task body();
endclass 
//-----------------  constructor new method  -------------------//

// Add constructor 
function router_error_vseq::new(string name ="router_error_vseq");
	super.new(name);
endfunction
//-----------------  task body() method  -------------------//

task router_error_vseq::body();
	super.body();

       if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))   
	`uvm_fatal(get_type_name(),"getting the configuration failed,check if it is set properly")               
	if(m_cfg.has_wagent)	begin
		wxtns4=router_error_pkt::type_id::create("wxtns4");
	end
     if(m_cfg.has_ragent) 	begin
		rxtns1=router_rxtns1::type_id::create("rxtns1");

	end
fork
begin
wxtns4.start(wr_seqrh[0]);
end
begin
if(addr==2'b00)
rxtns1.start(rd_seqrh[0]);
if(addr==2'b01)
rxtns1.start(rd_seqrh[1]);
if(addr==2'b10)
rxtns1.start(rd_seqrh[2]);


end
join

 endtask
