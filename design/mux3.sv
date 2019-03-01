`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:21:50 PM
// Design Name: 
// Module Name: mux2
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


module mux3
    #(parameter WIDTH = 9,
      parameter DATA_W = 32)
    (input logic [WIDTH-1:0] d0,
     input logic [DATA_W-1:0] d1,d2,
     input logic s1,s0,
     output logic [WIDTH-1:0] y);


logic [WIDTH-1:0] lowerALU; 

//take lower 9 bits of ALUresult
assign lowerALU = {d2[WIDTH-1:1],1'b0};

assign y = s1 ? (s0 ? d0 : lowerALU) :
                (s0 ? d1 : d0) ;

endmodule
