// Module: immediate_generator
// Description: Immediate Generator for RISC-V instructions.
//              Based on the instruction type (immSrc), it extracts and sign-extends
//              the immediate field from the instruction.

module immediate_generator(
    input [31:0] instr,   // Input: Full 32-bit instruction)
    input [1:0] immSrc,       // Input: Immediate source type selector
                              //        00 = I-type, 01 = S-type, 10 = B-type, 11 = J-type
    output reg [31:0] immExt  // Output: Sign-extended immediate value
);

// Combinational logic: selects the appropriate immediate format
always @(*) begin
    case(immSrc)
        2'b00: // I-type immediate
            immExt = {{20{instr[31]}}, instr[31:20]};

        2'b01: // S-type immediate
            immExt = {{20{instr[31]}}, instr[31:25], instr[11:7]};

        2'b10: // B-type immediate
            immExt = {{19{instr[31]}}, instr[31], instr[7], instr[30:25], instr[11:8], 1'b0};

        2'b11: // J-type immediate
            immExt = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
    endcase
end

endmodule
