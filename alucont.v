module alucont(aluop1,aluop0,fun, f3,f2,f1,f0,gout);//Figure 4.12 
input aluop1,aluop0,f3,f2,f1,f0;
input [5:0] fun;
output [2:0] gout;
reg [2:0] gout;
always @(aluop1 or aluop0 or f3 or f2 or f1 or f0)
begin
if(~(aluop1|aluop0))  gout=3'b010; // Load and Store word

if(aluop0 & aluop1) // J-type
begin
	if (fun[5] & ~fun[4] & ~fun[3] & ~fun[2] & ~fun[1] & ~fun[0])gout=3'b010; //function code=100000,ALU control=010 (add)
	if (fun[5] & ~fun[4] & fun[3] & ~fun[2] & fun[1] & ~fun[0])gout=3'b111;    //function code=101010,ALU control=111 (set on less than)
	if (fun[5] & ~fun[4] & ~fun[3] & ~fun[2] & fun[1] & ~fun[0])gout=3'b110;  //function code=100010,ALU control=110 (sub)
	if (fun[5] & ~fun[4] & ~fun[3] & fun[2] & ~fun[1] & fun[0])gout=3'b001;	  //function code=100101,ALU control=001 (or)
	if (fun[5] & ~fun[4] & ~fun[3] & fun[2] & ~fun[1] & ~fun[0])gout=3'b000;  //function code=100100,ALU control=000 (and)
end


if(aluop0 & ~aluop1) // I-type
begin
	if (fun[5] & ~fun[4] & ~fun[3] & ~fun[2] & ~fun[1] & ~fun[0])gout=3'b010; //function code=100000,ALU control=010 (add)
	if (fun[5] & ~fun[4] & fun[3] & ~fun[2] & fun[1] & ~fun[0])gout=3'b111;    //function code=101010,ALU control=111 (set on less than)
	if (fun[5] & ~fun[4] & ~fun[3] & ~fun[2] & fun[1] & ~fun[0])gout=3'b110;  //function code=100010,ALU control=110 (sub)
	if (fun[5] & ~fun[4] & ~fun[3] & fun[2] & ~fun[1] & fun[0])gout=3'b001;	  //function code=100101,ALU control=001 (or)
	if (fun[5] & ~fun[4] & ~fun[3] & fun[2] & ~fun[1] & ~fun[0])gout=3'b000;  //function code=100100,ALU control=000 (and)
end

if(aluop1 & ~aluop0)//R-type
begin
	if (~fun[5] & ~fun[4] & ~fun[3] & ~fun[2] & ~fun[1] & ~fun[0]) gout=3'b101; 	//function code=000000,ALU control=101 (sll)
	if (fun[5] & ~fun[4] & ~fun[3] & ~fun[2] & ~fun[1] & ~fun[0]) gout=3'b010; 	//function code=100000,ALU control=010 (add)
	if (fun[5] & ~fun[4] & fun[3] & ~fun[2] & fun[1] & ~fun[0]) gout=3'b111;    //function code=101010,ALU control=111 (set on less than)
	if (fun[5] & ~fun[4] & ~fun[3] & ~fun[2] & fun[1] & ~fun[0]) gout=3'b110;  	//function code=100010,ALU control=110 (sub)
	if (fun[5] & ~fun[4] & ~fun[3] & fun[2] & ~fun[1] & fun[0]) gout=3'b001;	//function code=100101,ALU control=001 (or)
	if (fun[5] & ~fun[4] & ~fun[3] & fun[2] & ~fun[1] & ~fun[0]) gout=3'b000;  	//function code=100100,ALU control=000 (and)
end
end
endmodule
