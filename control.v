module control(in,fun,regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop1,aluop2);
input [5:0] in, fun;
output regdest,alusrc,memtoreg,regwrite,memread,memwrite,branch,aluop1,aluop2;
wire rformat,iformat,jformat,lw,sw,beq,ori,bltz,jmsub,baln,jrs,sll;

// Define the R-Type instructions jmsub
assign jmsub=(fun[5]) & (~fun[4]) & (~fun[3]) & (~fun[2]) & (fun[1]) & (~fun[0]);
assign sll=(~fun[5]) & (~fun[4]) & (~fun[3]) & (~fun[2]) & (~fun[1]) & (~fun[0]);
assign rformat=~|in;

// Define the I-Type instructions ori, bltz
assign lw=(in[5]) & (~in[4]) &(~in[3]) & (~in[2]) & (in[1]) & (in[0]);
assign sw=(in[5]) & (~in[4]) & (in[3]) & (~in[2]) & (in[1]) & (in[0]);
assign beq=(~in[5] )& (~in[4]) &(~in[3]) & (in[2]) & (~in[1]) & (~in[0]);
assign ori=(~in[5]) & (~in[4]) &(in[3]) & (in[2]) & (~in[1]) & (in[0]);
assign bltz=(~in[5]) & (~in[4]) &(~in[3]) & (~in[2]) & (~in[1]) & (in[0]);
assign jrs=(~in[5]) & (in[4]) & (~in[3]) & (~in[2]) & (in[1]) & (~in[0]);
assign iformat = beq|ori|bltz;

// Define the J-type instruction baln
assign baln=(~in[5]) & (in[4]) & (in[3]) & (~in[2]) & (in[1]) & (in[0]);
assign jformat = baln;
assign regdest=rformat;
assign alusrc=lw|sw;
assign memtoreg=lw;
assign regwrite=rformat|lw;
assign memread=lw;
assign memwrite=sw;
assign branch=beq;
assign aluop1=rformat | jformat;
assign aluop2=iformat | jformat;
endmodule
