module Mux(
data1,
data2,
sel,
out
  );

input sel;
input signed [7:0]data1;
input signed [40:0]data2;
output signed [40:0]out;

assign out=sel==0?data1:data2;

endmodule