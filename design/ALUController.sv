`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:10:33 PM
// Design Name: 
// Module Name: ALUController
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


module ALUController(
    
    //Inputs
    input logic [1:0] ALUOp,  //7-bit opcode field from the instruction
    input logic [6:0] Funct7, // bits 25 to 31 of the instruction
    input logic [2:0] Funct3, // bits 12 to 14 of the instruction
    
    //Output
    output logic [3:0] Operation //operation selection for ALU
);

    always_comb
    begin 
        case(Funct3) 
        3'b000: begin//sub or add
                    if ((Funct7==7'b0000000 && ALUOp==2'b10 ) || ALUOp==2'b00 || ALUOp==2'b11)
                        Operation = 4'b0010; //add, lb, addi
                    else if ((Funct7==7'b0100000 && ALUOp==2'b10) || (ALUOp==2'b01))
                        Operation = 4'b0110; //sub and beq
                end
        3'b001: begin//sll
                    if(Funct7==7'b0000000 && (ALUOp==2'b10))
                        Operation = 4'b0111;
                    else if (ALUOp==2'b01)
                        Operation = 4'b1110; //bne
                    else if (ALUOp==2'b00)
                        Operation = 4'b0010; // lh
                    else if (Funct7==7'b0000000 && ALUOp==2'b11)
                        Operation = 4'b0111; //slli
                end
        3'b010: begin//slt
                    if (Funct7==7'b0000000 && ALUOp==2'b10)
                        Operation = 4'b1001;
                    else if (ALUOp==2'b00)
                        Operation = 4'b0010; // lw
                    else if (ALUOp==2'b11)
                        Operation = 4'b1001; // slti
                end
        3'b100: begin//xor
                    if (Funct7==7'b0000000 && ALUOp==2'b10)
                        Operation = 4'b0011;
                    else if (ALUOp==2'b01)
                        Operation = 4'b1001; //blt
                    else if (ALUOp==2'b00)
                        Operation = 4'b0010; //lbu
                    else if (ALUOp==2'b11)
                        Operation = 4'b0011; // xori
                end
        3'b011: begin//sltu
                    if (Funct7==7'b0000000 && ALUOp==2'b10)
                        Operation = 4'b1010;
                    else if (ALUOp==2'b11)
                        Operation = 4'b1010;
                end
        3'b101: begin//srl or sra
                    if (Funct7==7'b0000000 && ALUOp==2'b10)
                        Operation = 4'b1000; //srl
                    else if (Funct7==7'b0100000 && ALUOp==2'b10)
                        Operation = 4'b1011; //sra
                    else if (ALUOp==2'b01)
                        Operation = 4'b1100; //bge
                    else if (ALUOp==2'b00)
                        Operation = 4'b0010; //lhu
                    else if (Funct7==7'b0000000 && ALUOp==2'b11)
                        Operation = 4'b1000; //srli
                    else if (Funct7==7'b0100000 && ALUOp==2'b11)
                        Operation = 4'b1011; //srai
                end
        3'b110: begin//or
                    if (Funct7==7'b0000000 && ALUOp==2'b10)
                        Operation = 4'b0001;
                    else if (ALUOp==2'b01)
                        Operation = 4'b1010; //bltu
                    else if (ALUOp==2'b11)
                        Operation = 4'b0001; // ori
                end
        3'b111: begin//and
                    if (Funct7==7'b0000000 && ALUOp==2'b10)
                        Operation = 4'b0000;
                    else if (ALUOp==2'b01)
                        Operation = 4'b1101; //bgeu
                    else if (ALUOp==2'b11)
                        Operation = 4'b0000; //andi
                end
        endcase 
     end 
//  assign Operation[0]= ((ALUOp==2'b00) && (Funct7==7'b0000000) && (Funct3==3'b110 || Funct3==3'b100)) ||
// 			            ((ALUOp==2'b10) && (Funct3==3'b110 ||Funct3==3'b100||Funct3==3'b001||Funct3==3'b101||Funct3==3'b010||Funct3==3'b011||Funct3==3'b101));
//  assign Operation[1]= (((ALUOp==2'b00) || (ALUOp==2'b10)) && ((Funct7==7'b0000000) ||(Funct7==7'b0100000)) && ((Funct3==3'b000) || (Funct3==3'b100)
//                     ||Funct3==3'b001||Funct3==3'b101||Funct3==3'b010||Funct3==3'b011||Funct3==3'b101)) ||
//                         (ALUOp==2'b01) ||(ALUOp==2'b11);                  
//  assign Operation[2]= ((ALUOp==2'b00 ||ALUOp==2'b10) && (Funct7==7'b0100000||Funct7==7'b0000000) && (Funct3==3'b000||Funct3==3'b001))
//                     || ((ALUOp==2'b00 || ALUOp==2'b10) && (Funct3==3'b010));
//  assign Operation[3]= ((ALUOp==2'b10) && (Funct7==7'b0100000||Funct7==7'b0000000) && (Funct3==3'b101||Funct3==3'b010||Funct3==3'b011||Funct3==3'b101));

endmodule
