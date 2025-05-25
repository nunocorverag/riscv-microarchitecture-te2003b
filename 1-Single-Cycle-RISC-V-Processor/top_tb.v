`timescale 1ns/1ps

module top_tb();

    // Parameters matching the top module
    localparam DATA_WIDTH = 32;
    localparam ADDR_WIDTH = 8;

    // Clock signal
    reg clk;

    // Reset signal
    reg rst;

    // Control signal for PC flow (for testing)
    reg PCSrc;

    top DUT (
        .clk(clk),
        .rst(rst),
		.PCSrc_in(PCSrc)
    );

    // Generate clock with 10ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Initialize signals and simulate changes in PCSrc
    initial begin
        rst = 0;
        #10;
        rst = 1;
        #10;
        PCSrc = 0; // Start sequential (PC + 4)
        rst = 0;
        #10;
        PCSrc = 1; // Simulate branch/jump (PC + 16)
        #10;
        PCSrc = 0; // Return to sequential
        #10;
        $stop; // Stop simulation
    end
endmodule
