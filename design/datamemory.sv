`timescale 1ns / 1ps

module datamemory#(
    parameter DM_ADDRESS = 9 ,
    parameter DATA_W = 32
    )(
    input logic clk,
	input logic MemRead , // comes from control unit
    input logic MemWrite , // Comes from control unit
    input logic [2:0] funct3, // to differentiate between controls 
    input logic [ DM_ADDRESS -1:0] a , // Read / Write address - 9 LSB bits of the ALU output
    input logic [ DATA_W -1:0] wd , // Write Data
    output logic [ DATA_W -1:0] rd // Read Data
    );
    
    logic [DATA_W-1:0] mem [(2**DM_ADDRESS)-1:0];
    logic [DATA_W:0] b,l,s; 
    
    always_comb 
    begin
       if(MemRead)
            //LHU 
            l = mem[a];
            case(funct3) 
            3'b000: //lb
                  b = {l[31]? 24'b1:24'b0 ,l[7:0]};
            3'b001: //lh
                  b = {l[31]? 16'b1:16'b0 ,l[15:0]};
            3'b010: //lw
                  b = mem[a]; 
            3'b100: //lbu
                  b = {24'b0 ,l[7:0]};
            3'b101: //lhu
                  b = {16'b0 ,l[15:0]};
            endcase 

            rd = b;
	end
    
    always @(posedge clk) begin
       if (MemWrite)
            case(funct3)
            3'b000: //sb
               s = wd[7:0]; 
            3'b001: //sh
                s = wd[15:0];
            3'b010: //sw
                s = wd; 
            endcase
            mem[a] = s;
    end
    
endmodule

