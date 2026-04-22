`timescale 1ns / 1ps

// ----------------------------------------
// © Copyright CUBLAZER All Right Reserved.
//
// Abstract : Precharge bank information shift module with synchronous FIFO
// File Name : PreCh_BKinf_Shift_nACU.v
// Module Name : PreCh_BKinf_Shift_nACU
// Revision Histrory:
//      v1.0 zhuang nACU 2026-04-02
//           style cleanup only, no functional change
// ----------------------------------------

module PreCh_BKinf_Shift_nACU (
    // clock and reset
    input  wire        CK_nACU,           // Fast main clock
    input  wire        CK_div2_nACU,      // Divider-by-2 clock, main working clock
    input  wire        Reset,             // Active-high asynchronous reset

    // raw command and address inputs from top
    input  wire        PreCh_wo_nACU,     // Precharge command valid
    input  wire        PreCh_SC_wo_nACU,  // Sub-channel flag
    input  wire        PreCh_AB_wo_nACU,  // All-bank flag
    input  wire        PreCh_BA0_wo_nACU, // Bank address bit 0
    input  wire        PreCh_BA1_wo_nACU, // Bank address bit 1
    input  wire        PreCh_BG0_wo_nACU, // Bank group address bit 0
    input  wire        PreCh_BG1_wo_nACU, // Bank group address bit 1

    // read control from main shift module
    input  wire        PreCh_fifo_out1,
    input  wire        PreCh_fifo_out2,

    // final fine delay control from MR_DEC
    input  wire        Shift4_en,
    input  wire        Shift4_mux,

    // final precharge output to glue module
    output wire [31:0] prech_w_nACU
);

    // 1. Pack input data
    wire [5:0] bkinf_in = {
        PreCh_AB_wo_nACU,
        PreCh_SC_wo_nACU,
        PreCh_BG1_wo_nACU,
        PreCh_BG0_wo_nACU,
        PreCh_BA1_wo_nACU,
        PreCh_BA0_wo_nACU
    };

    // 2. Gated clock generation through clk_gate instances
    wire clk_fifo_in;
    wire read_req_comb;
    wire clk_fifo_out;

    assign read_req_comb = PreCh_fifo_out1 | PreCh_fifo_out2;

    clk_gate u_clk_gate_fifo_in (
        .clk_in    (CK_div2_nACU),
        .en        (PreCh_wo_nACU),
        .clk_gated (clk_fifo_in)
    );

    clk_gate u_clk_gate_fifo_out (
        .clk_in    (CK_div2_nACU),
        .en        (read_req_comb),
        .clk_gated (clk_fifo_out)
    );

    // 3. Synchronous FIFO core with FWFT architecture
    reg  [5:0] fifo_mem [0:23];
    reg  [4:0] wr_ptr;
    reg  [4:0] rd_ptr;

    always @(posedge clk_fifo_in or posedge Reset) begin
        if (Reset) begin
            wr_ptr <= 5'd0;
        end else begin
            fifo_mem[wr_ptr] <= bkinf_in;
            wr_ptr <= (wr_ptr == 5'd23) ? 5'd0 : wr_ptr + 1'b1;
        end
    end

    wire [5:0] fifo_out_data = fifo_mem[rd_ptr];

    // 4. Decode combinational logic
    wire       out_ab = fifo_out_data[5];
    wire       out_sc = fifo_out_data[4];
    wire [1:0] out_bg = fifo_out_data[3:2];
    wire [1:0] out_ba = fifo_out_data[1:0];

    wire [15:0] dec_half = 16'b1 << {out_bg, out_ba};
    wire [31:0] dec_full = out_ab ? 32'hFFFF_FFFF : 
                           (out_sc ? {dec_half, 16'b0} : {16'b0, dec_half});

    // 5. Read gating and registered output stage
    reg  read_toggle;
    reg  [31:0] prech_ck2_out;

    always @(posedge clk_fifo_out or posedge Reset) begin
        if (Reset) begin
            read_toggle   <= 1'b0;
            rd_ptr        <= 5'd0;
            prech_ck2_out <= 32'b0;
        end else begin
            read_toggle <= ~read_toggle;
            
            if (read_toggle == 1'b0) begin
                prech_ck2_out <= dec_full;
                rd_ptr <= (rd_ptr == 5'd23) ? 5'd0 : rd_ptr + 1'b1;
            end else begin
                prech_ck2_out <= 32'b0;
            end
        end
    end

    // 6. Final fine delay control for Shift4
    reg [31:0] prech_ck_dly;

    always @(posedge CK_nACU or posedge Reset) begin
        if (Reset) begin
            prech_ck_dly <= 32'b0;
        end else if (Shift4_en) begin
            prech_ck_dly <= prech_ck2_out;
        end
    end

    assign prech_w_nACU = Shift4_mux ? prech_ck_dly : prech_ck2_out;

endmodule
