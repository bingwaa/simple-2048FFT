module control(
clk,
rst,
k,
state,
sram0_addr,
sram1_addr,
sram2_addr,
sram0_cs,
sram1_cs,
sram2_cs,
sram0_w,
sram1_w,
sram2_w,
caldata_cs,
caldata_w,
sel
  );
input rst;
input clk;
input [3:0]k;
output reg sel;
output [11:0]sram0_addr;
output [11:0]sram1_addr;
output [11:0]sram2_addr;
output reg sram0_cs;
output reg sram1_cs;
output reg sram2_cs;
output reg sram0_w; 
output reg sram1_w;
output reg sram2_w;
output reg caldata_cs;
output reg caldata_w; 
output reg [4:0]state;

parameter width=2048;//动态参数
parameter AZ=12;

reg [11:0]sram0_addr;
reg [11:0]sram1_addr;
reg [11:0]sram2_addr;
reg [11:0]i;
reg [11:0]j;
reg [3:0]z;
reg [11:0]c;
reg [11:0]num;
reg [11:0]b;
reg [11:0]p;
reg [11:0]block;

always@(posedge clk,negedge rst)begin
  if(!rst)begin
    sram0_addr<=0;
    sram1_addr<=0;
    sram2_addr<=0;
    sram0_cs<=0;
    sram1_cs<=0;
    sram2_cs<=0;
    sram0_w<=0;
    sram1_w<=0;
    sram2_w<=0;
    caldata_cs<=0;
    caldata_w<=0;
    i<=0;
    sel<=0;
    j<=0;
    z<=1;
    c<=0;
    b<=0;
    p<=0;
    num<=0;
    block<=0;
    state<=0;
  end
  else begin
    case(state)
      0:begin
        sram0_cs<=1;
        sram0_w<=1;
        sram0_addr<=0;
        sram2_cs<=1;     
        sram2_w<=1;      
        sram2_addr<=0;
        state<=1;
      end
      1:begin
        if(sram0_addr==(width-1))begin
          sram0_cs<=1;   
          sram0_w<=0;
          sram2_cs<=0;     
          sram2_w<=0;    
          state<=2;  
          sram1_cs<=1;
          sram1_w<=1;  
          sram0_addr<=0;
        end      
        else begin          
          sram0_cs<=1;   
          sram0_w<=1;    
          sram0_addr<=sram0_addr+1;
          sram2_cs<=1;     
          sram2_w<=1;      
          sram2_addr<=sram2_addr+1;       
          state<=1;
        end
      end 
      2:begin
        sram0_addr<=0;
        state<=3;
      end
      3:begin
        sram1_addr[10:0]<={sram0_addr[0],sram0_addr[1],sram0_addr[2],sram0_addr[3],sram0_addr[4],sram0_addr[5],sram0_addr[6],sram0_addr[7],sram0_addr[8],sram0_addr[9],sram0_addr[10]};
        state<=4;
      end 
      4:begin
        if(sram0_addr==(width-1))begin
          sram1_cs<=1;    
          sram1_w<=0;  
          sel<=1;   
          state<=5;      
        end
        else begin           
          sram1_cs<=1;    
          sram1_w<=1; 
          sram0_w<=0;    
          sram0_addr=sram0_addr+1;
          state<=6;
        end
      end
      5:begin
        if (z<AZ)begin
          c<=c+num/2;
          state<=7;
        end
      end
      6:begin
        sram1_addr[10:0]={sram0_addr[0],sram0_addr[1],sram0_addr[2],sram0_addr[3],sram0_addr[4],sram0_addr[5],sram0_addr[6],sram0_addr[7],sram0_addr[8],sram0_addr[9],sram0_addr[10]};     
        state<=4;
      end
      7:begin
        num<=2**z;
        state<=8;
      end 
      8:begin 
        block<=(width)/num;
        state<=9;
      end 
      9:begin 
        b=num/2;
        state<=10;
      end 
      10:begin
        if(i<block)begin
          p<=num*i ;
          state<=11;
        end 
        else begin
          z<=z+1;
          i<=0;
          state<=5;
        end
      end 
      11:begin 
        if(j<b)
          state<=12;
        else begin 
          i<=i+1;
          state<=10;
          j<=0;
        end 
      end 
      12:begin
        caldata_cs<=1;
        caldata_w<=1;
        sram1_cs<=1;
        sram1_w<=0;
        sram2_cs<=1;
        sram2_w<=0;
        sram1_addr<=p+j;
        sram2_addr<=c+j;
        state<=13;  
      end
      13:
        state<=14;
      14:begin
        if(k==2)begin
          caldata_cs<=1;
          caldata_w<=1;     
          sram1_cs<=1;   
          sram1_w<=0;                  
          sram2_cs<=1;   
          sram2_w<=0;    
          sram1_addr<=p+j+b;
          state<=15;
        end 
        else
          state<=14;      
      end 
      15:begin
        if(k==8)begin 
          caldata_cs<=1;
          caldata_w<=0;
          sram1_cs<=1;
          sram1_w<=1; 
          sram1_addr<=p+j;
          state<=16;
        end 
        else
          state<=15;
      end
      16:begin 
        if(k==9)begin 
          caldata_cs<=1;
          caldata_w<=0;
          sram1_cs<=1;
          sram1_w<=1; 
          sram1_addr<=p+j+b;
          j<=j+1;
          state<=17;
        end
        else 
          state<=16;
      end 
      17:
        if(k==0)
          state<=11;
        else
          state<=17;
      default:begin     
        sram0_addr<=0;  
        sram1_addr<=0;  
        sram2_addr<=0; 
        sram0_cs<=0;    
        sram1_cs<=0;    
        sram2_cs<=0;    
        sram0_w<=0;     
        sram1_w<=0;     
        sram2_w<=0;     
        caldata_cs<=0;      
        caldata_w<=0;       
      end
    endcase
  end
end
endmodule       