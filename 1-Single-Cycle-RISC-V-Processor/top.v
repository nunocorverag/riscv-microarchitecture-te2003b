module top #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 8
) (
    input clk, // Clock signal
    input rst, // Reset signal
    input PCSrc_in // Temporary signal for PC flow control for testing
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

wire [DATA_WIDTH-1:0] RD1;
wire [DATA_WIDTH-1:0] RD2;

register_file #(
    .DATA_WIDTH(DATA_WIDTH)
) RF(
    .clk(clk),
    .WE3(0),
    .A1(Instr[19:15]), // rs1
    .A2(0),
    .A3(0),
    .WD3(0),
    .RD1(RD1),
    .RD2(RD2)
);

endmodule
