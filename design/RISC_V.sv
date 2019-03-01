`timescale 1ns / 1ps

module riscv #(
    parameter DATA_W = 32)
    (input logic clk, reset, // clock and reset signals
    output logic [31:0] WB_Data,// The ALU_Result
    output logic [31:0] Address// The ALU_Result
    );

logic [6:0] opcode;
logic ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump;

logic [1:0] ALUop;
logic [6:0] Funct7;
logic [2:0] Funct3;
logic [3:0] Operation;

    Controller c(opcode, ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, Jump, ALUop);

//    BranchController bc(opcode,Funct3, Operation); 
    
    ALUController ac(ALUop, Funct7, Funct3, Operation);

    Datapath dp(clk, reset, RegWrite , MemtoReg, ALUSrc , MemWrite, MemRead, Branch, Jump,Operation, opcode, Funct7, Funct3, WB_Data, Address);
        
endmodule
