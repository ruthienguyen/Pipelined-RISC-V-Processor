`timescale 1ns / 1ps



module tb_controller;

    //testing connections
    logic [6:0] Opcode;
    logic ALUSrc;
    logic MemtoReg;
    logic RegWrite;
    logic MemRead;
    logic MemWrite;
    logic Branch;
    logic [1:0] ALUOp;

/*
    Controller testController (
        .Opcode(Opcode),
        .ALUSrc(ALUSrc),
        .MemtoReg
        )
*/
    Controller myController(
        .Opcode  (Opcode),
        .ALUSrc  (ALUSrc),
        .MemtoReg(MemtoReg),
        .RegWrite(RegWrite),
        .MemRead (MemRead),
        .MemWrite(MemWrite),
        .Branch  (Branch),
        .ALUOp   (ALUOp)
    );

    initial begin
        $display("begin controller test\n");

        #10 Opcode = 7'bxxxxxxx;

        #5 Opcode = 7'b0110111;
        #5 $display("LUI:%b",Opcode);
        $display("ALUSrc:%b, MemtoReg:%b, RegWrite:%b, MemRead:%b, MemWrite:%b, Branch:%b, ALUOp:%b\n",
            ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp);

        #5 Opcode = 7'b0010111;
        #5 $display("AUIPC:%b",Opcode);
        $display("ALUSrc:%b, MemtoReg:%b, RegWrite:%b, MemRead:%b, MemWrite:%b, Branch:%b, ALUOp:%b\n",
            ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp);

        #5 Opcode = 7'b1101111;
        #5 $display("JAL:%b",Opcode);
        $display("ALUSrc:%b, MemtoReg:%b, RegWrite:%b, MemRead:%b, MemWrite:%b, Branch:%b, ALUOp:%b\n",
            ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp);

        #5 Opcode = 7'b1100111;
        #5 $display("JALR:%b",Opcode);
        $display("ALUSrc:%b, MemtoReg:%b, RegWrite:%b, MemRead:%b, MemWrite:%b, Branch:%b, ALUOp:%b\n",
            ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp);

        #5 Opcode = 7'b1100011;
        #5 $display("B Type:%b",Opcode);
        $display("ALUSrc:%b, MemtoReg:%b, RegWrite:%b, MemRead:%b, MemWrite:%b, Branch:%b, ALUOp:%b\n",
            ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp);

        #5 Opcode = 7'b0000011;
        #5 $display("Load:%b",Opcode);
        $display("ALUSrc:%b, MemtoReg:%b, RegWrite:%b, MemRead:%b, MemWrite:%b, Branch:%b, ALUOp:%b\n",
            ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp);

        #5 Opcode = 7'b0100011;
        #5 $display("Save:%b",Opcode);
        $display("ALUSrc:%b, MemtoReg:%b, RegWrite:%b, MemRead:%b, MemWrite:%b, Branch:%b, ALUOp:%b\n",
            ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp);

        #5 Opcode = 7'b0010011;
        #5 $display("I Type:%b",Opcode);
        $display("ALUSrc:%b, MemtoReg:%b, RegWrite:%b, MemRead:%b, MemWrite:%b, Branch:%b, ALUOp:%b\n",
            ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp);

        #5 Opcode = 7'b0110011;
        #5 $display("R Type:%b",Opcode);
        $display("ALUSrc:%b, MemtoReg:%b, RegWrite:%b, MemRead:%b, MemWrite:%b, Branch:%b, ALUOp:%b\n",
            ALUSrc, MemtoReg, RegWrite, MemRead, MemWrite, Branch, ALUOp);

        #100 $stop;
    end
endmodule