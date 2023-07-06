module ahb_slave_interface(input hclk,hresetn,hwrite,hreadyin, 
input [31:0] hwdata,haddr,prdata,
input [1:0]htrans,
output wire [31:0] hrdata,
output reg [31:0] haddr1,haddr2,hwdata1,hwdata2,
output reg hwrite_reg,hwrite_reg1, valid,
output reg [2:0] temp_selx);
//piplining haddr,hwdata and write signal
always@(posedge hclk)
begin 
if(!hresetn)
begin
haddr1<=0;
haddr2<=0;
end 
else 
begin
haddr1 <=haddr;
haddr2<=haddr1;
end 
end
always@(posedge hclk)
begin 
if(!hresetn)
begin
hwdata1 <=0;
hwdata2<=0;
end 
else 
begin
hwdata1 <=hwdata;
hwdata2<=hwdata1;
end 
end
always@(posedge hclk)
begin 
if(!hresetn)
begin
hwrite_reg<=0;
hwrite_reg1 <=0;
end 
else 
begin
hwrite_reg<=hwrite;
hwrite_reg1 <=hwrite_reg;
end 
end
//generating valid signal
always@(*) 
begin
valid=0;
if(hreadyin==1 && haddr>=32'h80000000 && haddr<32'h8c000000 && (htrans==2'b10||htrans==2'b11))
valid=1; 
else
valid=0; 
end
//generating temp_selx signal
always@(*)
begin
temp_selx=0;
if(haddr>=32'h80000000 && haddr<32'h84000000) 
temp_selx=3'b001;
else if(haddr>=32'h84000000 && haddr<32'h88000000) 
temp_selx=3'b010;
else if(haddr>=32'h88000000 && haddr<32'h8c000000) 
temp_selx=3'b100;
else
temp_selx=0;
 end
assign hrdata=prdata; 
endmodule
