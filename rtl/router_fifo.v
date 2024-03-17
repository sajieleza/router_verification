module router_fifo(clk,rstn,wr,soft_rst,rd,data_in,lfd_state,empty,full,data_out);
input clk,rstn,wr,rd,soft_rst,lfd_state;
input[7:0]data_in;
output full,empty;
output reg [7:0]data_out;

reg [4:0]wr_pt=5'b0;
reg [4:0]rd_pt=5'b0;
reg [4:0]fifo_counter;
reg [8:0] mem [15:0];
reg lfd_state_s;
integer i;

//down counter logic

always@(posedge clk)
begin
if(!rstn)
begin
fifo_counter<=0;
end
else if(soft_rst)
begin
fifo_counter<=0;
end
else if(rd & !empty)
begin
if(mem[rd_pt[3:0]][8]==1'b1)
fifo_counter<=mem[rd_pt[3:0]][7:2]+1'b1;
else if(fifo_counter !=0)
fifo_counter<=fifo_counter-1'b1;
end
end

//read operation

always@(posedge clk)
begin
if(!rstn)
data_out<=8'b00000000;
else if(soft_rst)
data_out<=8'bzzzzzzzz;
else
begin
if(fifo_counter==0 && data_out !=0)
data_out<=8'bz;
else if(rd && ~empty)
data_out<=mem[rd_pt[3:0]];
end
end
//write operation
always@(posedge clk)
begin
if(!rstn)
begin
for(i=0;i<16;i=i+1)begin
mem[i]<=0;
end
end
else if(soft_rst)
begin
for(i=0;i<16;i=i+1)begin
mem[i]<=0;
end
end
else
begin
if(wr && !full)
{mem[wr_pt[3:0]]}<={lfd_state_s,data_in};
end
end
//logic for incrementing pointer
always@(posedge clk)
begin
if(!rstn)begin
rd_pt<=5'b00000;
wr_pt<=5'b00000;
end
else if(soft_rst)begin
rd_pt<=5'b00000;
wr_pt<=5'b00000;
end
else begin
if(!full && wr)
wr_pt<=wr_pt+1;
else
wr_pt<=wr_pt;
if(!empty && rd)
rd_pt<=rd_pt+1;
else
rd_pt<=rd_pt;
end
end
//delay lfd_state by one cycle
always@(posedge clk)
begin
if(~rstn)
lfd_state_s<=0;
else
lfd_state_s<=lfd_state;
end
//empty and full logic
assign full=(wr_pt=={~rd_pt[4],rd_pt[3:0]})?1'b1:1'b0;
assign empty=(wr_pt==rd_pt)?1'b1:1'b0;
endmodule
