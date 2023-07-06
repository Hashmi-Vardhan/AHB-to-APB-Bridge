module apb_controller(input hclk,hresetn,hwrite,hwrite_reg,valid,
input [31:0]haddr,haddr1,haddr2,hwdata,hwdata1,hwdata2,prdata,
input [2:0]tempselx,
output reg pwrite,penable,hr_readyout,
output reg [2:0]psel,
output reg [31:0]paddr,pwdata);


//temporary o/p variables
reg penable_temp,pwrite_temp,hr_readyout_temp;
reg [2:0]psel_temp;
reg [31:0]paddr_temp,pwdata_temp;


//present state sequential logic
parameter idle=3'b000,read=3'b001,renable=3'b010,wwait=3'b011,write=3'b100,wenable=3'b101,writep= 3'b110,wenablep=3'b111;
reg [2:0]present,next;


always@(posedge hclk)
begin
if(!hresetn)
present<=idle;
else
present<=next;
end


//next state combinational logic
always@(*)
begin
next=idle;
case(present)
idle:begin
if(valid==1&&hwrite==1)
next=wwait;
else if(valid==1&&hwrite==0)
next=read;
else
next=idle;
end
read:next=renable;
renable:begin
if(valid==1&&hwrite==1)
next=wwait;
else if(valid==1&&hwrite==0)
next=read;
else
next=idle;
end
wwait:begin
if(valid==0)
next=write;
else
next=writep;
end
write:begin
if(valid==0)
next=wenable;
else
next=wenablep;
end
wenable:begin
if(valid==1&&hwrite==1)
next=wwait;
else if(valid==1&&hwrite==0)
next=read;
else
next=idle;
end
writep:next=wenablep;
wenablep:begin
if(valid==1&&hwrite_reg==1)
next=writep;
else if(valid==0&&hwrite_reg==1)
next=write;
else
next=read;
end
endcase
end


//temporaray output logic(comb)
always@(*)
begin
case(present)
idle:begin
if(valid==1&&hwrite==0)
begin
paddr_temp=haddr;
pwrite_temp=hwrite;
psel_temp=tempselx;
penable_temp=0;
hr_readyout_temp=0;
end
else if(valid==1&&hwrite==1)
begin
psel_temp=0;
penable_temp=0;
hr_readyout_temp=1;
end
else
begin
psel_temp=0;
penable_temp=0;
hr_readyout_temp=1;
end
end

read:begin
penable_temp=1;
hr_readyout_temp=1;
end

renable:begin
if(valid==1&&hwrite==0)
begin
paddr_temp=haddr;
pwrite_temp=hwrite;
psel_temp=tempselx;
penable_temp=0;
hr_readyout_temp=0;
end
else if(valid==1&&hwrite==1)
begin
psel_temp=0;
penable_temp=0;
hr_readyout_temp=1;
end
else
begin
psel_temp=0;
penable_temp=0;
hr_readyout_temp=1;
end
end

wwait:begin
paddr_temp=haddr1;
pwdata_temp=hwdata;
pwrite_temp=hwrite;
psel_temp=tempselx;
penable_temp=0;
hr_readyout_temp=0;
end

write:begin
penable_temp=1;
hr_readyout_temp=1;
end

wenable:begin
if(valid==1&&hwrite==0)
begin
hr_readyout_temp=1;
psel_temp=0;
penable_temp=0;
end
else if(valid==1&&hwrite==0)
begin
paddr_temp=haddr1;
pwrite_temp=hwrite_reg;
psel_temp=tempselx;
penable_temp=0;
hr_readyout_temp=0;
end
else
begin
hr_readyout_temp=1;
psel_temp=0;
penable_temp=0;
end
end

writep:begin
penable_temp=1;
hr_readyout_temp=1;
end


wenablep:begin
paddr_temp=haddr1;
pwdata_temp=hwdata;
pwrite_temp=hwrite;
psel_temp=tempselx;
penable_temp=0;
hr_readyout_temp=0;
end
endcase
end


//output logic(seq)
always@(posedge hclk)
begin
if(!hresetn)
begin
paddr<=0;
pwdata<=0;
pwrite<=0;
psel<=0;
penable<=0;
hr_readyout<=1;
end
else
begin
paddr<=paddr_temp;
pwdata<=pwdata_temp;
pwrite<=pwrite_temp;
psel<=psel_temp;
penable<=penable_temp;
hr_readyout<=hr_readyout_temp;
end
end
endmodule
