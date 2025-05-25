// Module: alu_decoder
// Description: Decodes ALU operation based on instruction fields and ALU operation hints
//              coming from the main decoder.
module alu_decoder (
    input [2:0] funct3,      // Funct3 field from instruction
    input op_5,              // 5th bit of opcode (used to differentiate instruction types)
    input funct7_5,          // 5th bit of funct7 (bit 30 of instruction)
    input [1:0] alu_op,      // ALU operation hint from main decoder
    output reg [2:0] alu_control // Output control signal to define ALU operation
);

// Combinational logic: defines ALU control based on instruction fields and alu_op
always @(*) begin
    case (alu_op)
        2'b00: begin
            // For load/store instructions (lw, sw), perform addition
            alu_control = 3'b000; // ALU operation = ADD
        end
        2'b01: begin
            // For branch instructions (beq), perform subtraction
            alu_control = 3'b001; // ALU operation = SUB
        end
        2'b10: begin
            // For R-type and I-type ALU operations
            case (funct3)
                3'b000: begin
                    // ADD or SUB depending on funct7[5] and op[5]
                    if ({op_5, funct7_5} == 2'b11)
                        alu_control = 3'b001; // SUB (subtraction)
                    else
                        alu_control = 3'b000; // ADD (addition)
                end
                3'b010: begin
                    alu_control = 3'b101; // SLT (Set Less Than)
                end
                3'b110: begin
                    alu_control = 3'b011; // OR operation
                end
                3'b111: begin
                    alu_control = 3'b010; // AND operation
                end
                default: alu_control = 3'bxxx; // Undefined operation
            endcase
        end
        default: alu_control = 3'bxxx; // Undefined operation
    endcase
end

endmodule