`timescale 1ps/1ps
module register_file(
    input clk,
    input reset,
    input we,
    input[2:0] addrA,
    input[2:0] addrB,
    input[2:0] addrR,
    input[15:0] dataR,
    output reg[15:0] dataA,
    output reg[15:0] dataB
);
    
    // addrR decoder
    wire r0 = (addrR == 3'b000);
    wire r1 = (addrR == 3'b001);
    wire r2 = (addrR == 3'b010);
    wire r3 = (addrR == 3'b011);
    wire r4 = (addrR == 3'b100);
    wire r5 = (addrR == 3'b101);
    wire r6 = (addrR == 3'b110);
    wire r7 = (addrR == 3'b111);

    // Write enables
    wire we_r0, we_r1, we_r2, we_r3, we_r4, we_r5, we_r6, we_r7;
    assign we_r0 = we & r0;
    assign we_r1 = we & r1;
    assign we_r2 = we & r2;
    assign we_r3 = we & r3;
    assign we_r4 = we & r4;
    assign we_r5 = we & r5;
    assign we_r6 = we & r6;
    assign we_r7 = we & r7;

    // Registers
    reg [15:0] reg0, reg1, reg2, reg3, reg4, reg5, reg6, reg7;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reg0 <= 16'b0;
            reg1 <= 16'b0;
            reg2 <= 16'b0;
            reg3 <= 16'b0;
            reg4 <= 16'b0;
            reg5 <= 16'b0;
            reg6 <= 16'b0;
            reg7 <= 16'b0;
        end else begin
            if (we_r0) reg0 <= dataR;
            if (we_r1) reg1 <= dataR;
            if (we_r2) reg2 <= dataR;
            if (we_r3) reg3 <= dataR;
            if (we_r4) reg4 <= dataR;
            if (we_r5) reg5 <= dataR;
            if (we_r6) reg6 <= dataR;
            if (we_r7) reg7 <= dataR;
        end
    end

    always @(*) begin
        case(addrA)
            3'b000: dataA = reg0;
            3'b001: dataA = reg1;
            3'b010: dataA = reg2;
            3'b011: dataA = reg3;
            3'b100: dataA = reg4;
            3'b101: dataA = reg5;
            3'b110: dataA = reg6;
            3'b111: dataA = reg7;
            default: dataA = 16'b0;
        endcase
    end

    always @(*) begin
        case(addrB)
            3'b000: dataB = reg0;
            3'b001: dataB = reg1;
            3'b010: dataB = reg2;
            3'b011: dataB = reg3;
            3'b100: dataB = reg4;
            3'b101: dataB = reg5;
            3'b110: dataB = reg6;
            3'b111: dataB = reg7;
            default: dataB = 16'b0;
        endcase
    end

endmodule
