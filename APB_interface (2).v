module apb_interface(input pwrite,penable, input [2:0]psel, 
input [31:0]paddr,pwdata, output pwrite_out,penable_out,
output [2:0]psel_out,output [31:0]paddr_out,pwdata_out, output reg [31:0]prdata);
assign pwrite_out=pwrite;
assign penable_out=penable;
assign psel_out=psel;
assign paddr_out=paddr;
assign pwdata_out=pwdata;
always@(*)
begin
if(!pwrite&&penable)
prdata=($random)%256;
else
prdata=32'h0;
end
endmodule
