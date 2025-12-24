module fsm_tb();
    reg clk = 0;
    reg reset = 0;
    wire fetch, decode, execute, memory, writeback;

    fsm dut (
        .clk(clk),
        .reset(reset),
        .fetch(fetch),
        .decode(decode),
        .execute(execute),
        .memory(memory),
        .writeback(writeback)
    );

    always #5 clk = ~clk; // 100 MHz clock

    initial begin
        $dumpfile("fsm_tb.vcd");
        $dumpvars(0, fsm_tb);

        // Reset the FSM
        reset = 1'b1;
        @(posedge clk);
        reset = 1'b0;

        // Run through several cycles to observe state transitions
        repeat (12) begin
            @(posedge clk);
            #1; // small delay to allow outputs to settle
            $display("State: fetch=%b decode=%b execute=%b memory=%b writeback=%b",
                     fetch, decode, execute, memory, writeback);
        end

        $finish;
    end

endmodule