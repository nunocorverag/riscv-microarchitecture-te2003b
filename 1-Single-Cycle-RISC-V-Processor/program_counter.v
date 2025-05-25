// Module: program_counter
// Description: Holds the address of the current instruction (Program Counter - PC).
// Updates the PC value on every clock cycle based on the input pcNext.

module program_counter #(parameter DATA_WIDTH = 32)( // Parameterized width, default 32 bits
    input clk,                               // Clock signal
    input rst,                               // Reset signal
    input [DATA_WIDTH-1:0] pcNext,           // Next PC value (calculated externally)
    output reg [DATA_WIDTH-1:0] pc           // Output: Current PC value
);

// Sequential logic: Update the PC value on the rising edge of the clock
always @(posedge clk or posedge rst) begin
    if (rst) begin
        pc <= 0;                         // Reset PC to 0
    end else begin
        pc <= pcNext;                    // Load next PC value
    end
end

endmodule
