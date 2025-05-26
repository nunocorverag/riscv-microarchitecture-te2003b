module top #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 8
) (
    input clk, // Clock signal
    input rst  // Reset signal
);

// ==================== WIRES ====================
wire [DATA_WIDTH-1:0] PC;
wire [DATA_WIDTH-1:0] PCTarget;
wire [DATA_WIDTH-1:0] PCPlus4;
wire [DATA_WIDTH-1:0] instr;
wire PCSrc;

// Control signals from control unit
wire branch, jump, mem_write, alu_src, reg_write;
wire [1:0] result_src, imm_src;
wire [2:0] alu_control;

// Datapath wires
wire [DATA_WIDTH-1:0] RD1, RD2;
wire [31:0] immExt;
wire [31:0] SrcA, SrcB;
wire [31:0] ALUResult;
wire Zero;
wire [31:0] ReadData;
wire [31:0] WriteData;

// ==================== PC LOGIC ====================
// Mux: PCSrc - Select next PC (PCPlus4 or PCTarget)
wire [DATA_WIDTH-1:0] PCNext = PCSrc ? PCTarget : PCPlus4;

program_counter #(
    .DATA_WIDTH(DATA_WIDTH)
) PC_REG (
    .clk(clk),
    .rst(rst),
    .pcNext(PCNext),
    .pc(PC)
);

// ==================== INSTRUCTION FETCH ====================
instruction_memory #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH)
) IM (
    .A(PC),
    .RD(instr)
);

// ==================== CONTROL UNIT ====================
control_unit CU (
    .zero(Zero),
    .op(instr[6:0]),
    .clk(clk),
    .funct3(instr[14:12]),
    .funct7_5(instr[30]),
    .branch(branch),
    .jump(jump),
    .mem_write(mem_write),
    .alu_src(alu_src),
    .reg_write(reg_write),
    .result_src(result_src),
    .imm_src(imm_src),
    .alu_control(alu_control),
    .PCSrc(PCSrc)
);

// ==================== REGISTER FILE ====================
// Write data selection: ALU result, Memory data, or PC+4
assign WriteData = (result_src == 2'b00) ? ALUResult :
                   (result_src == 2'b01) ? ReadData :
                   (result_src == 2'b10) ? PCPlus4 : 32'b0;

register_file #(
    .DATA_WIDTH(DATA_WIDTH)
) RF(
    .clk(clk),
    .WE3(reg_write),
    .A1(instr[19:15]), // rs1
    .A2(instr[24:20]), // rs2
    .A3(instr[11:7]),  // rd
    .WD3(WriteData),
    .RD1(RD1),
    .RD2(RD2)
);

// ==================== IMMEDIATE GENERATOR ====================
immediate_generator IMM_GEN(
    .instr(instr),
    .immSrc(imm_src),
    .immExt(immExt)
);

// ==================== PC CALCULATION ====================
pc_plus4 #(.WIDTH(DATA_WIDTH)) PC_PLUS4_UNIT (
    .PC(PC),
    .PCPlus4(PCPlus4)
);

pc_target #(.WIDTH(DATA_WIDTH)) PC_TARGET_UNIT (
    .PC(PC),
    .immExt(immExt),
    .PCTarget(PCTarget)
);

// ==================== ALU ====================
assign SrcA = RD1;
// MUX ALUSrc: Select ALU input B (register or immediate)
assign SrcB = alu_src ? immExt : RD2;

ALU ALU_UNIT(
    .SrcA(SrcA),
    .SrcB(SrcB),
    .ALUControl(alu_control),
    .ALUResult(ALUResult),
    .Zero(Zero)
);

// ==================== DATA MEMORY ====================
data_memory #(
    .DATA_WIDTH(DATA_WIDTH)
) DMEM (
    .clk(clk),
    .WE(mem_write),
    .A(ALUResult),
    .WD(RD2),
    .RD(ReadData)
);

endmodule