module zeroext5_32(in1,out1);
input [4:0] in1;
output [31:0] out1;
assign 	 out1 = {{ 27 {1'b0}}, in1};
endmodule