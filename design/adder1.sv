`timescale 1ns / 1ps

module adder1
    #(parameter WIDTH = 9, 
      parameter DATA_W = 32)
    (input logic [WIDTH-1:0] a,
     input logic [DATA_W-1:0] b,
     output logic [DATA_W-1:0] y);

logic [DATA_W-1:0] PCext; 

//extend pc to add to extimm
//assign PCext = a << 1; 
assign y = a + b;

endmodule
