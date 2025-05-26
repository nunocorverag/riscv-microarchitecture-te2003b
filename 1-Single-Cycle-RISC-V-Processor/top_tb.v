module top_tb();
    localparam DATA_WIDTH = 32;
    localparam ADDR_WIDTH = 8;
   
    reg clk;
    reg rst;
    integer j;
   
    top #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDR_WIDTH(ADDR_WIDTH)
    ) DUT (
        .clk(clk),
        .rst(rst)
    );
   
    always #5 clk = ~clk;
   
    initial begin
        $display("=== INSTRUCTION-SPECIFIC TESTBENCH ===");
        
        // Inicializar
        clk = 0;
        rst = 1;
        #10;
        rst = 0;

        #500;

        $display("=== CONTENIDO DE MEMORIA (0x000 a 0x3FF) ===");
        for (j = 0; j < 1024; j = j + 1) begin
            $display("Mem[0x%03h] = 0x%08h", j, DUT.DMEM.Data_mem[j]);
        end
        $finish;
    end
endmodule