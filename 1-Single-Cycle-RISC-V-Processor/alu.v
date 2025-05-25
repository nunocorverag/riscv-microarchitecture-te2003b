// Module: ALU
// Description: Arithmetic Logic Unit that performs basic operations based on control signals.
//              Also generates a Zero flag if the result is zero.
module ALU (
    input [31:0] SrcA,         // First ALU input (Operand A)
    input [31:0] SrcB,         // Second ALU input (Operand B)
    input [2:0] ALUControl,    // Control signal to select ALU operation
    output reg [31:0] ALUResult, // Output: result of ALU operation
    output reg Zero            // Output: Zero flag (1 if ALUResult == 0)
);

// Combinational logic: determines ALUResult and Zero flag
always @(*) begin
    case (ALUControl)
        3'b000: ALUResult = SrcA + SrcB;           // ADD
        3'b001: ALUResult = SrcA - SrcB;           // SUB
        3'b010: ALUResult = SrcA & SrcB;           // AND
        3'b011: ALUResult = SrcA | SrcB;           // OR
        3'b101: ALUResult = ($signed(SrcA) < $signed(SrcB)) ? 32'd1 : 32'd0;
        default: ALUResult = 32'b0;                // Default case
    endcase
    
    // Check if ALUResult is zero
    Zero = (ALUResult == 32'b0) ? 1'b1 : 1'b0;
end

endmodule