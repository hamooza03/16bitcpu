module instr_rom(
    input[15:0] addr,
    output reg[15:0] instr
);
    always @(*) begin
        case (addr)
            16'h0000: instr = 16'b0000_0100_1001_0000; // 
            16'h0001: instr = 16'b0000_0101_0010_0001; // 
            16'h0002: instr = 16'b0000_0101_1011_0011; // 
            16'h0003: instr = 16'b1100_0100_1010_0000; //
            // Add more instructions as needed
            default:   instr = 16'b0000000000000000; // NOP for undefined addresses
        endcase
    end

endmodule