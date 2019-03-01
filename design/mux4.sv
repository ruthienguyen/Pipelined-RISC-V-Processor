`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:21:50 PM
// Design Name: 
// Module Name: mux4
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 3 to 1 mux for result 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mux4
    #(parameter WIDTH = 9,
      parameter DATA_W = 32)
    (input logic [DATA_W-1:0] d0,d1,
     input logic [WIDTH-1:0] d2,
     input logic [DATA_W-1:0] d3,
     input logic s1,s0,
     output logic [DATA_W-1:0] y);


logic [DATA_W-1:0] PCPlus4, PCr; 

//extend pc bits to fill reg
assign PCPlus4 = {23'b0,d2};
assign PCr = {23'b0,d3};

assign y = s1 ? (s0 ? PCr : PCPlus4) :
                (s0 ? d1 : d0) ;

endmodule
