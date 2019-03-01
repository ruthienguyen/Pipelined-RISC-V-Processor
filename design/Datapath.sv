`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:10:33 PM
// Design Name: 
// Module Name: Datapath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Datapath #(
    parameter PC_W = 9, // Program Counter
    parameter INS_W = 32, // Instruction Width
    parameter RF_ADDRESS = 5, // Register File Address
    parameter DATA_W = 32, // Data WriteData
    parameter DM_ADDRESS = 9, // Data Memory Address
    parameter ALU_CC_W = 4 // ALU Control Code Width
    )(
    input logic clk , reset , // global clock
                              // reset , sets the PC to zero
    RegWrite , MemtoReg ,     // Register file writing enable   // Memory or ALU MUX
    ALUsrc , MemWrite ,       // Register file or Immediate MUX // Memroy Writing Enable
    MemRead , Branch               // Memroy Reading Enable // branch taken or not
    , Jump, PCr,                   //jal or jalr // pc+4 needs to be stored
    input logic [ ALU_CC_W -1:0] ALU_CC, // ALU Control Code ( input of the ALU )
    output logic [6:0] opcode,
    output logic [6:0] Funct7,
    output logic [2:0] Funct3,
    output logic [DATA_W-1:0] WB_Data,//ALU_Result
    output logic [DATA_W-1:0] Address,//ALU_Result
    output logic [DATA_W-1:0] newadd,//ALU_Result
    output logic J,Br,Z,B //ALU_Result

    );

logic [PC_W-1:0] PC, PCPlus4,PCAddress;
logic [INS_W-1:0] Instr;
logic [DATA_W-1:0] Result;
logic [DATA_W-1:0] Reg1, Reg2;
logic [DATA_W-1:0] ReadData;
logic [DATA_W-1:0] SrcB, ALUResult;
logic [DATA_W-1:0] NewAdd;
logic Zero,BResult;
logic [DATA_W-1:0] ExtImm;
logic count; 

// next PC
    adder #(9) pcadd (PC, 9'b100, PCPlus4);
    flopr #(9) pcreg(clk, reset, PCAddress, PC);
    

 //Instruction memory
    instructionmemory instr_mem (PC, Instr);
    
    assign opcode = Instr[6:0];
    assign Funct7 = Instr[31:25];
    assign Funct3 = Instr[14:12];
      
// //Register File
    RegFile rf(clk, reset, RegWrite, Instr[11:7], Instr[19:15], Instr[24:20],
            Result, Reg1, Reg2);
            
    //chooses whether aluresult, data from mem, pc+4, or auipc gets written back        
    mux4 resmux(ALUResult, ReadData, PCPlus4,  NewAdd, PCr, MemtoReg, Result);

//// sign extend
    imm_Gen Ext_Imm (Instr,ExtImm);

//// ALU
    mux2 #(32) srcbmux(Reg2, ExtImm, ALUsrc, SrcB);
    alu alu_module(Reg1, SrcB, ALU_CC, ALUResult, Zero);
    and1  andb(Branch, Zero, Bresult); 
    adder1 newpcadd(PC,ExtImm,NewAdd); 
    mux3 pcmux(PCPlus4,NewAdd, ALUResult,Jump,Bresult,PCAddress); 
   
    assign newadd = NewAdd/4; 
    assign J = Jump; 
    assign Br = Bresult;
    assign Z = Zero;
    assign B = Branch; 
    assign WB_Data = Result;
    assign Address = PCAddress/4;
    
////// Data memory 
	datamemory data_mem (clk, MemRead, MemWrite,Funct3, ALUResult[DM_ADDRESS-1:0], Reg2, ReadData);
     
endmodule
