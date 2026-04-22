// ----------------------------------------
// © Copyright CUBLAZER All Right Reserved.
//
// Abstract  : PreCharge shift top module for nACU,
//             integrating input shift, clock control,
//             main shift and output shift sub-modules
// File Name : PreCh_Shift_nACU.v
// Module Name : PreCh_Shift_nACU
// Revision History:
//      ver1.0 - Initial version
// ----------------------------------------

module PreCh_Shift_nACU (
    // Clock and Reset
    input  wire       CK_div2_nACU,   // Divided-by-2 clock source for nACU
    input  wire       Reset,           // Asynchronous active-low reset

    // Precharge input
    input  wire       PreCh_wo_nACU,   // Precharge input from nACU word-line

    // MR_DEC configuration signals
    input  wire       T3_en,           // T3 pipeline stage enable
    input  wire       Div2_en,         // Divide-by-2 clock enable
    input  wire       Clk_mux,         // Clock mux select: 0=gated, 1=div2
    input  wire       Save_edge_en,    // Edge capture mode enable

    input  wire       Shift0_mux,      // Shift stage-0 source mux select
    input  wire       Odd_shift_en,    // Odd-phase shift enable
    input  wire       Odd_mux,         // Odd-phase mux select
    input  wire       Switch00,        // Switch control bit 0

    input  wire [7:0] Switch0_7,       // Switch control bits [7:0]
    input  wire [7:0] Gate0_7,         // Gate control bits [7:0]
    input  wire       Shift2_en,       // Shift stage-2 enable
    input  wire       Shift2_mux,      // Shift stage-2 mux select

    input  wire [4:0] Value_for_rst,   // Counter reset value

    // Outputs
    output wire       PreCh_clk_en,    // Clock enable request to top level
    output wire       PreCh_fifo_out1, // FIFO output channel 1
    output wire       PreCh_fifo_out2  // FIFO output channel 2
);

    // Internal signals
    wire [1:0] shift0_sc;       // Stage-0 shift shortcut tag
    wire       clk_en_set;      // Clock enable trigger from input stage
    wire       clk_main;        // Main shift clock after gating/mux
    wire [1:0] main_shift_data; // Main shift stage output data

    // Input processing and tag generation
    prech_input_shift u_input_shift (
        .clk_2         (CK_div2_nACU),
        .rst_n         (Reset),

        .prech_in      (PreCh_wo_nACU),
        .t3_en         (T3_en),
        .save_edge_en  (Save_edge_en),
        .shift0_sc_mux (Shift0_mux),

        .shift0_sc_out (shift0_sc),
        .clk_en_set    (clk_en_set)
    );

    // Clock gating and counter control
    prech_clk_ctrl u_clk_ctrl (
        .clk_2         (CK_div2_nACU),
        .rst_n         (Reset),

        .clk_en_set    (clk_en_set),
        .shift0_sc_in  (shift0_sc),
        .div2_en       (Div2_en),
        .clk_mux       (Clk_mux),
        .value_for_rst (Value_for_rst),

        .clk_main_shift(clk_main),
        .shift_ck_en_s (PreCh_clk_en)
    );

    // Core shift operation
    prech_main_shift u_main_shift (
        .clk_main      (clk_main),
        .rst_n         (Reset),

        .shift0_sc_in  (shift0_sc),
        .odd_shift_en  (Odd_shift_en),
        .odd_mux       (Odd_mux),
        .switch00      (Switch00),
        .switch0_7_in  (Switch0_7),
        .gate0_7_in    (Gate0_7),

        .main_shift_out(main_shift_data)
    );

    // Output correction and FIFO drive
    prech_output_shift u_output_shift (
        .clk_2         (CK_div2_nACU),
        .rst_n         (Reset),

        .main_shift_in (main_shift_data),
        .shift2_en_mr  (Shift2_en),
        .shift2_mux_mr (Shift2_mux),

        .fifo_out1     (PreCh_fifo_out1),
        .fifo_out2     (PreCh_fifo_out2)
    );

endmodule
