module butterfly(
clk,
rst,
k,
cs,
w,
state,
caldata_in_r,
caldata_w_r,
caldata_in_i,
caldata_w_i,
caldata_out_r,
caldata_out_i,
  );
input cs,clk,w,rst;
input [4:0]state;
input [40:0]caldata_in_r;
input [7:0]caldata_w_r;
input [40:0]caldata_in_i;
input [7:0]caldata_w_i;     
output [40:0]caldata_out_r;
output [40:0]caldata_out_i;
output [3:0]k;

wire signed [7:0]caldata_w_r;         
wire signed [7:0]caldata_w_i;
reg signed [40:0]caldata_insm_r;       
reg signed [40:0]caldata_insm_i;      
reg signed [40:0]caldata_out_r;
reg signed [40:0]caldata_out_i;
reg signed [40:0]caldata_inbi_r;      
reg signed [40:0]caldata_inbi_i;      
reg signed [40:0]cal_r;
reg signed [40:0]cal_i;
reg signed [40:0]pro_caldata_outsm_r;
reg signed [40:0]pro_caldata_outsm_i;
reg signed [40:0]pro_caldata_outbi_r;
reg signed [40:0]pro_caldata_outbi_i;
reg signed [40:0]caldata_outsm_r;
reg signed [40:0]caldata_outsm_i;
reg signed [40:0]caldata_outbi_r;
reg signed [40:0]caldata_outbi_i;
reg [3:0]k;

always@(posedge clk,negedge rst)
  if(!rst)begin
    k<=0;
  end
  else begin
    case(k)
      0:if(state==13)
        k<=1;
      1:begin
        caldata_insm_r<=caldata_in_r;
        caldata_insm_i<=caldata_in_i;
        k<=2;
      end
      2:begin
        if(state==15) 
          k<=3;
      end 
      3:
        k<=4;
      4:begin
        caldata_inbi_r<=caldata_in_r;
        caldata_inbi_i<=caldata_in_i;
        k<=5;
      end
      5:begin
        cal_r<=caldata_inbi_r*caldata_w_r-caldata_inbi_i*caldata_w_i;
        cal_i<=caldata_inbi_r*caldata_w_i+caldata_inbi_i*caldata_w_r;
        k<=6;
      end
      6:begin
        pro_caldata_outsm_r<=caldata_insm_r*127+cal_r;
        pro_caldata_outsm_i<=caldata_insm_i*127+cal_i;
        pro_caldata_outbi_r<=caldata_insm_r*127-cal_r;
        pro_caldata_outbi_i<=caldata_insm_i*127-cal_i;
        k<=7;
      end                     
      7:begin
        caldata_outsm_r<=pro_caldata_outsm_r/127;
        caldata_outsm_i<=pro_caldata_outsm_i/127;
        caldata_outbi_r<=pro_caldata_outbi_r/127;
        caldata_outbi_i<=pro_caldata_outbi_i/127;
        k<=8;
      end                     
      8:begin
        if(state==16)begin
          caldata_out_r<=caldata_outsm_r;
          caldata_out_i<=caldata_outsm_i;
          k<=9;
        end
      end
      9:begin
        if(state==17)begin
          caldata_out_r<=caldata_outbi_r; 
          caldata_out_i<=caldata_outbi_i; 
          k<=0;
        end
      end
      default:;
    endcase
  end
endmodule  