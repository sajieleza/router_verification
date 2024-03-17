interface router_if(input bit clock);

logic [7:0]data_in;
logic [7:0]data_out;
logic rst;
logic error;
bit busy;
logic read_enb;
bit pkt_valid;
logic vld_out;
//write driver clocking block
clocking wdr_cb@(posedge clock);
	default input #1 output #1;
	output data_in;
	output pkt_valid;
	output rst;
	input error;
	input busy;

endclocking

//read driver clocking block
clocking rdr_cb@(posedge clock);
	default input #1 output #1;
	output read_enb;
	input vld_out;
endclocking
//write driver MP
modport WDR_MP(clocking wdr_cb);
//read driver clocking block
modport RDR_MP(clocking rdr_cb);

//write monitor clocking block
clocking wmon_cb@(posedge clock);
	default input #1 output #1;
	input data_in;
	input pkt_valid;
	input rst;
	input error;
	input busy;
endclocking
//read monitor clocking block
clocking rmon_cb@(posedge clock);
	default input #1 output #1;
	input data_out;
	input read_enb;
endclocking
//write monitor MP
modport WMON_MP(clocking wmon_cb);
//read monitor MP
modport RMON_MP(clocking rmon_cb);
endinterface


