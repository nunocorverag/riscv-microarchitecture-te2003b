`timescale 1ns/1ps

module alu_decoder_tb();

// Testbench signals for ALU Decoder
reg [2:0] funct3;
reg op_5;
reg funct7_5;
reg [1:0] alu_op;
wire [2:0] alu_control;

// Testbench signals for ALU
reg [31:0] SrcA;
reg [31:0] SrcB;
reg [2:0] ALUControl;
wire [31:0] ALUResult;
wire Zero;

// Loop variable declaration
integer i;

// Instantiate the ALU decoder
alu_decoder DUT_DECODER (
    .funct3(funct3),
    .op_5(op_5),
    .funct7_5(funct7_5),
    .alu_op(alu_op),
    .alu_control(alu_control)
);

// Instantiate the ALU
ALU DUT_ALU (
    .SrcA(SrcA),
    .SrcB(SrcB),
    .ALUControl(ALUControl),
    .ALUResult(ALUResult),
    .Zero(Zero)
);

// Task to display ALU decoder test results
task display_decoder_test;
    input [25*8:1] test_name;
    input [2:0] expected_control;
    begin
        #1; // Small delay to let signals settle
        $display("%-25s | funct3=%3b op_5=%b funct7_5=%b alu_op=%2b | alu_control=%3b | Expected=%3b | %s",
                 test_name, funct3, op_5, funct7_5, alu_op, alu_control, expected_control,
                 (alu_control === expected_control) ? "PASS" : "FAIL");
    end
endtask

// Task to display ALU test results
task display_alu_test;
    input [25*8:1] test_name;
    input [31:0] expected_result;
    input expected_zero;
    begin
        #1; // Small delay to let signals settle
        $display("%-25s | SrcA=%8h SrcB=%8h ALUCtrl=%3b | Result=%8h Zero=%b | Expected=%8h,%b | %s",
                 test_name, SrcA, SrcB, ALUControl, ALUResult, Zero, expected_result, expected_zero,
                 ((ALUResult === expected_result) && (Zero === expected_zero)) ? "PASS" : "FAIL");
    end
endtask

initial begin
    $display("=====================================");
    $display("=== COMPLETE ALU SYSTEM TEST ===");
    $display("=====================================\n");
    
    // ========================================
    // PART 1: ALU DECODER TESTS
    // ========================================
    $display("=== PART 1: ALU DECODER TESTS ===");
    $display("Test Name                 | Inputs                           | Output      | Expected    | Result");
    $display("--------------------------|----------------------------------|-------------|-------------|-------");
    
    // Test alu_op = 2'b00 (Load/Store instructions)
    $display("\n--- Testing alu_op = 2'b00 (Load/Store Instructions) ---");
    alu_op = 2'b00;
    
    funct3 = 3'b000; op_5 = 0; funct7_5 = 0;
    display_decoder_test("Load/Store - case 1", 3'b000);
    
    funct3 = 3'b010; op_5 = 1; funct7_5 = 1;
    display_decoder_test("Load/Store - case 2", 3'b000);
    
    // Test alu_op = 2'b01 (Branch instructions)
    $display("\n--- Testing alu_op = 2'b01 (Branch Instructions) ---");
    alu_op = 2'b01;
    
    funct3 = 3'b000; op_5 = 0; funct7_5 = 0;
    display_decoder_test("Branch - case 1", 3'b001);
    
    funct3 = 3'b001; op_5 = 1; funct7_5 = 1;
    display_decoder_test("Branch - case 2", 3'b001);
    
    // Test alu_op = 2'b10 (R-type and I-type ALU operations)
    $display("\n--- Testing alu_op = 2'b10 (R-type and I-type ALU Operations) ---");
    alu_op = 2'b10;
    
    // Test key combinations
    funct3 = 3'b000; op_5 = 0; funct7_5 = 0; // I-type ADDI
    display_decoder_test("I-type ADDI", 3'b000);
    
    funct3 = 3'b000; op_5 = 1; funct7_5 = 0; // R-type ADD
    display_decoder_test("R-type ADD", 3'b000);
    
    funct3 = 3'b000; op_5 = 1; funct7_5 = 1; // R-type SUB
    display_decoder_test("R-type SUB", 3'b001);
    
    funct3 = 3'b010; op_5 = 1; funct7_5 = 0; // SLT
    display_decoder_test("R-type SLT", 3'b101);
    
    funct3 = 3'b110; op_5 = 1; funct7_5 = 0; // OR
    display_decoder_test("R-type OR", 3'b011);
    
    funct3 = 3'b111; op_5 = 1; funct7_5 = 0; // AND
    display_decoder_test("R-type AND", 3'b010);
    
    // ========================================
    // PART 2: ALU TESTS
    // ========================================
    $display("\n\n=== PART 2: ALU TESTS ===");
    $display("Test Name                 | Inputs                    | Output              | Expected        | Result");
    $display("--------------------------|---------------------------|---------------------|-----------------|-------");
    
    // Test ADD operation
    $display("\n--- Testing ADD Operation (ALUControl = 3'b000) ---");
    ALUControl = 3'b000;
    
    SrcA = 32'h00000010; SrcB = 32'h00000020; // 16 + 32 = 48
    display_alu_test("ADD: 16 + 32", 32'h00000030, 1'b0);
    
    SrcA = 32'hFFFFFFFF; SrcB = 32'h00000001; // -1 + 1 = 0
    display_alu_test("ADD: -1 + 1 (Zero test)", 32'h00000000, 1'b1);
    
    SrcA = 32'h80000000; SrcB = 32'h80000000; // Large numbers
    display_alu_test("ADD: Large numbers", 32'h00000000, 1'b1);
    
    // Test SUB operation
    $display("\n--- Testing SUB Operation (ALUControl = 3'b001) ---");
    ALUControl = 3'b001;
    
    SrcA = 32'h00000050; SrcB = 32'h00000020; // 80 - 32 = 48
    display_alu_test("SUB: 80 - 32", 32'h00000030, 1'b0);
    
    SrcA = 32'h00000020; SrcB = 32'h00000020; // 32 - 32 = 0
    display_alu_test("SUB: 32 - 32 (Zero test)", 32'h00000000, 1'b1);
    
    SrcA = 32'h00000010; SrcB = 32'h00000020; // 16 - 32 = -16
    display_alu_test("SUB: 16 - 32 (negative)", 32'hFFFFFFF0, 1'b0);
    
    // Test AND operation
    $display("\n--- Testing AND Operation (ALUControl = 3'b010) ---");
    ALUControl = 3'b010;
    
    SrcA = 32'hFFFFFFFF; SrcB = 32'h0000FFFF; // All 1s & lower 16 bits
    display_alu_test("AND: 0xFFFFFFFF & 0x0000FFFF", 32'h0000FFFF, 1'b0);
    
    SrcA = 32'hAAAAAAAA; SrcB = 32'h55555555; // Alternating bits
    display_alu_test("AND: 0xAAAAAAAA & 0x55555555", 32'h00000000, 1'b1);
    
    SrcA = 32'hF0F0F0F0; SrcB = 32'h0F0F0F0F; // Complementary patterns
    display_alu_test("AND: 0xF0F0F0F0 & 0x0F0F0F0F", 32'h00000000, 1'b1);
    
    // Test OR operation
    $display("\n--- Testing OR Operation (ALUControl = 3'b011) ---");
    ALUControl = 3'b011;
    
    SrcA = 32'h0000FFFF; SrcB = 32'hFFFF0000; // Lower | Upper 16 bits
    display_alu_test("OR: 0x0000FFFF | 0xFFFF0000", 32'hFFFFFFFF, 1'b0);
    
    SrcA = 32'h00000000; SrcB = 32'h00000000; // 0 | 0 = 0
    display_alu_test("OR: 0x00000000 | 0x00000000", 32'h00000000, 1'b1);
    
    SrcA = 32'hAAAAAAAA; SrcB = 32'h55555555; // Alternating bits
    display_alu_test("OR: 0xAAAAAAAA | 0x55555555", 32'hFFFFFFFF, 1'b0);
    
    // Test SLT operation
    $display("\n--- Testing SLT Operation (ALUControl = 3'b101) ---");
    ALUControl = 3'b101;
    
    SrcA = 32'h00000010; SrcB = 32'h00000020; // 16 < 32 = true
    display_alu_test("SLT: 16 < 32", 32'h00000001, 1'b0);
    
    SrcA = 32'h00000020; SrcB = 32'h00000010; // 32 < 16 = false
    display_alu_test("SLT: 32 < 16", 32'h00000000, 1'b1);
    
    SrcA = 32'hFFFFFFFF; SrcB = 32'h00000001; // -1 < 1 = true (signed)
    display_alu_test("SLT: -1 < 1 (signed)", 32'h00000001, 1'b0);
    
    SrcA = 32'h80000000; SrcB = 32'h7FFFFFFF; // Most negative < Most positive
    display_alu_test("SLT: -2^31 < 2^31-1", 32'h00000001, 1'b0);
    
    // Test undefined operation
    $display("\n--- Testing Undefined Operation (ALUControl = 3'b100) ---");
    ALUControl = 3'b100;
    
    SrcA = 32'h12345678; SrcB = 32'h87654321;
    display_alu_test("Undefined operation", 32'h00000000, 1'b1);
    
    $stop;
end

endmodule