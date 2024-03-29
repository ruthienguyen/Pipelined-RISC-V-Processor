`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:10:33 PM
// Design Name: 
// Module Name: Controller
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

module Controller(
    
    //Input
    input logic [6:0] Opcode, //7-bit opcode field from the instruction
    
    //Outputs
    output logic ALUSrc,//0: The second ALU operand comes from the second register file output (Read data 2); 
                  //1: The second ALU operand is the sign-extended, lower 16 bits of the instruction.
    output logic MemtoReg, //0: The value fed to the register Write data input comes from the ALU.
                     //1: The value fed to the register Write data input comes from the data memory.
    output logic RegWrite, //The register on the Write register input is written with the value on the Write data input 
    output logic MemRead,  //Data memory contents designated by the address input are put on the Read data output
    output logic MemWrite, //Data memory contents designated by the address input are replaced by the value on the Write data input.
    output logic Branch,  //0: branch is not taken; 1: branch is taken
    output logic Jump,    //0: jal; 1: jalr
    output logic [1:0] ALUOp,
    output logic PCr       //asserted when we need to store PC+4
);

//    localparam R_TYPE = 7'b0110011;
//    localparam LW     = 7'b0000011;
//    localparam SW     = 7'b0100011;
//    localparam BR     = 7'b1100011;
//    localparam RTypeI = 7'b0010011; //addi,ori,andi
    
    logic [6:0] R_TYPE, LW, SW, RTypeI,BR, J, Jr, UA, UL, Ii;
    
    assign  R_TYPE = 7'b0110011;
    assign  LW     = 7'b0000011; /*i type*/
    assign  SW     = 7'b0100011; /*s type*/
    assign  RTypeI = 7'b0010011; //addi,ori,andi
  	assign  BR     = 7'b1100011; //B-type
    assign  J      = 7'b1101111; /*J-type Jal*/
    assign  Jr     = 7'b1100111; /*J-type jalr*/
    assign  UA      = 7'b0010111; /*U-type auipc*/  
    assign  UL      = 7'b0110111; /*U-type lui*/  
    assign  Ii      = 7'b0010011; /*i type imm*/ 


  assign ALUSrc   = (Opcode==LW || Opcode==SW || Opcode == RTypeI || Opcode == UA || Opcode == UL || Opcode == Ii || Opcode == J || Opcode == Jr);
  assign MemtoReg = (Opcode==LW || Opcode == UA);
  assign RegWrite = (Opcode==R_TYPE || Opcode==LW || Opcode == RTypeI || Opcode ==UA || Opcode == UL || Opcode ==Ii || Opcode == J || Opcode == Jr);
  assign MemRead  = (Opcode==LW);
  assign MemWrite = (Opcode==SW);
  assign ALUOp[0] = (Opcode== BR||Opcode== Ii);
  assign ALUOp[1] = (Opcode==R_TYPE || Opcode == Ii);
  assign Branch   = (Opcode==BR || Opcode == J);   
  assign Jump     = ( Opcode ==Jr);  
  assign PCr      = (Opcode == J || Opcode == Jr || Opcode==UA); 

endmodule
