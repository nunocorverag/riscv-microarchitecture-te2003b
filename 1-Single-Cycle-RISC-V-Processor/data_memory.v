// Module: data_memory
// Description: Data memory with combinational read and synchronous write
module data_memory #(parameter DATA_WIDTH = 32) (
    input clk,         // Clock signal
    input WE,          // Write Enable signal (1 = write, 0 = read)
    input [DATA_WIDTH-1:0] A,    // Address input (memory address for access)
    input [DATA_WIDTH-1:0] WD,   // Write Data input (data to be stored)
    output [DATA_WIDTH-1:0] RD   // Read Data output (data to be read) - now combinational
);

// Memory array declaration: 32-bit wide, 1024 locations 
reg [DATA_WIDTH-1:0] Data_mem [1023:0];

// Initialize memory to zero
integer i;
initial begin
    for (i = 0; i < 1024; i = i + 1) begin
        Data_mem[i] = 32'h00000000;
    end
end

// Combinational read - data available immediately
assign RD = Data_mem[A[9:0]]; // Use only lower 10 bits for addressing

// Sequential write - only on clock edge when WE is active
always @(posedge clk) begin
    if (WE) begin
        Data_mem[A[9:0]] <= WD;
    end
end

endmodule