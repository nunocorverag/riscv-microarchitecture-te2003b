// Module: register_file
// Description: Implements a 32-register file, each 32 bits wide.
// Allows reading from two source registers and writing to one destination register.

module register_file #(parameter DATA_WIDTH = 32) (
    input clk,            // Clock signal
    input WE3,            // Write Enable signal for writing to the destination register
    input [4:0] A1,       // Address of source register 1 (rs1)
    input [4:0] A2,       // Address of source register 2 (rs2)
    input [4:0] A3,       // Address of destination register (rd)
    input [DATA_WIDTH-1:0] WD3,     // Data to write into register rd
    output reg [DATA_WIDTH-1:0] RD1,    // Output: Data read from register rs1
    output reg [DATA_WIDTH-1:0] RD2     // Output: Data read from register rs2
);

// Declare 32 general-purpose registers, each 32 bits wide
reg [DATA_WIDTH-1:0] REG [31:0];

// Combinational logic: Read values from rs1 and rs2
always @(*) begin
    RD1 = REG[A1];  // Read register specified by A1 (rs1)
    RD2 = REG[A2];  // Read register specified by A2 (rs2)
end

// Sequential logic: Write to register rd on the rising edge of the clock if WE3 is high
always @(posedge clk) begin
    if (WE3) begin
        REG[A3] <= WD3;  // Write WD3 to register specified by A3 (rd)
    end
end

endmodule