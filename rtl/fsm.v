`timescale 1ps/1ps
module fsm(
    input clk,
    input reset,
    output fetch,
    output decode,
    output execute,
    output memory,
    output writeback
);

    // temp reg for counter
    reg [2:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 3'd0; // Initial state
        end else if (state == 3'd5) begin
            state <= 3'd0; // Second reset for state
        end else begin
            state <= state + 3'd1; // Normal state transition
        end
    end

    assign fetch = (state == 3'd0);
    assign decode = (state == 3'd1);
    assign execute = (state == 3'd2);
    assign memory = (state == 3'd3);
    assign writeback = (state == 3'd4);


endmodule