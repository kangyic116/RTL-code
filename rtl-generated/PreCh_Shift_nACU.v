module PreCh_Shift_nACU (
    input  wire       CK_div2_nACU,
    input  wire       Reset,
    input  wire       PreCh_wo_nACU,
    input  wire       T3_en,
    input  wire       Div2_en,
    input  wire       _clk_mux,
    input  wire       Save_edge_en,
    input  wire       Shift0_mux,
    input  wire       Oddshift_en,
    input  wire       Odd_mux,
    input  wire       Switch00,
    input  wire [7:0] Switch0_7,
    input  wire [7:0] Gate0_7,
    input  wire       Shift2_en,
    input  wire       Shift2_mux,
    input  wire [4:0] Value_for_rst,
    output wire       PreCh_clk_en,
    output wire       PreCh_fifo_out1,
    output wire       PreCh_fifo_out2
);
    wire input_main_cmd;
    wire input_activity;
    wire main_ce;
    wire main_shift_cmd;

    prech_input_shift u_input_shift (
        .clk(CK_div2_nACU),
        .Reset(Reset),
        .prech_in(PreCh_wo_nACU),
        .T3_en(T3_en),
        .Save_edge_en(Save_edge_en),
        .Shift0_mux(Shift0_mux),
        .main_in(input_main_cmd),
        .activity_hint(input_activity)
    );

    prech_clk_ctrl u_clk_ctrl (
        .clk(CK_div2_nACU),
        .Reset(Reset),
        .activity_hint(input_activity),
        .main_in_pulse(input_main_cmd),
        .Div2_en(Div2_en),
        ._clk_mux(_clk_mux),
        .Value_for_rst(Value_for_rst),
        .PreCh_clk_en(PreCh_clk_en),
        .main_ce(main_ce)
    );

    prech_main_shift u_main_shift (
        .clk(CK_div2_nACU),
        .Reset(Reset),
        .main_ce(main_ce),
        .cmd_in(input_main_cmd),
        .Oddshift_en(Oddshift_en),
        .Odd_mux(Odd_mux),
        .Switch00(Switch00),
        .Switch0_7(Switch0_7),
        .Gate0_7(Gate0_7),
        .cmd_out(main_shift_cmd)
    );

    prech_output_shift u_output_shift (
        .clk(CK_div2_nACU),
        .Reset(Reset),
        .cmd_in(main_shift_cmd),
        .Shift2_en(Shift2_en),
        .Shift2_mux(Shift2_mux),
        .PreCh_fifo_out1(PreCh_fifo_out1),
        .PreCh_fifo_out2(PreCh_fifo_out2)
    );
endmodule

