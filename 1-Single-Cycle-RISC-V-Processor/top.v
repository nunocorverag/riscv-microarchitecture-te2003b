module top #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 8
) (
    input clk, // Clock signal
    input rst, // Reset signal
    input PCSrc_in, // Temporary signal for PC flow control for testing
    output [DATA_WIDTH-1:0] PC_out, // Temporary output for PC for testing
    output [DATA_WIDTH-1:0] Instr_out // Temporary output for instruction for testing
);

wire [DATA_WIDTH-1:0] PC;
wire [DATA_WIDTH-1:0] PCTarget;
wire [DATA_WIDTH-1:0] PCPlus4;
wire [DATA_WIDTH-1:0] Instr;

wire PCSrc; //TODO: CONNECT TO CONTROL UNIT

// Temporary signals for testing
assign PCPlus4 = PC + 4; // Calculate PC + 4 for next instruction
assign PCTarget = PC + 16; // Example target address for branch/jump (can be modified)
assign PCSrc = PCSrc_in; // Temporary assignment for testing
assign PC_out = PC; // Temporary output for testing
assign Instr_out = Instr; // Temporary output for instruction for testing

wire [DATA_WIDTH-1:0] PCNext = PCSrc ? PCTarget : PCPlus4;

program_counter #(
    .DATA_WIDTH(DATA_WIDTH)
) PC_REG (
    .clk(clk),
    .rst(rst),
    .pcNext(PCNext),
    .pc(PC)
);

instruction_memory #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
) IM (
    .A(PC),
    .RD(Instr)
);

endmodule