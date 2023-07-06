module top_tb();
reg hclk;
reg hresetn;
wire [31:0]haddr,hwdata,hrdata,paddr,prdata,pwdata,paddr_out,pwdata_out;
wire hwrite,hreadyin;
wire [1:0]htrans;
wire [1:0]hresp;
wire penable,pwrite,hr_readyout,pwrite_out,penable_out;
wire [2:0]psel,psel_out;
ahb_master ahb(hclk,hresetn,hr_readyout,hrdata,hresp,
hwrite,hreadyin,haddr,hwdata,htrans);
bridge_top BRIDGE(hclk,hresetn,hwrite,hreadyin,htrans,
hwdata,haddr,prdata,penable,pwrite,hr_readyout,psel,
hresp,paddr,pwdata,hrdata);
apb_interface APB(pwrite,penable,psel,paddr,pwdata,
pwrite_out,penable_out,psel_out,paddr_out,pwdata_out,
prdata);
initial
begin
hclk=1'b0;
forever #10 hclk=~hclk;
end
task reset;
begin
@(negedge hclk)
hresetn=1'b0;
@(negedge hclk)
hresetn=1'b1;
end
endtask
initial
begin
reset;
//ahb.single_write(); #300;
//ahb.single_read(); #300;
//ahb.burst_incr4_write(); #300;
ahb.burst_incr4_read(); #300;
$finish;
end
endmodule
