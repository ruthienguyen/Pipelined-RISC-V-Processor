`timescale 1ns / 1ps

//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/07/2018 10:23:43 PM
// Design Name: 
// Module Name: alu
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


module alu#(
        parameter DATA_WIDTH = 32,
        parameter OPCODE_LENGTH = 4
        )(
        input logic [DATA_WIDTH-1:0]    SrcA,
        input logic [DATA_WIDTH-1:0]    SrcB,

        input logic [OPCODE_LENGTH-1:0]    Operation,
        output logic[DATA_WIDTH-1:0] ALUResult, 
        output logic Zero
        );
    
        always_comb
        begin
      	    Zero = 1'b0;
            ALUResult = 'd0;
            case(Operation)
            4'b0000:        // AND
                    ALUResult = SrcA & SrcB;
            4'b0001:        //OR
                    ALUResult = SrcA | SrcB;
            4'b0010:       //ADD
                  begin
                    ALUResult = SrcA + SrcB;
                    Zero = 1'b1;
                    end
	          4'b0011:        //XOR
	            ALUResult = SrcA^SrcB;
            4'b0110:begin        //Subtract
                    ALUResult = $signed(SrcA) - $signed(SrcB);
                    if (ALUResult == 0)  
                      Zero = 1'b1; 
            end        
            4'b0111:        //SLL
                    ALUResult = SrcA << SrcB;
            4'b1000:        //SRL
                    ALUResult = SrcA >> SrcB;
            4'b1001:
            begin       //SLT && blt
                    if ($signed(SrcA) < $signed(SrcB))
                        begin
                            Zero = 1'b1;
                            ALUResult = 1'b1;
                        end
                    else
                        begin
                            Zero = 1'b0;
                            ALUResult = 1'b0;
                        end
	   	      end
            4'b1010:
            begin      //SLTU && bltu
                    if (SrcA < SrcB)
                        begin
                            Zero = 1'b1;
                            ALUResult = 1'b1;
                        end
                    else
                        begin
                            Zero = 1'b0;
                            ALUResult = 1'b0;
                        end
		        end
            4'b1011:       //SRA
                    ALUResult = $signed(SrcA) >>> SrcB;
            4'b1100:
            begin      //BGE
		                if ($signed(SrcA) >= $signed(SrcB)) 
                      begin
                    	Zero = 1'b1;
                      ALUResult = 1'b1;
                      end
                    else
                        begin
                            Zero = 1'b0;
                            ALUResult = 1'b0;
                        end
            end
            4'b1101:
            begin      //BGEU
                    if (SrcA >= SrcB)
                    begin
                    	Zero = 1'b1; 
                      ALUResult = 1'b1; 
                    end
                    else
                        begin
                            Zero = 1'b0;
                            ALUResult = 1'b0;
                        end

            end
            4'b1110:
            begin      //BNE
                    if (SrcA != SrcB) 
                     begin
                    	Zero = 1'b1; 
                      ALUResult = SrcA - SrcB; 
                    end
                    else
                        begin
                            Zero = 1'b0;
                            ALUResult = SrcA - SrcB;
                        end
            end
            default:
            begin
                    Zero = 1'b0;
                    ALUResult = 'b0;
            end 
            endcase
        end
endmodule
