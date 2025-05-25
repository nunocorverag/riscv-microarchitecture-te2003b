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

    // Control signal for immediate source selection (for testing)
    reg [1:0] immSrc;

    top DUT (
        .clk(clk),
        .rst(rst),
		.PCSrc_in(PCSrc),
        .immSrc_in(immSrc)
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
        rst = 0;
        immSrc = 0; // I-type immediate
        PCSrc = 0; // Start sequential (PC + 4)
        #10;
        immSrc = 1; // S-type immediate
        #10;
        immSrc = 2; // B-type immediate
        #10;
        immSrc = 3; // J-type immediate
        #10;
        $stop; // Stop simulation
    end
endmodule
