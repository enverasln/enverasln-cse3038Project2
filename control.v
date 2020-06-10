module control(in,fun,regdest,alusrc,ext,memtoreg,regwrite,memread,memwrite,branch_jump,aluop1,aluop2, fout, stswrite);
input [5:0] in, fun;
output regdest,alusrc,memtoreg,regwrite,memread,memwrite,aluop1,aluop2;
output [5:0] fout;
output [1:0] ext;
output [2:0] branch_jump;
output stswrite;
wire rformat,iformat,jformat,lw,sw,beq,ori,bltz,jmsub,baln,jrs,sll;

// Define the R-Type instructions jmsub
assign jmsub=(fun[5]) & (~fun[4]) & (~fun[3]) & (~fun[2]) & (fun[1]) & (~fun[0]);
assign sll=((~fun[5]) & (~fun[4]) & (~fun[3]) & (~fun[2]) & (~fun[1]) & (~fun[0])) & ~iformat & ~lw & ~sw;
assign rformat=~|in;

// Define the I-Type instructions ori, bltz
assign lw=(in[5]) & (~in[4]) &(~in[3]) & (~in[2]) & (in[1]) & (in[0]);
assign sw=(in[5]) & (~in[4]) & (in[3]) & (~in[2]) & (in[1]) & (in[0]);
assign beq=(~in[5] )& (~in[4]) &(~in[3]) & (in[2]) & (~in[1]) & (~in[0]);
assign ori=(~in[5]) & (~in[4]) &(in[3]) & (in[2]) & (~in[1]) & (in[0]);
assign bltz=(~in[5]) & (~in[4]) &(~in[3]) & (~in[2]) & (~in[1]) & (in[0]);
assign jrs=(~in[5]) & (in[4]) & (~in[3]) & (~in[2]) & (in[1]) & (~in[0]);
assign iformat = beq|ori|bltz|jrs;

// Define the J-type instruction baln
assign baln=(~in[5]) & (in[4]) & (in[3]) & (~in[2]) & (in[1]) & (in[0]);
assign jformat = baln;
assign regdest=rformat|baln;
assign alusrc=lw|sw|ori|sll;
assign ext={sll ? 1'b1 : 1'b0, ori ? 1'b1 : 1'b0};
assign memtoreg=lw|jmsub|jrs;
assign regwrite=rformat|lw|ori|sll|jmsub|baln;
assign memread=lw|jmsub|jrs;
assign memwrite=sw;
assign branch_jump = beq ? 3'b000 : bltz ? 3'b001 : baln ? 3'b010 : jmsub ? 3'b100 : jrs ? 3'b101 : 3'b111;
assign aluop1=rformat | jformat;
assign aluop2=iformat | jformat;

assign fout= ori ? 6'b100101 : bltz ? 6'b100010 : jrs ? 6'b100000 : fun;

assign stswrite=~baln; // Status write sginal


endmodule
