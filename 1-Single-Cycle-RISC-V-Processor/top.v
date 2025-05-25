module top #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 8
) (
    input clk, // Clock signal
    input rst, // Reset signal
    input PCSrc_in, // Temporary signal for PC flow control for testing
    input [1:0] immSrc_in, // Temporary signal for immediate source selection for testing
    input ALUSrc_in, // Temporary signal for ALU source selection
    input [1:0] alu_op_in // Temporary signal for ALU operation type
);

wire [DATA_WIDTH-1:0] PC;
wire [DATA_WIDTH-1:0] PCTarget;
wire [DATA_WIDTH-1:0] PCPlus4;
wire [DATA_WIDTH-1:0] instr;

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
    .RD(instr)
);

wire [DATA_WIDTH-1:0] RD1;
wire [DATA_WIDTH-1:0] RD2;

register_file #(
    .DATA_WIDTH(DATA_WIDTH)
) RF(
    .clk(clk),
    .WE3(0),
    .A1(instr[19:15]), // rs1
    .A2(0),
    .A3(0),
    .WD3(0),
    .RD1(RD1),
    .RD2(RD2)
);

wire [1:0] immSrc; // TODO: CONNECT TO CONTROL UNIT

assign immSrc = immSrc_in; // Temporary assignment for testing
wire [31:0] immExt;

immediate_generator IMM_GEN(
    .instr(instr),
    .immSrc(immSrc),
    .immExt(immExt)
);

wire ALUSrc; // TODO: CONNECT TO CONTROL UNIT
assign ALUSrc = ALUSrc_in; // Temporary assignment for testing

wire [31:0] SrcA = RD1;
wire [31:0] SrcB = ALUSrc ? immExt : RD2;

// ALU Decoder
wire [1:0] alu_op; // TODO: CONNECT TO CONTROL UNIT
assign alu_op = alu_op_in; // Temporary assignment for testing

wire [2:0] ALUControl;

alu_decoder ALU_DEC(
    .funct3(instr[14:12]),
    .op_5(instr[5]),
    .funct7_5(instr[30]),
    .alu_op(alu_op),
    .alu_control(ALUControl)
);

wire [31:0] ALUResult;
wire Zero;

ALU ALU_UNIT(
    .SrcA(SrcA),
    .SrcB(SrcB),
    .ALUControl(ALUControl),
    .ALUResult(ALUResult),
    .Zero(Zero)
);

endmodule
