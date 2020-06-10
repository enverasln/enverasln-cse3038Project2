module processor;
reg [31:0] pc; //32-bit prograom counter
reg clk; //clock
reg [7:0] datmem[0:31],mem[0:31]; //32-size data and instruction memory (8 bit(1 byte) for each location)
wire [31:0] 
dataa,	//Read data 1 output of Register File
datab,	//Read data 2 output of Register File
out2,		//Output of mux with ALUSrc control-mult2
out3,		//Output of mux with MemToReg control-mult3
out4,		//Output of mux with (Branch&ALUZero) control-mult4
out5,		//Output of mux with zext control-mult5
out6,		//Output of mux with ext[1] for sll
out7,
sum,		//ALU result
extad,	//Output of sign-extend unit
zextad, //Output of zero-extend unit
exshad, //Output of extented shift amount unit
adder1out,	//Output of adder which adds PC and 4-add1
adder2out,	//Output of adder which adds PC+4 and 2 shifted sign-extend result-add2
sextad;	//Output of shift left 2 unit


wire [5:0] inst31_26;	//31-26 bits of instruction
wire [4:0] 
inst25_21,	//25-21 bits of instruction
inst20_16,	//20-16 bits of instruction
inst15_11,	//15-11 bits of instruction
out1,		//Write data input of Register File
out8;

wire [15:0] inst15_0;	//15-0 bits of instruction

wire [31:0] instruc,	//current instruction
dpack;	//Read data output of memory (data read from memory)

wire [2:0] gout;	//Output of ALU control unit
wire [1:0] jbout;

wire zout,	//Zero output of ALU
pcsrc,	//Output of AND gate with Branch and ZeroOut inputs
//Control signals
regdest,alusrc,memtoreg,regwrite,memread,memwrite,aluop1,aluop0,stswrite;
wire [1:0] ext;
wire [2:0] branch_jump;
wire [5:0] fout;

reg flag=1'b0;

wire [2:0] status;
//32-size register file (32 bit(1 word) for each register)
reg [31:0] registerfile[0:31];

integer i;

// datamemory connections

always @(posedge clk)
//write data to memory
if (memwrite)
begin 
//sum stores address,datab stores the value to be written
datmem[sum[4:0]+3]=datab[7:0];
datmem[sum[4:0]+2]=datab[15:8];
datmem[sum[4:0]+1]=datab[23:16];
datmem[sum[4:0]]=datab[31:24];
end

//instruction memory
//4-byte instruction
 assign instruc={mem[pc[4:0]],mem[pc[4:0]+1],mem[pc[4:0]+2],mem[pc[4:0]+3]};
 assign inst31_26=instruc[31:26];
 assign inst25_21=instruc[25:21];
 assign inst20_16=instruc[20:16];
 assign inst15_11=instruc[15:11];
 assign inst15_0=instruc[15:0];


// registers

assign dataa=registerfile[inst25_21];//Read register 1
assign datab=registerfile[inst20_16];//Read register 2
always @(posedge clk)
begin
	flag=1'b1;
	registerfile[out1]= regwrite ? out7:registerfile[out1];//Write data to register
end

//read data from memory, sum stores address
assign dpack={datmem[sum[5:0]],datmem[sum[5:0]+1],datmem[sum[5:0]+2],datmem[sum[5:0]+3]};

//multiplexers
//mux with RegDst control
mult2_to_1_5  mult1(out1, instruc[20:16],out8,regdest);

//mux with ALUSrc control
mult2_to_1_32 mult2(out2, datab,out5,alusrc);


mult2_to_1_32 mult6(out6, dataa,datab, ext[1]);

mult2_to_1_32 mult7(out7, out3, adder1out, (~branch_jump[2] & branch_jump[1] & ~branch_jump[0]) | (branch_jump[2] & ~branch_jump[1] & ~branch_jump[0]));

mult2_to_1_5 mult8(out8, instruc[15:11], 5'b11111,(~branch_jump[2] & branch_jump[1] & ~branch_jump[0]) | (branch_jump[2] & ~branch_jump[1] & ~branch_jump[0]));

//mux with ext control
mult4_to_1_32 mult5(out5, extad, zextad, exshad, exshad,ext[0], ext[1]);

//mux with MemToReg control
mult2_to_1_32 mult3(out3, sum,dpack,memtoreg);

//mux with (Branch&ALUZero) control
//mult2_to_1_32 mult4(out4, adder1out,adder2out,pcsrc);

mult4_to_1_32 mult4(out4, adder1out, adder2out, out3, {adder1out[31:28],instruc[25:0],2'b00}, jbout[0], jbout[1]); 

// load pc

// alu, adder and control logic connections

//ALU unit
alu32 alu1(sum,out6,out2,status,gout,stswrite);

//adder which adds PC and 4
adder add1(pc,32'h4,adder1out);

//adder which adds PC+4 and 2 shifted sign-extend result
adder add2(adder1out,sextad,adder2out);

//Control unit
control cont(instruc[31:26],instruc[5:0],regdest,alusrc,ext,memtoreg,regwrite,memread,memwrite,branch_jump,
aluop1,aluop0,fout,stswrite);

//Sign extend unit
signext sext(instruc[15:0],extad);

//Zero extend unit
zeroext zext(instruc[15:0],zextad);

//Zero extend unit 5 to 32
zeroext5_32 zext_5_32(instruc[10:6],exshad);

//ALU control unit
alucont acont(aluop1,aluop0,fout,gout);

//Shift-left 2 unit
shift shift2(sextad,extad);

jbcontrol jncon(jbout, branch_jump, status);
//AND gate
//assign pcsrc=branch && zout; branch and jump eklecenecek

//initialize datamemory,instruction memory and registers
//read initial data from files given in hex
always @(negedge clk & flag)
pc=out4;
initial
begin
$readmemh("initDm.dat",datmem); //read Data Memory
$readmemh("initIM.dat",mem);//read Instruction Memory
$readmemh("initReg.dat",registerfile);//read Register File

	for(i=0; i<31; i=i+1)
	$display("Instruction Memory[%0d]= %h  ",i,mem[i],"Data Memory[%0d]= %h   ",i,datmem[i],
	"Register[%0d]= %h",i,registerfile[i]);
end

initial
begin
pc=0;
#400 $finish;
	
end
initial
begin
clk=0;
//40 time unit for each cycle
forever #20  clk=~clk;
end
initial 
begin
  $monitor($time,"PC %h",pc,"  SUM %h",sum,"   INST %h",instruc[31:0],
"   REGISTER %h %h %h %h ",registerfile[4],registerfile[5], registerfile[6],registerfile[1] );
end
endmodule

