`timescale 1ns / 1ps


module ForwardingUnit #(
  parameter SIG_W  = 2 ,
  parameter ADDR_W = 5
) (
  input  logic [ADDR_W-1:0] exRd, wbRd, idrs1, idrs2,
  input  logic              exRegWrite, wbRegWrite,
  output logic [ SIG_W-1:0] ForwardA  ,
  output logic [ SIG_W-1:0] ForwardB
);
/*
      assign ForwardA = (exRegWrite && (exRd != 0) && (exRd == idrs1)) ? ((wbRegWrite && (wbRd != 0) && (wbRd == idrs1)) ? 2'b00 : 2'b01 ):
                                                                         ((wbRegWrite && (wbRd != 0) && (wbRd == idrs1)) ? 2'b10 : 2'b00); 

      assign ForwardB = (exRegWrite && (exRd != 0) && (exRd == idrs2)) ? ((wbRegWrite && (wbRd != 0) && (wbRd == idrs2)) ? 2'b00: 2'b01):
                                                                         ((wbRegWrite && (wbRd != 0) && (wbRd == idrs2)) ? 2'b10 : 2'b00); 
*/

      always_comb begin
        if (exRegWrite && (exRd != 0) && (exRd == idrs1)) begin
            ForwardA = 2'b10; 
        end
        else if (wbRegWrite && (wbRd != 0) && (wbRd == idrs1) && !(exRegWrite && (exRd != 0) && (exRd == idrs1))) begin
            ForwardA = 2'b01; 
        end
        else begin
            ForwardA = 2'b00; 
        end



        if (exRegWrite && (exRd != 0) && (exRd == idrs2)) begin
            ForwardB = 2'b10; 
        end
        else if (wbRegWrite && (wbRd != 0) && (wbRd == idrs2) && !(exRegWrite && (exRd != 0) && (exRd == idrs2))) begin
            ForwardB = 2'b01;
        end
        else begin
            ForwardB = 2'b00; 
        end
      end

endmodule
    



