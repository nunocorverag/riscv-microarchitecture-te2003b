module pc_target #(parameter WIDTH = 32)(
    input [WIDTH-1:0] PC,
    input [WIDTH-1:0] immExt,
    output [WIDTH-1:0] PCTarget
);
    assign PCTarget = PC + immExt;
endmodule
