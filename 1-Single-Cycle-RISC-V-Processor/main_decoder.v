// Module: main_decoder
// Description: Decodes the 7-bit opcode of an instruction to generate the main control signals
// that guide the datapath behavior.

module main_decoder (
    input [6:0] op,             // Opcode field from instruction
    output reg branch,          // Signal to trigger a branch operation (beq, etc.)
    output reg jump,            // Signal to trigger a jump operation (jal)
    output reg mem_write,       // Signal to enable memory write
    output reg alu_src,         // Selects ALU input B source (0 = register, 1 = immediate)
    output reg reg_write,       // Enables writing to the register file
    output reg [1:0] result_src,// Selects result to write back (00 = ALU result, 01 = memory read, 10 = PC+4)
    output reg [1:0] imm_src,   // Selects immediate format (I-type, S-type, B-type, J-type)
    output reg [1:0] alu_op     // Provides high-level instruction type hint to ALU control
);

always @(*) begin
    // Default values for control signals (safe state)
    reg_write   = 0;
    imm_src     = 2'b00;
    alu_src     = 0;
    mem_write   = 0;
    result_src  = 2'b00;
    branch      = 0;
    alu_op      = 2'b00;
    jump        = 0;

    // Decode based on opcode value
    case (op)
        7'b0000011: begin // Load Word (lw)
            reg_write   = 1;    // Write back to register
            imm_src     = 2'b00; // I-type immediate
            alu_src     = 1;    // ALU input B = immediate
            mem_write   = 0;    // No memory write
            result_src  = 2'b01;// Write data from memory
            branch      = 0;
            alu_op      = 2'b00;// ALU will perform addition
            jump        = 0;
        end

        7'b0100011: begin // Store Word (sw)
            reg_write   = 0;    // No register write
            imm_src     = 2'b01;// S-type immediate
            alu_src     = 1;    // ALU input B = immediate
            mem_write   = 1;    // Enable memory write
            result_src  = 2'bxx;// Not used
            branch      = 0;
            alu_op      = 2'b00;// ALU will perform addition
            jump        = 0;
        end

        7'b0110011: begin // R-type instructions (add, sub, and, or, etc.)
            reg_write   = 1;    // Write back to register
            imm_src     = 2'bxx;// Immediate not needed
            alu_src     = 0;    // ALU input B = register
            mem_write   = 0;    // No memory write
            result_src  = 2'b00;// Write ALU result
            branch      = 0;
            alu_op      = 2'b10;// ALU Control depends on funct fields
            jump        = 0;
        end

        7'b1100011: begin // Branch Equal (beq)
            reg_write   = 0;    // No register write
            imm_src     = 2'b10;// B-type immediate
            alu_src     = 0;    // ALU input B = register
            mem_write   = 0;    // No memory write
            result_src  = 2'bxx;// Not used
            branch      = 1;    // Enable branch control
            alu_op      = 2'b01;// ALU will perform subtraction for comparison
            jump        = 0;
        end

        7'b0010011: begin // I-type ALU operations (addi, etc.)
            reg_write   = 1;    // Write back to register
            imm_src     = 2'b00;// I-type immediate
            alu_src     = 1;    // ALU input B = immediate
            mem_write   = 0;    // No memory write
            result_src  = 2'b00;// Write ALU result
            branch      = 0;
            alu_op      = 2'b10;// ALU Control depends on funct fields
            jump        = 0;
        end

        7'b1101111: begin // Jump and Link (jal)
            reg_write   = 1;    // Write back to register
            imm_src     = 2'b11;// J-type immediate
            alu_src     = 1'bx; // Doesn't matter (jump is handled specially)
            mem_write   = 0;    // No memory write
            result_src  = 2'b10;// Write PC+4 (return address)
            branch      = 0;
            alu_op      = 2'bxx;// Not used
            jump        = 1;    // Enable jump control
        end

        default: begin
            // Keep default safe values (NOP behavior)
        end
    endcase
end

endmodule