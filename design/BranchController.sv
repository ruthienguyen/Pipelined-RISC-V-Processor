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

module BranchController(
    
    //Input
    input logic [6:0] Opcode, //7-bit opcode field from the instruction
    input logic [2:0] Funct3, //funct3 field to differentiate branch
    //Outputs
    output logic [3:0] Operation //operation  
);
    
    logic [6:0] BR, Jr;
    
  	assign  BR     = 7'b1100011; //B-type
    assign  Jr     = 7'b1100111; /*J-type jalr*/

    always_comb
    begin 
      if (Opcode == BR) 
        case(Funct3) 
        3'b000: //beq
          Operation = 4'b0110;
        3'b001: //bne
          Operation = 4'b0110; 
        3'b100: //blt
          Operation = 4'b1001; 
        3'b101: //bge
          Operation = 4'b1100; 
        3'b110: //bltu
          Operation = 4'b1010; 
        3'b111: //bgeu
          Operation = 4'b1101;
        endcase
     else if (Opcode == Jr) 
        Operation = 4'b0000; 
     end 
endmodule
