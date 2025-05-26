// Module: instruction_memory
// Description: Stores instructions for the processor. 
//              Reads instructions from a file at initialization.
//              Outputs instruction at given byte address (word-aligned).

module instruction_memory #(
    parameter ADDR_WIDTH = 8,          // Address width (number of index bits)
    parameter DATA_WIDTH = 32          // Data width (bits per instruction)
)(
    input [DATA_WIDTH-1:0] A,          // Byte address input
    output reg [DATA_WIDTH-1:0] RD     // Instruction output
);

// Internal ROM storage for instructions
reg [DATA_WIDTH-1:0] ROM [(2**ADDR_WIDTH)-1:0];

// Initialize ROM to zero before loading from file
integer i;
initial begin
    for (i = 0; i < (2**ADDR_WIDTH); i = i + 1) begin
        ROM[i] = 32'b0;
    end
    $readmemh("instructions.hex", ROM); // Load instructions from file
end

always @(*) begin
    // Read instruction from ROM at the given address
    RD = ROM[A[ADDR_WIDTH-1:2]]; // Word-aligned access (2 bits for byte offset)
end

endmodule
