module pc_plus4 #(parameter WIDTH = 32)(
    input [WIDTH-1:0] PC,
    output [WIDTH-1:0] PCPlus4
);
    assign PCPlus4 = PC + 4;
endmodule
