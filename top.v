module top(
input rst,clk,
input [7:0]data_in_r,
input [7:0]data_in_i,
input [7:0]data_w_r,
input [7:0]data_w_i,
output [40:0]data_out_r,
output [4:0]state,
output [40:0]data_out_i
  );

wire sram0_cs;
wire sram1_cs;
wire sram2_cs;
wire sram0_w;
wire sram1_w;
wire sram2_w;
wire caldata_cs;
wire caldata_w;
wire [40:0]caldata_out_r;
wire [40:0]caldata_out_i;
wire [40:0]sram0_addr; 
wire [40:0]sram1_addr;             
wire [40:0]sram2_addr;
wire [40:0]sram0_out_r;
wire [40:0]sram0_out_i;
wire [40:0]sram1_out_r;
wire [40:0]sram1_out_i;
wire [40:0]sram1_in_r;
wire [40:0]sram1_in_i;
wire [40:0]sram2_out_r;
wire [40:0]sram2_out_i;
wire [3:0]k;           
            
Mux Mux_1_r(
      .data1(sram0_out_r),
      .data2(caldata_out_r),
      .sel(sel),
      .out(sram1_in_r)
      );
Mux Mux_1_i(
      .data1(sram0_out_i),
      .data2(caldata_out_i),
      .sel(sel),
      .out(sram1_in_i)
      );

sram_w sram0_r(
      .clk(clk),                     
      .rst(rst),                               
      .w(sram0_w),                             
      .cs(sram0_cs),                           
      .addr(sram0_addr),                       
      .data_in(data_in_r),                     
      .data_out(sram0_out_r));                 
            
sram sram1_r(
      .clk(clk),                   
      .rst(rst),                               
      .w(sram1_w),                             
      .cs(sram1_cs),                           
      .addr(sram1_addr),                       
      .data_in(sram1_in_r),                   
      .data_out(sram1_out_r));                   
                                                     
sram_w sram2_r(
      .clk(clk),                   
      .rst(rst),                               
      .w(sram2_w),                             
      .cs(sram2_cs),                           
      .addr(sram2_addr),                       
      .data_in(data_w_r),                       
      .data_out(sram2_out_r));                  
            
           
sram_w sram0_i(.clk(clk),             
      .rst(rst),                          
      .w(sram0_w),                          
      .cs(sram0_cs),                        
      .addr(sram0_addr),                    
      .data_in(data_in_i),                
      .data_out(sram0_out_i));            
                                                  
sram sram1_i(.clk(clk),            
      .rst(rst),                        
      .w(sram1_w),                        
      .cs(sram1_cs),                      
      .addr(sram1_addr),                  
      .data_in(sram1_in_i), 
      .data_out(sram1_out_i));          
                                                  
sram_w sram2_i(.clk(clk),            
      .rst(rst),                         
      .w(sram2_w),                         
      .cs(sram2_cs),                       
      .addr(sram2_addr),                   
      .data_in(data_w_i), 
      .data_out(sram2_out_i));           
                                                 
butterfly butterfly0(.clk(clk),
      .rst(rst),
      .k(k),
      .state(state),
      .cs(caldata_cs),
      .w(caldata_w),
      .caldata_in_r(sram1_out_r),
      .caldata_in_i(sram1_out_i),
      .caldata_w_r(sram2_out_r),
      .caldata_w_i(sram2_out_i),
      .caldata_out_r(caldata_out_r),
      .caldata_out_i(caldata_out_i));
             
control con1(
      .rst(rst),
      .clk(clk),
      .sram0_cs(sram0_cs),                    
      .sram1_cs(sram1_cs),
      .sram2_cs(sram2_cs),
      .sram0_w(sram0_w),
      .sram1_w(sram1_w),
      .sram2_w(sram2_w),
      .sram0_addr(sram0_addr),
      .sram1_addr(sram1_addr),
      .sram2_addr(sram2_addr),
      .k(k),
      .caldata_cs (caldata_cs),
      .sel(sel),
      .state(state),
      .caldata_w(caldata_w ));
 
endmodule