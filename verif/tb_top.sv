`timescale 1ns / 1ps
module tb_top;

//clock and reset signal declaration
  logic tb_clk, reset;
  logic [31:0] tb_WB_Data;
  logic [31:0] Address;
    //clock generation
  always #10 tb_clk = ~tb_clk;
  
  //reset Generation
  initial begin
    tb_clk = 0;
    reset = 1;
    #25 reset =0;
  end
  
  
  riscv riscV(
      .clk(tb_clk),
      .reset(reset),
      .WB_Data(tb_WB_Data),      
      .Address(Address)      
     );

  initial begin
    $readmemh ( "$verif/program/inst.bin" , riscV.dp.instr_mem.Inst_mem);
    

    //#10000;
    //$finish;

    #15000
    $stop;
   end
endmodule
