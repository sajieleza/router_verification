class router_scoreboard extends uvm_scoreboard;
// Factory registration
	`uvm_component_utils(router_scoreboard)
// Declare handles for uvm_tlm_analysis_fifos parameterized by read & write transactions as fifo_rdh & fifo_wrh respectively
//    Hint:  uvm_tlm_analysis_fifo #(read_xtn) fifo_rdh;
//           uvm_tlm_analysis_fifo #(write_xtn) fifo_wrh;
	
	uvm_tlm_analysis_fifo #(read_xtn) fifo_rdh[];
    	uvm_tlm_analysis_fifo #(write_xtn) fifo_wrh;
//handles for write and read xtn to store analysis fifo data
	write_xtn wr_data;
	read_xtn rd_data;
read_xtn read_cov_data;
write_xtn write_cov_data;
	router_env_config e_cfg;
int data_verified_count;
//bit busy=1;


//standard methods
	extern function new(string name="router_scoreboard",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task check_data(read_xtn rd_data);
	extern function void report_phase(uvm_phase phase);
covergroup router_fcov1;
option.per_instance=1;
CHANNEL:coverpoint write_cov_data.header[1:0]{
						bins low={2'b00};
						bins mid1={2'b01};
						bins mid2={2'b10};}
PAYLOAD_SIZE:coverpoint write_cov_data.header[7:2]{
bins small_packet={[1:15]};
bins medium_packet={[16:30]};
bins big_packet={[31:63]};
}
BAD_PKT:coverpoint write_cov_data.error{bins bad_pkt={1};}
CHANNEL_X_PAYLOAD_SIZE:cross CHANNEL,PAYLOAD_SIZE;
CHANNEL_X_PAYLOAD_SIZE_X_BAD_PKT:cross CHANNEL,PAYLOAD_SIZE,BAD_PKT;

endgroup

covergroup router_fcov2;
option.per_instance=1;
CHANNEL:coverpoint read_cov_data.header[1:0]{
						bins low={2'b00};
						bins mid1={2'b01};
						bins mid2={2'b10};}
PAYLOAD_SIZE:coverpoint read_cov_data.header[7:2]{
bins small_packet={[1:15]};
bins medium_packet={[16:30]};
bins big_packet={[31:63]};
}
CHANNEL_X_PAYLOAD_SIZE:cross CHANNEL,PAYLOAD_SIZE;


endgroup

endclass

//-----------------  constructor new method  -------------------//

       // Add Constructor function
           // Create instances of uvm_tlm_analysis fifos inside the constructor
           // using new("fifo_h", this)
function router_scoreboard::new(string name="router_scoreboard",uvm_component parent);
	super.new(name,parent);
	router_fcov1 = new();
  	router_fcov2 = new();
	 
endfunction

function void router_scoreboard::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",e_cfg))
		`uvm_fatal("EN_cfg","no update")
	wr_data=write_xtn::type_id::create("wr_data",this);
	rd_data=read_xtn::type_id::create("rd_data",this);
	fifo_wrh=new("fifo_wrh",this);
	fifo_rdh=new[e_cfg.no_of_read_agent];
	foreach(fifo_rdh[i])
		begin
			fifo_rdh[i]=new($sformatf("fifo_rdh[%0d]",i),this);
		end

	
endfunction
task router_scoreboard::run_phase(uvm_phase phase);
		fork
begin
		forever
	
			begin
			fifo_wrh.get(wr_data);
			`uvm_info(get_type_name(),$sformatf("Source Transaction \n %s",wr_data.sprint()),UVM_LOW)
			write_cov_data=wr_data;
			router_fcov1.sample();
		end
	
		

	
end
	
	forever
	begin
	fork
		
		begin
	//	$display("inside dst0");
		fifo_rdh[0].get(rd_data);
		`uvm_info(get_type_name(),$sformatf("Destination Tranasction \n %s",rd_data.sprint()),UVM_LOW)
		read_cov_data=rd_data;
		router_fcov2.sample();
		check_data(rd_data);
		end
		begin
	//$display("inside dst1");

		fifo_rdh[1].get(rd_data);
		`uvm_info(get_type_name(),$sformatf("Destination Tranasction \n %s",rd_data.sprint()),UVM_LOW)
		read_cov_data=rd_data;
		router_fcov2.sample();
		check_data(rd_data);
		end
		begin
	//$display("inside dst2");

		fifo_rdh[2].get(rd_data);
		`uvm_info(get_type_name(),$sformatf("Destination Tranasction \n %s",rd_data.sprint()),UVM_LOW)
		read_cov_data=rd_data;
		router_fcov2.sample();
		check_data(rd_data);
		end


	join_any
	end
disable fork;
join
	
endtask

task router_scoreboard::check_data(read_xtn rd_data);
	if(wr_data.header==rd_data.header)
		`uvm_info("SCOREBOARD","Header Comparison Successful",UVM_LOW)
	else
		`uvm_info("SCOREBOARD","Header Comparison unsuccessful",UVM_LOW)
	if(wr_data.payload_data==rd_data.payload_data)
		`uvm_info("SCOREBOARD","Payload_data Comparison Successful",UVM_LOW)
	else
		`uvm_info("SCOREBOARD","Payload_data Comparison unsuccessful",UVM_LOW)
	if(wr_data.parity==rd_data.parity)
		`uvm_info("SCOREBOARD","Parity Comparison Successful",UVM_LOW)
	else
		`uvm_info("SCOREBOARD","Parity Comparison unsuccessful",UVM_LOW)


data_verified_count++;
	
endtask
function void router_scoreboard::report_phase(uvm_phase phase);
 `uvm_info(get_type_name(), $sformatf("Scoreboard data verified count: %0d \n ",data_verified_count), UVM_LOW)
	
endfunction

