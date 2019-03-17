`ifndef PIPE_DONE 
`define PIPE_DONE

package pipe_reg_pkg; 

  typedef struct packed{ 
    logic [8:0] current; 
    logic [8:0] pc_next; 
    logic [31:0] instr;
    logic [4:0] rs1; 
    logic [4:0] rs2; 
  } if_id_reg_t; 

  
  typedef struct packed{ 
    logic [8:0] current; 
    logic [8:0] pc_next; 
    logic [4:0] rs1;
    logic [4:0] rs2; 
    logic [31:0] Reg1; 
    logic [31:0] Reg2; 
    logic [31:0] extImm; 
    logic [2:0] funct3; 
    logic [6:0] funct7; 
    logic [4:0] rd;
    logic MemtoReg, Branch, RegWrite, MemWrite, MemRead, ALUsrc, Jump, PCr;
    logic [3:0] ALU_CC;
  } id_ex_reg_t;


  typedef struct packed{
    logic [8:0] pc_next; 
    logic [31:0] newAdd; 
    logic [31:0] ALUResult;
    logic [31:0] rs2; 
    logic [4:0] rd;
    logic [2:0] funct3; 
    logic RegWrite, Branch, Zero, MemWrite, MemRead,MemtoReg,Jump, PCr; 
  } ex_mem_reg_t; 


  typedef struct packed{ 
    logic [8:0] pc_next;
    logic [31:0] ReadData; 
    logic [31:0] newAdd;
    logic [31:0] ALUResult;
    logic [4:0] rd; 
    logic MemtoReg, RegWrite,PCr, Branch, Bresult, Jump; 
  } mem_wb_reg_t; 

endpackage

import pipe_reg_pkg::*; 

`endif
