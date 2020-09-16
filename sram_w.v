module sram_w(
input clk,w,rst,cs,
input [11:0]addr,
input [7:0]data_in,
output reg [7:0]data_out
  );

reg signed [7:0]memory[2047:0];//动态参数

always@(posedge clk,negedge rst)
  begin
    if(!rst)
      data_out<=8'd0;
	  else 
      case(cs)
        1:begin
          if(w==1)
            memory[addr]<=data_in;
          else 
            data_out<=memory[addr];
          end
        default:;
        endcase
  end

endmodule              