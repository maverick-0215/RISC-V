`timescale 1ns/1ps
module Microprocessor_utype_test_tb();

    // -------------------------------
    // Testbench signals
    // -------------------------------
    reg clk;        // Clock signal
    reg rst;        // Reset signal
    integer i;      // Loop variable
    integer errors; // Error counter

    // -------------------------------
    // Opcode definitions (RISC-V)
    // -------------------------------
    localparam [6:0] OP_R     = 7'b0110011; // R-type (ADD, SUB, etc.)
    localparam [6:0] OP_LUI   = 7'b0110111; // LUI instruction
    localparam [6:0] OP_AUIPC = 7'b0010111; // AUIPC instruction

    // NOP instruction → addi x0, x0, 0
    localparam [31:0] NOP = 32'h00000013;

    // -------------------------------
    // R-type encoding function
    // Used for ADD instruction
    // -------------------------------
    function [31:0] enc_r;
        input [6:0] funct7;
        input [4:0] rs2;
        input [4:0] rs1;
        input [2:0] funct3;
        input [4:0] rd;
        input [6:0] opcode;
        begin
            // R-type format:
            // [funct7 | rs2 | rs1 | funct3 | rd | opcode]
            enc_r = {funct7, rs2, rs1, funct3, rd, opcode};
        end
    endfunction

    // -------------------------------
    // U-type encoding function
    // Used for LUI and AUIPC
    // -------------------------------
    function [31:0] enc_u;
        input [19:0] imm;
        input [4:0] rd;
        input [6:0] opcode;
        begin
            // U-type format:
            // [imm(31:12) | rd | opcode]
            enc_u = {imm, rd, opcode};
        end
    endfunction

    // -------------------------------
    // Device Under Test (DUT)
    // -------------------------------
    microprocessor u_microprocessor0 (
        .clk(clk),
        .rst(rst)
    );

    // -------------------------------
    // Clock generation (10 ns period)
    // -------------------------------
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 0;        // Start without reset
        errors = 0;

        // -------------------------------
        // Initialize instruction memory
        // Fill with NOPs to avoid garbage execution
        // -------------------------------
        for (i = 0; i < 16; i = i + 1) begin
            u_microprocessor0.u_instruction_memory.u_memory.mem[i] = NOP;
        end

        // -------------------------------------------
        // PROGRAM DESCRIPTION
        //
        // Address | Instruction
        // -------------------------------------------
        // 0 (PC=0)   : LUI   x4, 0x12345   → x4 = 0x12345000
        // 1 (PC=4)   : AUIPC x3, 0x00001   → x3 = PC + 0x1000
        // 2 (PC=8)   : ADD   x7, x4, x3    → x7 = x4 + x3
        // 3 (PC=12)  : NOP
        // -------------------------------------------

        // LUI: Load upper immediate into x4
        u_microprocessor0.u_instruction_memory.u_memory.mem[0] =
            enc_u(20'h12345, 5'd4, OP_LUI);

        // AUIPC: Add immediate to PC and store in x3
        // Expected: x3 = 4 + 0x1000 = 0x1004
        u_microprocessor0.u_instruction_memory.u_memory.mem[1] =
            enc_u(20'h00001, 5'd3, OP_AUIPC);

        // ADD: x7 = x4 + x3
        u_microprocessor0.u_instruction_memory.u_memory.mem[2] =
            enc_r(7'b0000000, 5'd4, 5'd3, 3'b000, 5'd7, OP_R);

        // -------------------------------
        // Apply reset
        // -------------------------------
        #20;
        rst = 1;   // Assert reset

        #200;      // Wait for execution (pipeline delay)

        // -------------------------------------------
        // CHECK RESULTS
        // -------------------------------------------

        //  Check LUI result
        if (u_microprocessor0.u_core.u_decodestage.u_regfile0.register[4] !== 32'h12345000) begin
            $display("FAIL: LUI wrong, x4=%h",
                u_microprocessor0.u_core.u_decodestage.u_regfile0.register[4]);
            errors = errors + 1;
        end else begin
            $display("PASS: LUI");
        end

        //  Check AUIPC result
        // PC = 4 → x3 = 4 + 0x1000 = 0x1004
        if (u_microprocessor0.u_core.u_decodestage.u_regfile0.register[3] !== 32'h00001004) begin
            $display("FAIL: AUIPC wrong, x3=%h",
                u_microprocessor0.u_core.u_decodestage.u_regfile0.register[3]);
            errors = errors + 1;
        end else begin
            $display("PASS: AUIPC");
        end

        //  Check ADD result
        // x7 = x4 + x3 = 0x12345000 + 0x00001004
        if (u_microprocessor0.u_core.u_decodestage.u_regfile0.register[7] !==
            (32'h12345000 + 32'h00001004)) begin
            $display("FAIL: ADD wrong, x7=%h",
                u_microprocessor0.u_core.u_decodestage.u_regfile0.register[7]);
            errors = errors + 1;
        end else begin
            $display("PASS: ADD");
        end

        // -------------------------------------------
        // FINAL RESULT
        // -------------------------------------------
        if (errors == 0) begin
            $display("RESULT: PASS");
        end else begin
            $display("RESULT: FAIL (%0d errors)", errors);
        end

        $finish;
    end

endmodule
