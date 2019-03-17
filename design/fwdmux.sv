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


module fwdmux
    #(parameter DATA_W = 32)
    (input logic [DATA_W-1:0] d0,d1,d2,
     input logic s1,s0,
     output logic [DATA_W-1:0] y);


assign y = s1 ? (s0 ? d0 : d1) :
                (s0 ? d2 : d0) ;

endmodule
