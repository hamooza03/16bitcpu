`timescale 1ps/1ps
module alu(
    input [15:0] A,  // input 1
    input [15:0] B,  // input 2
    input [2:0] fun, // Selector
    // Flags
    output N, // Negative
    output Z, // Zero
    output C, // Carry
    output V, // Overflow
    output reg [15:0] R
);
    // Intermediate Results
    wire [16:0] R_add, R_sub;
    wire [15:0] R_AND, R_OR, R_NOR, R_LSL, R_LSR, R_ASR;
    wire [16:0] A_ext = {1'b0, A};
    wire [16:0] B_ext = {1'b0, B};
    
    // ALU Intermediate Results
    assign R_add = A_ext + B_ext;
    assign R_sub = A_ext - B_ext;
    assign R_AND = A & B;
    assign R_OR  = A | B;
    assign R_NOR = ~(A | B);
    assign R_LSL = A << B[3:0];
    assign R_LSR = A >> B[3:0];
    assign R_ASR = $signed(A) >>> B[3:0];
    
    // MUX / ALU result selection
    always @(*) begin
        R = 16'd0;
        case(fun)
            3'b000: R = R_add[15:0]; // ADD
            3'b001: R = R_sub[15:0]; // SUB
            3'b010: R = R_AND; // AND
            3'b011: R = R_OR;  // OR
            3'b100: R = R_NOR; // NOR
            3'b101: R = R_LSL; // LSL
            3'b110: R = R_LSR; // LSR
            3'b111: R = R_ASR; // ASR
            default: ;
        endcase
    end

    // Flags
    assign N = R[15]; // Negative
    assign Z = (R == 16'b0); // Zero
    
    // Carry flag for ADD and SUB
    wire C_add = (fun == 3'b000) ? R_add[16] : 1'b0;
    wire C_sub = (fun == 3'b001) ? ~R_sub[16] : 1'b0;
    assign C = C_add | C_sub;

    // Overflow flag for ADD and SUB
    wire V_add, V_sub;
    assign V_add = (fun == 3'b000) ? ((A[15] == B[15]) && (R_add[15] != A[15])) : 1'b0;
    assign V_sub = (fun == 3'b001) ? ((A[15] != B[15]) && (R_sub[15] != A[15])) : 1'b0;
    assign V = V_add | V_sub;

endmodule