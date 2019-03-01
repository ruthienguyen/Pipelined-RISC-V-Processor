`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:20:16 PM
// Design Name: 
// Module Name: instructionmemory
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


module instructionmemory#(
    parameter INS_ADDRESS = 9,
    parameter INS_W = 32
     )(
    input logic [ INS_ADDRESS -1:0] ra , // Read address of the instruction memory , comes from PC
    output logic [ INS_W -1:0] rd // Read Data
    );
    

logic [INS_W-1 :0] Inst_mem [(2**(INS_ADDRESS-2))-1:0];
    
 



//assign Inst_mem[0] = 32'h00311733;//     sll r14, r2, r3          ALUResult = h20 = r14

//branch
//assign Inst_mem[1] = 32'h00c50a63;//     beq x12, x10, 20         ALUResult = 00000000        branch taken to inst_mem[34] 
//assign Inst_mem[2] = 32'h0072c7b3;//     xor r15, r5, r7          ALUResult = hc = r15
//assign Inst_mem[3] = 32'h00235833;//     srl r16, r6, r2          ALUResult = h2 = r16
//assign Inst_mem[4] = 32'h4034d8b3;//     sra r17, r9, r3          ALUResult = hffffffff = r17
////JALR
//
//assign Inst_mem[5] = 32'h000586e7;//     jalr x13, 0(x11)           ALUResult = h88               
//assign Inst_mem[6] = 32'h01614513;//xori r10 r2 16h aluresult: h14, r10
assign rd =  Inst_mem [ra[INS_ADDRESS-1:2]];  
//      genvar i;
//      generate
//          for (i = 15; i < 127; i++) begin
//              assign Inst_mem[i] = 32'h00007033;
//          end
//      endgenerate

endmodule

