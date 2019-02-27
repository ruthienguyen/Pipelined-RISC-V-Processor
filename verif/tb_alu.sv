`timescale 1ns / 1ps

module tb_alu;

//clock and reset signal declaration
  logic [3:0] Operation;
  logic [31:0] SrcA;
  logic [31:0] SrcB;
  logic [31:0] ALUResult;
  logic Zero;
//   logic tb_clk, reset;
//   logic [31:0] tb_WB_Data;
  
    //clock generation
//   always #10 tb_clk = ~tb_clk;
  
  alu myALU(
      .SrcA(SrcA),
      .SrcB(SrcB),
      .Operation(Operation),
      .Zero(Zero),
      .ALUResult(ALUResult)
  );
  //reset Generation
  initial begin
    $display("begin ALU test \n");
    $display("\"Works: 0\" means it worked\n");

    SrcA = 32'b00010001001111000010110111100100;
    SrcB = 32'b11111011000010110100100001110111;

    #5 Operation = 4'b0000; // AND
    #5 $display("%b AND %b = %b; Works:", SrcA, SrcB, ALUResult, ALUResult - (SrcA & SrcB));

    #5 Operation = 4'b0001; // OR
    #5 $display("%b OR %b = %b; Works:", SrcA, SrcB, ALUResult, ALUResult - (SrcA | SrcB));

    #5 Operation = 4'b0010; // ADD
    #5 $display("%b ADD %b = %b; Works:", SrcA, SrcB, ALUResult, ALUResult - (SrcA + SrcB));

    #5 Operation = 4'b0011; // XOR
    #5 $display("%b XOR %b = %b; Works:", SrcA, SrcB, ALUResult, ALUResult - (SrcA ^ SrcB));

    #5 Operation = 4'b0110; // SUB
    #5 $display("%b SUB %b = %b; Works:", SrcA, SrcB, ALUResult, ALUResult - ($signed(SrcA) - $signed(SrcB)));

    #5 Operation = 4'b0111; // SLL
    SrcB = 32'b00000000000000000000000000001010;
    #5 $display("%b SHIFT LEFT LOGICAL %b = %b; Works:", SrcA, SrcB, ALUResult, ALUResult - (SrcA << 10)); //not sure if we should be using 10...?

    #5 Operation = 4'b1000; // SRL
    SrcB = 32'b00000000000000000000000000001010;
    #5 $display("%b SHIFT RIGHT LOGICAL %b = %b; Works:", SrcA, SrcB, ALUResult, ALUResult - (SrcA >> 10));

    #5 Operation = 4'b1001; // SLT
    #5 $display("%b COMP SIGNED %b = %b; Works:", SrcA, SrcB, ALUResult, ALUResult - 1'bx);

    #5 Operation = 4'b1010; // SLTU
    #5 $display("%b COMP UNSIGNED %b = %b; Works:", SrcA, SrcB, ALUResult, ALUResult - 1'bx);

    #5 Operation = 4'b1011; // SRA
    SrcA = 32'b11111011000010110100100001110111;
    #5 $display("%b SHIFT RIGHT ARITHMETIC %b = %b; Works:", SrcA, SrcB, ALUResult, $signed(ALUResult) - ($signed(SrcA) >>> 10));

    #100 $stop;

  end
  
  
//   riscv riscV(
//       .clk(tb_clk),
//       .reset(reset),
//       .WB_Data(tb_WB_Data)      
//      );

//   initial begin
//     $readmemh ( "$verif/program/inst.bin" , riscV.dp.instr_mem.Inst_mem);
//     #1000;
//     $finish;
//    end
endmodule
