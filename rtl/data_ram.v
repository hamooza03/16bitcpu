module data_ram(
    input clk,
    input store,
    input[15:0] addr,
    input[15:0] data_in,
    output reg[15:0] data_out
);
    reg [15:0] memory [0:65535]; // 256 x 16-bit memory

    always @(posedge clk) begin
        if (store) begin
            memory[addr] <= data_in; // Store data
        end
    end

    assign data_out = memory[addr]; // Read data

endmodule