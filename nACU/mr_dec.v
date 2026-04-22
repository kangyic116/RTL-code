`timescale 1ns / 1ps

// ----------------------------------------
// © Copyright CUBLAZER All Right Reserved.
//
// Abstract : MR decode module for PreCh_Shift_nACU control generation
// File Name : mr_dec.v
// Module Name : MR_Dec
// Revision Histrory:
//      v1.0 zhuang nACU 2026-04-02
//           style cleanup only, no functional change
// ----------------------------------------

module MR_Dec (
    // input interface
    input  wire [4:0] MR1_OP,        // Selects the nACU clock cycle count
    input  wire       MR11_OP_4,     // DVFSL enable flag, noted as MROP[5] in spec
    input  wire       Edge_flag,     // Odd/even phase difference flag
    input  wire       PracEn,        // Module global enable
    input  wire       EcsEnWin,      // Reserved ECS window indicator input

    // output interface
    output wire       T3_en,         // Enables the third DFF in input_shift
    output wire       Div2_en,       // Internal divider-by-2 enable
    output wire       Clk_mux,       // main_shift clock select
    output wire       Save_edge_en,  // save_edge_dff enable
    output wire       Shift0_mux,    // main_shift input select
    output wire       Odd_shift_en,  // main_shift odd-cycle enable
    output wire       Odd_mux,       // main_shift odd-cycle select
    output wire       Switch00,      // main_shift zero-delay capture select
    output wire [7:0] Switch0_7,     // main_shift output routing control
    output wire [7:0] Gate0_7,       // main_shift clock gating control
    output wire       Shift2_en,     // output_shift logic-path enable
    output wire       Shift2_mux,    // output_shift logic-path select
    output wire       Shift4_en,     // output_shift FIFO-path enable
    output wire       Shift4_mux,    // output_shift FIFO-path select
    output wire [4:0] Value_for_rst  // Initialization value for clk_en_cnt
);

    // internal signal declaration
    localparam integer CTRL_BUS_W = 33;

    wire [6:0] dec_sel;
    reg  [CTRL_BUS_W-1:0] ctrl_bus;

    // control bus field mapping
    assign Div2_en       = ctrl_bus[32];
    assign Clk_mux       = ctrl_bus[31];
    assign Save_edge_en  = ctrl_bus[30];
    assign Shift0_mux    = ctrl_bus[29];
    assign Odd_shift_en  = ctrl_bus[28];
    assign Odd_mux       = ctrl_bus[27];
    assign Switch00      = ctrl_bus[26];
    assign Switch0_7     = ctrl_bus[25:18];
    assign Gate0_7       = ctrl_bus[17:10];
    assign Shift2_en     = ctrl_bus[9];
    assign Shift2_mux    = ctrl_bus[8];
    assign Shift4_en     = ctrl_bus[7];
    assign Shift4_mux    = ctrl_bus[6];
    assign T3_en         = ctrl_bus[5];
    assign Value_for_rst = ctrl_bus[4:0];

    assign dec_sel = {MR1_OP, MR11_OP_4, Edge_flag};

    // EcsEnWin is reserved for interface compatibility.
    wire unused_ok;
    assign unused_ok = EcsEnWin;

    // core decode logic
    always @(*) begin
        ctrl_bus = 0;

        if (!PracEn) begin
            ctrl_bus = 0;
        end
        else begin
            case (dec_sel)
                // {Div2, Clk_mux, Save, S0_mux, Odd_en, Odd_mux, Sw00,
                //  Switch0_7[7:0], Gate0_7[7:0], S2_en, S2_mux, S4_en, S4_mux,
                //  T3_en, Value_for_rst[4:0]}

                // low speed mode
                7'b00000_0_0: ctrl_bus = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 8'h00, 8'h00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 5'd4};
                7'b00000_1_0: ctrl_bus = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 8'h00, 8'h00, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 5'd4};

                7'b00001_0_0: ctrl_bus = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 8'h00, 8'h00, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 5'd5};
                7'b00001_1_0: ctrl_bus = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 8'h01, 8'h01, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 5'd6};

                7'b00010_0_0: ctrl_bus = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 8'h01, 8'h01, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 5'd7};
                7'b00010_1_0: ctrl_bus = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 8'h02, 8'h02, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 5'd8};

                7'b00011_0_0: ctrl_bus = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 8'h02, 8'h02, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 5'd9};
                7'b00011_1_0: ctrl_bus = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 8'h04, 8'h04, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 5'd10};

                7'b00100_0_0: ctrl_bus = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 8'h04, 8'h04, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 5'd10};
                7'b00100_1_0: ctrl_bus = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 8'h04, 8'h04, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 5'd11};

                7'b00101_0_0: ctrl_bus = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 8'h04, 8'h04, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 5'd11};

                7'b00110_0_0: ctrl_bus = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 8'h08, 8'h08, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 5'd13};

                7'b00111_0_0: ctrl_bus = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 8'h10, 8'h10, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 5'd14};

                7'b01000_0_0: ctrl_bus = {1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 8'h20, 8'h20, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 5'd16};

                7'b01001_0_0: ctrl_bus = {1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 8'h40, 8'h40, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 5'd19};

                // high speed mode
                7'b01010_0_0: ctrl_bus = {1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 8'h08, 8'h08, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 5'd10};
                7'b01010_0_1: ctrl_bus = {1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 8'h00, 8'h00, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 5'd9};

                7'b01011_0_0: ctrl_bus = {1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 8'h08, 8'h08, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 5'd11};
                7'b01011_0_1: ctrl_bus = {1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 8'h00, 8'h00, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 5'd10};

                7'b01100_0_0: ctrl_bus = {1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 8'h10, 8'h10, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 5'd12};
                7'b01100_0_1: ctrl_bus = {1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 8'h00, 8'h00, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 5'd12};

                7'b01101_0_0: ctrl_bus = {1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 8'h20, 8'h20, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 5'd14};
                7'b01101_0_1: ctrl_bus = {1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 8'h00, 8'h00, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 5'd13};

                7'b01110_0_0: ctrl_bus = {1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 8'h20, 8'h20, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 5'd15};
                7'b01110_0_1: ctrl_bus = {1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 8'h00, 8'h00, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 5'd15};

                7'b01111_0_0: ctrl_bus = {1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 8'h40, 8'h40, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1, 5'd17};
                7'b01111_0_1: ctrl_bus = {1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 8'h00, 8'h00, 1'b1, 1'b1, 1'b1, 1'b1, 1'b1, 5'd16};

                7'b10000_0_0: ctrl_bus = {1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 8'h80, 8'h80, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 5'd19};
                7'b10000_0_1: ctrl_bus = {1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 8'h00, 8'h00, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 5'd19};

                default: ctrl_bus = 0;
            endcase
        end
    end

endmodule
