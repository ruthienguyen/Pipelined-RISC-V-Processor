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
  
    //clock generation
  always #10 tb_clk = ~tb_clk;
  
  //reset Generation
  initial begin
    tb_clk = 0;
    reset = 1;
    #25 reset =0;
  end
  
  
/*  riscv riscV(
      .clk(tb_clk),
      .reset(reset),
      .WB_Data(tb_WB_Data)      
     );*/

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
/*
    ALUController ac(
    .ALUop(ALUop),
    .Funct7(Funct7),
    .Funct3(Funct3),
    .Operation(Operation));

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

  initial begin
   // $readmemh ( "$verif/program/inst.bin" , riscV.dp.instr_mem.Inst_mem);

   /* $display("ALUResult: %h, Zero: %b \n", ALUResult, Zero); 
    $display("Branch: %b, Zero: %b, Bresult: %b \n", Branch, Zero,Bresult); 
    $display("PC: %b, ExtImm: %h, NewAdd: %b\n", PC, ExtImm, NewAdd); 
    $display("PCPlus4: %b, NewADD: %b, ALUResult: %b, Jump %b, Bresult %b, PCAddress %b \n", PCPlus4, NewAdd, ALUResult, Jump, Bresult, PCAddress); 
   = 32'h00311733;//     sll r14, r2, r3          ALUResult = h20 = r14
  opcode =  Inst_mem [ra[INS_ADDRESS-1:2]];  
  assign Inst_mem[1] = 32'h00c50a63;//     beq x12, x10, 20         ALUResult = 00000000        branch taken to inst_mem[34] 
  assign Inst_mem[2] = 32'h0072c7b3;//     xor r15, r5, r7          ALUResult = hc = r15
  assign Inst_mem[3] = 32'h00235833;//     srl r16, r6, r2          ALUResult = h2 = r16
  assign Inst_mem[4] = 32'h4034d8b3;//     sra r17, r9, r3          ALUResult = hffffffff = r17

  assign Inst_mem[5] = 32'h000586e7;//     jalr x13, 0(x11)           ALUResult = h88               
  */
  #5 opcode = 7'b1100011; //beq
  #5 $display( " ALUSrc=%b, MemtoReg=%b,RegWrite=%b, MemRead=%b, MemWrite=%b, Branch=%b, Jump=%b, ALUop = %b \n" ,ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUop);

   #100;
    $stop;
   end
endmodule
