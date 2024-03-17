module top;
//import router package and uvm_pkg.sv	
	import router_test_pkg::*;
	import uvm_pkg::*;
//generate clock signal
	bit clock;
	always
		#10 clock=!clock;

//instantiate interfaces
router_if in(clock);
router_if in0(clock);
router_if in1(clock);
router_if in2(clock);
//instantiate rtl and pass interface as argument
router_top DUV(.clock(clock),
                  .resetn(in.rst),
                  .read_enb_0(in0.read_enb),
                  .read_enb_1(in1.read_enb),
                  .read_enb_2(in2.read_enb),
                  .data_in(in.data_in),
                  .pkt_valid(in.pkt_valid),
                  .busy(in.busy),
                  .error(in.error),
                  .valid_out_0(in0.vld_out),
                  .valid_out_1(in1.vld_out),
                  .valid_out_2(in2.vld_out),
		  .data_out_0(in0.data_out),
                  .data_out_1(in1.data_out),
                  .data_out_2(in2.data_out));

//in initial block

	initial 
		begin
			`ifdef VCS
			$fsdbDumpvars(0,top);
			`endif
//set virtual interface instances
			uvm_config_db #(virtual router_if)::set(null,"*","vif",in);
			uvm_config_db #(virtual router_if)::set(null,"*","vif_0",in0);
			uvm_config_db #(virtual router_if)::set(null,"*","vif_1",in1);
			uvm_config_db #(virtual router_if)::set(null,"*","vif_2",in2);


//call run_test
			run_test();
		end
property pkt_vld;
		@(posedge clock)
		$rose(in.pkt_valid) |=> in.busy;
		endproperty
		A:assert property(pkt_vld);

		property stable;
		@(posedge clock)
		in.busy |=> $stable(in.data_in);
		endproperty
		B:assert property(stable);
	
		 property read0;
                @(posedge clock)
                $rose(in0.vld_out) |=> ##[0:29] in0.read_enb;
                endproperty
                C:assert property(read0);

		property read1;
		@(posedge clock)
		$rose(in1.vld_out) |=> ##[0:29] in1.read_enb;
		endproperty
		D:assert property(read1);

		
		property read2;
		@(posedge clock)
		$rose(in2.vld_out) |=> ##[0:29] in2.read_enb;
		endproperty
		E:assert property(read2);

		
		COV_0:cover property(pkt_vld);
		COV_1:cover property(stable);
		COV_2:cover property(read0);
		COV_3:cover property(read1);
		COV_4:cover property(read2);
			
endmodule
