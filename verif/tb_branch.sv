`timescale 1ns / 1ps

module tb_branch;

//clock and reset signal declaration
  logic tb_clk, reset;
  logic [31:0] WB_Data;
  logic [6:0] opcode;
  logic ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump;

  logic [1:0] ALUop;
  logic [6:0] Funct7;
  logic [2:0] Funct3;
  logic [3:0] Operation;
  logic [9-1:0] PC, PCPlus4,NewAdd,PCAddress;
  logic [32-1:0] Instr;
  logic [32-1:0] Result;
  logic [32-1:0] Reg1, Reg2;
  logic [32-1:0] ReadData;
  logic [32-1:0] SrcB, ALUResult;
  logic Zero,Bresult;
  logic [32-1:0] ExtImm;
  logic count; 
  
    //clock generation
  always #10 tb_clk = ~tb_clk;
  
  //reset Generation
/*  initial begin
    tb_clk = 0;
    reset = 1;
    #25 reset =0;
  end
  */
  
/*  riscv riscV(
      .clk(tb_clk),
      .reset(reset),
      .WB_Data(tb_WB_Data)      
     );*/
/*
    Controller c(
    .opcode(opcode), 
    .ALUSrc(ALUSrc),
    .MemtoReg(MemtoReg),
    .RegWrite(RegWrite),
    .MemRead(MemRead),
    .MemWrite(MemRead),
    .Branch(Branch),
    .Jump(Jump),
    .ALUop(Aluop));
    */
/*
    ALUController ac(
    .ALUOp(ALUop),
    .Funct7(Funct7),
    .Funct3(Funct3),
    .Operation(Operation));*/
/*
    Datapath dp(
    .clk,
    .reset,
    .RegWrite,
    .MemtoReg,
    .ALUSrc ,
    .MemWrite,
    .MemRead,
    .Branch,
    .Jump,
    .Operation,
    .opcode,
    .Funct7,
    .Funct3,
    .WB_Data);*/
    /*
    adder1 newpcadd(
    .a(PC),
    .b(ExtImm),
    .y(NewAdd)); 
    */
    
    mux3 pcmux(
    .d0(PCPlus4),
    .d1(NewAdd),
    .d2(ALUResult),
    .s1(Jump),
    .s0(Bresult),
    .y(PCAddress)); 

    

  initial begin
   // $readmemh ( "$verif/program/inst.bin" , riscV.dp.instr_mem.Inst_mem);
/*
  #5 ALUop = 2'b10; //sub
  #5 Funct7 = 7'b0100000; 
  #5 Funct3 = 3'b000; 
  #5 $display(" SUB operation: %b", Operation); 


  #5 ALUop = 2'b10; //or
  #3 Funct7 = 7'b000000; 
  #3 Funct3 = 3'b110; 
  #5 $display(" OR operation: %b", Operation); 
*/
  
  $display("STARTING TEST"); 
  /*
  #5 PC = 9'b0100; 
  #5 ExtImm = 32'b10100; 
  #5 $display("NewADD: %b", NewAdd); 
*/

  #5 PCPlus4 = 9'b0100; 
  #5 NewAdd = 9'b11000; 
  #5 ALUResult = 32'b1100; 
  #5 $display("PC+4: %b", PCPlus4);  
  #5 $display("NewAdd: %b", NewAdd);  
  #5 $display("ALU: %b", ALUResult);  

  #5 Jump = 1'b0; 
  #5 Bresult = 1'b0; 
  #5 $display("Jump & B: %b,%b", Jump, Bresult);  
  #5 $display("PCadd: %b", PCAddress);  

  #5 Jump = 1'b0; 
  #5 Bresult = 1'b1; 
  #5 $display("Jump & B: %b,%b", Jump, Bresult);  
  #5 $display("PCadd: %b", PCAddress);  

  #5 Jump = 1'b1; 
  #5 Bresult = 1'b0; 
  #5 $display("Jump & B: %b,%b", Jump, Bresult);  
  #5 $display("PCadd: %b", PCAddress);  
   #100;
    $stop;
   end
endmodule
