module top #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 8
) (
    input clk, // Clock signal
    input rst, // Reset signal
    input PCSrc_in, // Temporary signal for PC flow control for testing
    input [1:0] immSrc_in, // Temporary signal for immediate source selection for testing
    input ALUSrc_in, // Temporary signal for ALU source selection
    input [1:0] alu_op_in, // Temporary signal for ALU operation type
    input MemWrite_in, // Temporary signal for memory write enable
    input RegWrite_in, // Temporary signal for register write enable
    input MemToReg_in, // Signal to select between ALU result and memory data
    input [31:0] instr_in // Temporary signal for instruction input    
);

wire [DATA_WIDTH-1:0] PC;
wire [DATA_WIDTH-1:0] PCTarget;
wire [DATA_WIDTH-1:0] PCPlus4;
wire [DATA_WIDTH-1:0] instr;
wire PCSrc;

// Temporary signals for testing
assign PCPlus4 = PC + 4; // Calculate PC + 4 for next instruction
assign PCTarget = PC + 16; // Example target address for branch/jump (can be modified)
assign PCSrc = PCSrc_in; // Temporary assignment for testing

wire [DATA_WIDTH-1:0] PCNext = PCSrc ? PCTarget : PCPlus4;
wire [DATA_WIDTH-1:0] ReadData; // Data read from memory

program_counter #(
    .DATA_WIDTH(DATA_WIDTH)
) PC_REG (
    .clk(clk),
    .rst(rst),
    .pcNext(PCNext),
    .pc(PC)
);

// TODO: Replace with no hardcoded instruction for testing
assign instr = instr_in; // Temporary assignment for testing

wire [DATA_WIDTH-1:0] RD1;
wire [DATA_WIDTH-1:0] RD2;
wire RegWrite;
assign RegWrite = RegWrite_in; // Temporary assignment for testing

// Add MemToReg signal and multiplexer for write data selection
wire MemToReg;
assign MemToReg = MemToReg_in;
wire [DATA_WIDTH-1:0] ALUResult;
wire [DATA_WIDTH-1:0] WriteData = MemToReg ? ReadData : ALUResult; // Select between memory and ALU result

register_file #(
    .DATA_WIDTH(DATA_WIDTH)
) RF(
    .clk(clk),
    .WE3(RegWrite),
    .A1(instr[19:15]), // rs1
    .A2(instr[24:20]), // rs2 - FIXED: was hardcoded to 0
    .A3(instr[11:7]), // rd
    .WD3(WriteData), // FIXED: Now uses WriteData instead of ReadData
    .RD1(RD1),
    .RD2(RD2)
);

wire [1:0] immSrc;
assign immSrc = immSrc_in; // Temporary assignment for testing
wire [31:0] immExt;

immediate_generator IMM_GEN(
    .instr(instr),
    .immSrc(immSrc),
    .immExt(immExt)
);

wire ALUSrc;
assign ALUSrc = ALUSrc_in; // Temporary assignment for testing
wire [31:0] SrcA = RD1;
wire [31:0] SrcB = ALUSrc ? immExt : RD2;

// ALU Decoder
wire [1:0] alu_op;
assign alu_op = alu_op_in; // Temporary assignment for testing
wire [2:0] ALUControl;

alu_decoder ALU_DEC(
    .funct3(instr[14:12]),
    .op_5(instr[5]),
    .funct7_5(instr[30]),
    .alu_op(alu_op),
    .alu_control(ALUControl)
);

wire Zero;

ALU ALU_UNIT(
    .SrcA(SrcA),
    .SrcB(SrcB),
    .ALUControl(ALUControl),
    .ALUResult(ALUResult),
    .Zero(Zero)
);

wire MemWrite;
assign MemWrite = MemWrite_in; // Temporary assignment for testing

data_memory #(
    .DATA_WIDTH(DATA_WIDTH)
) DMEM (
    .clk(clk),
    .WE(MemWrite),
    .A(ALUResult),
    .WD(RD2),
    .RD(ReadData)
);

endmodule