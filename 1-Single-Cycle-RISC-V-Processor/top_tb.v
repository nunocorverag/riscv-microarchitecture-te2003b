`timescale 1ns/1ps
module top_tb();
    // Parameters matching the top module
    localparam DATA_WIDTH = 32;
    localparam ADDR_WIDTH = 8;
    
    // Clock signal
    reg clk;
    // Reset signal
    reg rst;
    
    // Control signals for testing
    reg PCSrc;
    reg [1:0] immSrc;
    reg ALUSrc;
    reg [1:0] alu_op;
    reg MemWrite;
    reg RegWrite;
    reg MemToReg; // Added MemToReg signal
    reg [31:0] instr_in;
    
    // Instantiate the top module
    top #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .PCSrc_in(PCSrc),
        .immSrc_in(immSrc),
        .ALUSrc_in(ALUSrc),
        .alu_op_in(alu_op),
        .MemWrite_in(MemWrite),
        .RegWrite_in(RegWrite),
        .MemToReg_in(MemToReg), // Connect MemToReg
        .instr_in(instr_in)
    );
    
    // Generate clock with 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Initialize signals and simulate changes in PCSrc
    initial begin
        // Inicialización
        rst = 1;
        PCSrc = 0;
        immSrc = 2'b00;
        ALUSrc = 0;
        alu_op = 2'b00;
        MemWrite = 0;
        RegWrite = 0;
        MemToReg = 0; // Initialize MemToReg
        instr_in = 32'h00000000; // Instrucción NOP inicial
        
        #10;
        rst = 0;
        
        // === Prueba 1: addi x2, x0, 5 (Escribir 5 en x2) ===
        $display("=== Test 1: addi x2, x0, 5 ===");
        instr_in = 32'h00500113; // addi x2, x0, 5
        ALUSrc = 1;             // Usar inmediato
        immSrc = 2'b00;         // Inmediato tipo I
        alu_op = 2'b00;         // ALU ADD
        RegWrite = 1;           // Habilitar escritura en registro
        MemWrite = 0;           // No escribir en memoria
        MemToReg = 0;           // Usar resultado de ALU, no memoria
        
        #20;
        $display("Registro x2 should be 5. ALUResult = %d", DUT.ALUResult);
        
        // === Prueba 2: sw x2, 8(x0) (Almacenar x2 en memoria) ===
        $display("=== Test 2: sw x2, 8(x0) ===");
        instr_in = 32'h00202423; // sw x2, 8(x0) -> Correctly encoded
        ALUSrc = 1;             // Usar inmediato (dirección)
        immSrc = 2'b01;         // Inmediato tipo S
        alu_op = 2'b00;         // ALU ADD (calcular dirección)
        RegWrite = 0;           // No escribir en registros
        MemWrite = 1;           // Habilitar escritura en memoria
        MemToReg = 0;           // Don't care for store operations
        
        #20;
        $display("Memory at address 8 should contain 5");
        
        // === Prueba 3: lw x3, 8(x0) (Leer memoria a x3) ===
        $display("=== Test 3: lw x3, 8(x0) ===");
        instr_in = 32'h00802183; // lw x3, 8(x0) -> Correctly encoded
        ALUSrc = 1;             // Usar inmediato
        immSrc = 2'b00;         // Inmediato tipo I
        alu_op = 2'b00;         // ALU ADD
        RegWrite = 1;           // Habilitar escritura en registro
        MemWrite = 0;           // No escribir en memoria
        MemToReg = 1;           // Usar datos de memoria, no ALU
        
        #20;
        $display("Registro x3 should be 5. ReadData = %d", DUT.ReadData);
        
        // === Prueba 4: Verificar que x0 siempre sea 0 ===
        $display("=== Test 4: Verify x0 is always 0 ===");
        instr_in = 32'h00500013; // addi x0, x0, 5 (should not change x0)
        ALUSrc = 1;
        immSrc = 2'b00;
        alu_op = 2'b00;
        RegWrite = 1;
        MemWrite = 0;
        MemToReg = 0;
        
        #20;
        $display("Register x0 should always be 0");
        
        $stop;
    end
    
    // Monitor key signals
    initial begin
        $monitor("Time=%0t: PC=%d, instr=%h, ALUResult=%d, ReadData=%d, RegWrite=%b, MemWrite=%b", 
                 $time, DUT.PC, DUT.instr, DUT.ALUResult, DUT.ReadData, DUT.RegWrite, DUT.MemWrite);
    end
    
endmodule