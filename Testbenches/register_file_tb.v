`timescale 1ps/1ps
module register_file_tb;
    reg         clk   = 0;
    reg         reset = 0;
    reg         we    = 0;
    reg  [2:0]  addrA = 0, addrB = 0, addrR = 0;
    reg  [15:0] dataR = 0;
    wire [15:0] dataA, dataB;

    register_file dut (
        .clk(clk), .reset(reset), .we(we),
        .addrA(addrA), .addrB(addrB), .addrR(addrR),
        .dataR(dataR), .dataA(dataA), .dataB(dataB)
    );

    reg [15:0] expect [0:7];
    integer i;

    always #5 clk = ~clk;  // 100 MHz equiv in 1ps units

    task write_reg(input [2:0] idx, input [15:0] val);
    begin
        @(negedge clk);
        addrR = idx;
        dataR = val;
        we    = 1'b1;
        @(posedge clk);     // captured on rising edge
        we    = 1'b0;
        addrR = 3'b000;
        dataR = 16'h0000;
    end
    endtask

    task check_read(input [2:0] idxA, input [2:0] idxB);
    begin
        addrA = idxA;
        addrB = idxB;
        #1; // allow combinational read to settle
        if (dataA !== expect[idxA] || dataB !== expect[idxB]) begin
            $display("READ FAIL A[%0d]=%h(exp %h) B[%0d]=%h(exp %h)",
                     idxA, dataA, expect[idxA], idxB, dataB, expect[idxB]);
            $stop;
        end
    end
    endtask

    initial begin
        //$dumpfile("register_file_tb.vcd");
        //$dumpvars(0, register_file_tb);

        for (i = 0; i < 8; i = i + 1) expect[i] = 16'h0000;

        // reset pulse
        reset = 1'b1;
        @(posedge clk);
        reset = 1'b0;
        @(posedge clk);
        check_read(3'd0, 3'd7);

        // Write values into registers
        for (i = 0; i < 8; i = i + 1) begin
            write_reg(i[2:0], 16'h1000 + i);
            expect[i] = 16'h1000 + i;
            @(posedge clk); // ensure write has taken effect
            #1;
            check_read(i[2:0], i[2:0]);
        end

        // Dual-port read sanity
        check_read(3'd2, 3'd5);

        // Ensure no write when we=0
        @(negedge clk);
        addrR = 3'd3;
        dataR = 16'hDEAD;
        we    = 1'b0;
        @(posedge clk);
        #1;
        check_read(3'd3, 3'd4);

        $display("All register_file tests passed.");
        $finish;
    end
endmodule
