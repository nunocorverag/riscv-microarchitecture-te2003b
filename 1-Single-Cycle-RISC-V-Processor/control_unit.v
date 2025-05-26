module control_unit (
    input zero,            // Zero flag from the ALU (used for branching decisions)
    input [6:0] op,         // Opcode from the instruction
    input clk,              // Clock signal
    input [2:0] funct3,     // Funct3 field from the instruction (bits [14:12])
    input funct7_5,         // 5th bit of funct7 (bit 30 of the instruction)
    output branch,          // Branch control signal
    output jump,            // Jump control signal
    output mem_write,       // Memory write enable
    output alu_src,         // ALU input B selection (0 = register, 1 = immediate)
    output reg_write,       // Register file write enable
    output [1:0] result_src, // Write-back result selection
    output [1:0] imm_src,    // Immediate type selector
    output [2:0] alu_control, // ALU operation control code
    output PCSrc            // PC source control (for branching/jumping)
);

// Intermediate wire for ALU operation hint
wire [1:0] alu_op;

// Instantiate the main decoder to generate main control signals
main_decoder main_dec_inst (
    .op(op),
    .branch(branch),
    .jump(jump),
    .mem_write(mem_write),
    .alu_src(alu_src),
    .reg_write(reg_write),
    .result_src(result_src),
    .imm_src(imm_src),
    .alu_op(alu_op)           // alu_op is passed to the ALU decoder
);

// Instantiate the ALU decoder to generate specific ALU control signals
alu_decoder alu_dec_inst (
    .funct3(funct3),
    .op_5(op[5]),             // 5th bit of opcode, helps distinguish I-type vs R-type
    .funct7_5(funct7_5),
    .alu_op(alu_op),
    .alu_control(alu_control) // Final control signal for ALU operation
);

// PC Source logic: Branch taken OR Jump
// PCSrc = (Branch AND Zero) OR Jump
assign PCSrc = (branch & zero) | jump;

endmodule