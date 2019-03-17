`timescale 1ns / 1ps


module HazardDetection #(
  parameter ADDR_W = 5
) (
  input  logic [ADDR_W-1:0]  idrs1, idrs2, exRd,
  input  logic              exMemRead, ib, eb, ij, ej,
  output logic noOp, if_idWrite, PCWrite, flush
);
  logic h; 

  assign h = (exMemRead && ((exRd == idrs1) || (exRd == idrs2))) ? 1'b1 : 1'b0; 

  assign noOp = h; 
  assign if_idWrite = h;
  assign PCWrite = h; 

  assign flush = (ib || eb || ij || ej) ? 1'b1: 1'b0; 


endmodule
    



