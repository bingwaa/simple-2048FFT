`timescale 1ns/1ns
module fft_tb();
integer i,j,fid1,fid2;

reg clk,w,rst;  
reg [7:0]data_in_r;
reg [7:0]data_in_i;
reg [7:0]data_w_r;
reg [7:0]data_w_i;

parameter width=2048;

reg signed [7:0]data_in[width-1:0][1:0];
reg signed [7:0]data_w[width-2:0][1:0]; 
reg signed [40:0]data_out[width-1:0][1:0];

top top1(
  .clk(clk),
  .rst(rst),
  .data_in_r(data_in_r),
  .data_in_i(data_in_i),
  .data_w_r(data_w_r),
  .data_w_i(data_w_i),
  .data_out_r(data_out_r),
  .data_out_i(data_out_i),
  .state(state)
	);

initial begin
  clk=0;
    forever begin
      #5 clk=~clk;
    end
end
	
	

initial begin
  $display("1.data_input");
  $readmemh("D:/project/32-4096-fft/Data_Input2048.txt",data_in);
    for(i=0 ; i<width ;i=i+1)
    begin
      $display("i=%d,data_in(%d,%d)",i,data_in[i][0],  data_in[i][1]);
    end
  $display("2.data_w");                                                                          
  $readmemh("D:/project/32-4096-fft/Data_Parameter2048.txt",data_w);                                      
    for(i=0;i<(width-1);i=i+1)                                                              
    begin                                                                               
      $display("i=%d,data_w:(%d,%d)",i,data_w[i][0],  data_w[i][1]); 
    end

rst=0;
clk=1;
#10 rst=1;
    
for(i=0;i<width;i=i+1)
  begin @(posedge clk)
    data_in_r<=data_in[i][0];
    data_in_i<=data_in[i][1];
    data_w_r<=data_w[i][0];
    data_w_i<=data_w[i][1];
  end  
end

initial begin
#2000000
  fid1=$fopen("D:/project/fft_third/9.7/Data_Verilog_R2048.txt","w");
  begin
    for(i = 0; i< width; i = i + 1)
      begin
        $fdisplay(fid1,"%d",top1.sram1_r.memory[i]);
      end
  end 
    begin
    fid2=$fopen("D:/project/fft_third/9.7/Data_Verilog_I2048.txt","w");
    end
  begin
    for(j = 0; j < width; j = j + 1)
      begin
        $fdisplay(fid2,"%d",top1.sram1_i.memory[j]);
      end               
  end 
end
 
endmodule 	
		

	