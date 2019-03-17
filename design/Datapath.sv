`timescale 1ns / 1ps
`include "pipe_reg_pkg.sv"
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
    output logic [DATA_W-1:0] Address//current address
    );

    logic [PC_W-1:0] PC, PCPlus4,PCAddress,pcmuxResult;
    logic [INS_W-1:0] Instr;
    logic [DATA_W-1:0] Result;
    logic [DATA_W-1:0] Reg1, Reg2;
    logic [DATA_W-1:0] ReadData;
    logic [DATA_W-1:0] SrcB, ALUResult;
    logic [DATA_W-1:0] NewAdd;
    logic Zero,BResult, noOp, if_idWrite, PCWrite, flush;
    logic [DATA_W-1:0] ExtImm;
    logic [DATA_W-1:0] famuxResult, fbmuxResult;
    logic [1:0] ForwardA, ForwardB;
    logic [DATA_W-1:0] OG_PC; 

//// Pipeline Register Instantiation
    
   if_id_reg_t if_id_reg; 
   id_ex_reg_t id_ex_reg;
   ex_mem_reg_t ex_mem_reg; 
   mem_wb_reg_t mem_wb_reg; 

// next PC
    adder #(9) pcadd (PC, 9'b100, PCPlus4); 

//// Mux that chooses next pc 
    mux3 pcmux(PCPlus4,ex_mem_reg.newAdd,ex_mem_reg.ALUResult,ex_mem_reg.Jump, Bresult,PCAddress);  
    assign Address = PCAddress/4;

//// PC
    flopr #(9) pcreg(clk, reset,PCWrite, PCAddress, PC);


 //Instruction memory
    instructionmemory instr_mem (PC, Instr);


//// IF/ID Pipeline Reg
   always_ff @(posedge clk, posedge reset) begin
     if (reset || flush) begin 
       if_id_reg.current <= 0; 
       if_id_reg.pc_next <= 0; 
       if_id_reg.instr <= 0;
       if_id_reg.rs1 <= 0;
       if_id_reg.rs2 <= 0;
     end
     else if (!if_idWrite) begin
       if_id_reg.current <= PC; 
       if_id_reg.pc_next <= PCPlus4; 
       if_id_reg.instr <= Instr;
       if_id_reg.rs1 <= Instr[19:15];
       if_id_reg.rs2 <= Instr[24:20];
     end 
   end 

    assign opcode = if_id_reg.instr[6:0];
    assign Funct7 = if_id_reg.instr[31:25];
    assign Funct3 = if_id_reg.instr[14:12];

//// Hazard Detection Unit 
    HazardDetection hazardunit(if_id_reg.rs1, if_id_reg.rs2, id_ex_reg.rd, id_ex_reg.MemRead, id_ex_reg.Branch, ex_mem_reg.Branch,  id_ex_reg.Jump, ex_mem_reg.Jump, noOp, if_idWrite, PCWrite, flush);   

      
// //Register File
    RegFile rf(clk, reset, mem_wb_reg.RegWrite, mem_wb_reg.rd, if_id_reg.instr[19:15], if_id_reg.instr[24:20],
            Result, Reg1, Reg2);
            

//// sign extend
    imm_Gen Ext_Imm (if_id_reg.instr,ExtImm);

////ID/EX Pipeline Reg

    always_ff @(posedge clk, posedge reset) //begin
      if (reset || flush) begin
        id_ex_reg.current <= 0;
        id_ex_reg.pc_next <= 0;
        id_ex_reg.rs1 <= 0;
        id_ex_reg.rs2 <= 0;
        id_ex_reg.Reg1 <= 0;
        id_ex_reg.Reg2 <= 0;
        id_ex_reg.extImm <= 0;
        id_ex_reg.funct3 <= 0;
        id_ex_reg.funct7 <= 0;
        id_ex_reg.rd <= 0;

        id_ex_reg.MemtoReg <= 0;
        id_ex_reg.Branch <= 0;
        id_ex_reg.RegWrite <= 0;
        id_ex_reg.MemWrite <= 0;
        id_ex_reg.MemRead <= 0;
        id_ex_reg.ALUsrc <= 0;
        id_ex_reg.ALU_CC <= 0;
        id_ex_reg.Jump <= 0;
        id_ex_reg.PCr <= 0;
        end
      else if (noOp) begin
        id_ex_reg.MemtoReg <= 0;
        id_ex_reg.Branch <= 0;
        id_ex_reg.RegWrite <= 0;
        id_ex_reg.MemWrite <= 0;
        id_ex_reg.MemRead <= 0;
        id_ex_reg.ALUsrc <= 0;
        id_ex_reg.ALU_CC <= 0;
        id_ex_reg.Jump <= 0;
        id_ex_reg.PCr <= 0;
        end    
        else begin
          id_ex_reg.current <= if_id_reg.current;
          id_ex_reg.pc_next <= if_id_reg.pc_next;
          id_ex_reg.rs1 <= if_id_reg.rs1;
          id_ex_reg.rs2 <= if_id_reg.rs2;
          id_ex_reg.Reg1 <= Reg1;
          id_ex_reg.Reg2 <= Reg2;
          id_ex_reg.extImm <= ExtImm;
          id_ex_reg.funct3 <= Funct3;
          id_ex_reg.funct7 <= Funct7;
          id_ex_reg.rd <= if_id_reg.instr[11:7];

          id_ex_reg.MemtoReg <= MemtoReg;
          id_ex_reg.Branch <= Branch;
          id_ex_reg.RegWrite <= RegWrite;
          id_ex_reg.MemWrite <= MemWrite;
          id_ex_reg.MemRead <= MemRead;
          id_ex_reg.MemtoReg <= MemtoReg;
          id_ex_reg.ALUsrc <= ALUsrc;
          id_ex_reg.ALU_CC <= ALU_CC;
          id_ex_reg.Jump <= Jump;
          id_ex_reg.PCr <= PCr;
        end
        //end

//// Forwarding Unit
   ForwardingUnit fwdunit(ex_mem_reg.rd,mem_wb_reg.rd, id_ex_reg.rs1, id_ex_reg.rs2 ,ex_mem_reg.RegWrite, mem_wb_reg.RegWrite,ForwardA, ForwardB);  


//// Forwarding MUXs 
    fwdmux fwdamux (id_ex_reg.Reg1,Result, ex_mem_reg.ALUResult, ForwardA[0], ForwardA[1], famuxResult); 
    fwdmux fwdbmux (id_ex_reg.Reg2,Result, ex_mem_reg.ALUResult, ForwardB[0], ForwardB[1], fbmuxResult); 
    

//// ALU
    mux2 #(32) srcbmux(fbmuxResult, id_ex_reg.extImm, id_ex_reg.ALUsrc, SrcB);
    alu alu_module(famuxResult, SrcB, id_ex_reg.ALU_CC, ALUResult, Zero);
    adder1 newpcadd(id_ex_reg.current,id_ex_reg.extImm,NewAdd);  
   

//// EX/MEM Pipeline Reg
   always_ff @(posedge clk, posedge reset) begin
     if (reset) begin 
       ex_mem_reg.pc_next <= 0;
       ex_mem_reg.newAdd <= 0; 
       ex_mem_reg.ALUResult <= 0;
       ex_mem_reg.rs2 <= 0;
       ex_mem_reg.rd <= 0;
       ex_mem_reg.funct3 <= 0; 

       ex_mem_reg.RegWrite <= 0;
       ex_mem_reg.Branch <= 0;
       ex_mem_reg.Zero <= 0;
       ex_mem_reg.MemWrite <= 0;
       ex_mem_reg.MemRead <= 0;
       ex_mem_reg.MemtoReg <= 0;
       ex_mem_reg.Jump <= 0;
       ex_mem_reg.PCr <= 0;
     end
     else begin
       ex_mem_reg.pc_next <= id_ex_reg.pc_next;
       ex_mem_reg.newAdd <= NewAdd; 
       ex_mem_reg.ALUResult <= ALUResult;
       ex_mem_reg.rs2 <= fbmuxResult;
       ex_mem_reg.rd <= id_ex_reg.rd;
       ex_mem_reg.funct3 <= id_ex_reg.funct3;

       ex_mem_reg.RegWrite <= id_ex_reg.RegWrite;
       ex_mem_reg.Branch <= id_ex_reg.Branch;
       ex_mem_reg.Zero <= Zero;
       ex_mem_reg.MemWrite <= id_ex_reg.MemWrite;
       ex_mem_reg.MemRead <= id_ex_reg.MemRead;
       ex_mem_reg.MemtoReg <= id_ex_reg.MemtoReg;
       ex_mem_reg.Jump <= id_ex_reg.Jump;
       ex_mem_reg.PCr <= id_ex_reg.PCr;
     end 
   end

//// Branch Control
    and1  andb(ex_mem_reg.Branch, ex_mem_reg.Zero, Bresult);
  
////// Data memory 
	datamemory data_mem (clk, ex_mem_reg.MemRead, ex_mem_reg.MemWrite, ex_mem_reg.funct3, ex_mem_reg.ALUResult[DM_ADDRESS-1:0], ex_mem_reg.rs2, ReadData);
 
//// MEM/WB Pipeline Reg

   always_ff @(posedge clk, posedge reset) begin
    if (reset) begin 

      mem_wb_reg.pc_next <= 0; 
      mem_wb_reg.ALUResult <= 0;
      mem_wb_reg.newAdd <= 0; 
      mem_wb_reg.ReadData <= 0;
      mem_wb_reg.rd <= 0;

      mem_wb_reg.MemtoReg <= 0;
      mem_wb_reg.RegWrite <= 0;
      mem_wb_reg.PCr <= 0;
      mem_wb_reg.Branch <= 0;
      mem_wb_reg.Bresult <= 0;
      mem_wb_reg.Jump <= 0;
      end
      else begin
        mem_wb_reg.pc_next <= ex_mem_reg.pc_next;
        mem_wb_reg.ALUResult <= ex_mem_reg.ALUResult;
        mem_wb_reg.newAdd <= ex_mem_reg.newAdd;
        mem_wb_reg.ReadData <= ReadData;
        mem_wb_reg.rd <= ex_mem_reg.rd;

        mem_wb_reg.Jump <= ex_mem_reg.Jump;
        mem_wb_reg.MemtoReg <= ex_mem_reg.MemtoReg;
        mem_wb_reg.RegWrite <= ex_mem_reg.RegWrite;
        mem_wb_reg.PCr <= ex_mem_reg.PCr;
        mem_wb_reg.Branch <= ex_mem_reg.Branch;
        mem_wb_reg.Bresult <= Bresult;
      end
      end

//// Write Back MUX 
     //chooses whether aluresult, data from mem, pc+4, or auipc gets written back        
    mux4 resmux(mem_wb_reg.ALUResult, mem_wb_reg.ReadData, mem_wb_reg.pc_next, mem_wb_reg.newAdd, mem_wb_reg.PCr, mem_wb_reg.MemtoReg, Result);

    assign WB_Data = Result;


endmodule
