`timescale 1ps/1ps
module alu_tb;
    reg  [15:0] A, B;
    reg  [2:0]  fun;
    wire N, Z, C, V;
    wire [15:0] R;

    alu dut (.A(A), .B(B), .fun(fun), .N(N), .Z(Z), .C(C), .V(V), .R(R));

    task do_test;
        input [15:0] a, b;
        input [2:0]  op;
        reg   [16:0] expR_ext;
        reg   [15:0] expR;
        reg   expN, expZ, expC, expV;
    begin
        A = a; B = b; fun = op;
        #1;

        // Expected result (17-bit for carry/borrow)
        case (op)
            3'b000: expR_ext = {1'b0, a} + {1'b0, b};
            3'b001: expR_ext = {1'b0, a} - {1'b0, b};
            3'b010: expR_ext = {1'b0, (a & b)};
            3'b011: expR_ext = {1'b0, (a | b)};
            3'b100: expR_ext = {1'b0, ~(a | b)};
            3'b101: expR_ext = {1'b0, (a << b[3:0])};
            3'b110: expR_ext = {1'b0, (a >> b[3:0])};
            3'b111: expR_ext = {1'b0, ($signed(a) >>> b[3:0])};
            default: expR_ext = 17'd0;
        endcase
        expR = expR_ext[15:0];

        // Flags (C_sub = ~borrow to match your ALU)
        expN = expR[15];
        expZ = (expR == 16'd0);
        expC = (op == 3'b000) ? expR_ext[16] :
               (op == 3'b001) ? ~expR_ext[16] : 1'b0;
        expV = (op == 3'b000) ? ((a[15] == b[15]) && (expR[15] != a[15])) :
               (op == 3'b001) ? ((a[15] != b[15]) && (expR[15] != a[15])) : 1'b0;

        if (R !== expR || N !== expN || Z !== expZ || C !== expC || V !== expV) begin
            $display("FAIL op=%b A=%h B=%h expR=%h gotR=%h expN=%b gotN=%b expZ=%b gotZ=%b expC=%b gotC=%b expV=%b gotV=%b",
                     op, a, b, expR, R, expN, N, expZ, Z, expC, C, expV, V);
            $stop;
        end else begin
            $display("PASS op=%b A=%h B=%h -> R=%h N=%b Z=%b C=%b V=%b", op, a, b, R, N, Z, C, V);
        end
    end
    endtask

    initial begin
        do_test(16'h0001, 16'h0001, 3'b000);
        do_test(16'hFFFF, 16'h0001, 3'b000);
        do_test(16'h7FFF, 16'h0001, 3'b000);
        do_test(16'h0003, 16'h0007, 3'b001);
        do_test(16'h0000, 16'h0001, 3'b001);
        do_test(16'h8000, 16'h7FFF, 3'b001);
        do_test(16'h00FF, 16'h0F0F, 3'b010);
        do_test(16'h00FF, 16'h0F0F, 3'b011);
        do_test(16'h00FF, 16'h0F0F, 3'b100);
        do_test(16'h0001, 16'h0004, 3'b101);
        do_test(16'h8000, 16'h0001, 3'b110);
        do_test(16'h8000, 16'h0001, 3'b111);

        $display("All tests completed.");
        $finish;
    end
endmodule
