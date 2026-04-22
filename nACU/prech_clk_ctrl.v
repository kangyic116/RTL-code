// ----------------------------------------
// © Copyright CUBLAZER All Right Reserved.
//
// Abstract  : Clock gating, divide-by-2 and down-counter
//             logic for precharge shift pipeline
// File Name : prech_clk_ctrl.v
// Module Name : prech_clk_ctrl
// Revision History:
//      ver1.0 - Initial version
// ----------------------------------------

module prech_clk_ctrl (
    // Clock and Reset
    input  wire       clk_2,          // Divided-by-2 clock source (CK/2)
    input  wire       rst_n,          // Asynchronous active-low reset

    // Control inputs
    input  wire       clk_en_set,     // Clock enable trigger from input stage
    input  wire [1:0] shift0_sc_in,   // Shift stage-0 tag for counter reset
    input  wire       div2_en,        // Divide-by-2 function enable
    input  wire       clk_mux,        // Clock select: 0=gated, 1=div2

    input  wire [4:0] value_for_rst,  // Counter reload value on reset

    // Outputs
    output wire       clk_main_shift, // Main shift clock output
    output wire       shift_ck_en_s   // Clock enable request to top level
);

    // Internal signals
    reg  [4:0] clk_en_cnt;       // Down-counter for clock enable duration
    wire       cnt_not_end;      // Counter non-zero flag
    wire       set_on;           // Alias for clock enable trigger
    reg        shift_ck_en_s_reg;// Registered clock enable request
    wire       gate_en;          // Combined gate enable
    wire       gated_clk;        // Clock after gating
    reg        div2_clk;         // Divide-by-2 output register
    wire       cnt_reset;        // Counter reload condition

    // ====================================================================
    // 1. Counter status and clock enable request generation
    // ====================================================================
    assign cnt_not_end = (clk_en_cnt != 5'h00);
    assign set_on      = clk_en_set;

    always @(posedge clk_2 or negedge rst_n) begin
        if (!rst_n) begin
            shift_ck_en_s_reg <= 1'b0;
        end else begin
            shift_ck_en_s_reg <= set_on | cnt_not_end;
        end
    end

    assign shift_ck_en_s = shift_ck_en_s_reg;

    // ====================================================================
    // 2. Clock gating instance
    // ====================================================================
    assign gate_en = clk_en_set | shift_ck_en_s;

    clk_gate u_clk_gate (
        .clk_in   (clk_2),
        .en       (gate_en),
        .clk_gated(gated_clk)
    );

    // ====================================================================
    // 3. Divide-by-2 logic and clock mux
    // ====================================================================
    always @(posedge gated_clk or negedge rst_n) begin
        if (!rst_n) begin
            div2_clk <= 1'b0;
        end else if (div2_en) begin
            div2_clk <= ~div2_clk;
        end else begin
            div2_clk <= 1'b0;
        end
    end

    assign clk_main_shift = clk_mux ? div2_clk : gated_clk;

    // ====================================================================
    // 4. Down-counter on main shift clock
    // ====================================================================
    assign cnt_reset = (shift0_sc_in == 2'b10 || shift0_sc_in == 2'b11);

    always @(posedge clk_main_shift or negedge rst_n) begin
        if (!rst_n) begin
            clk_en_cnt <= 5'h00;
        end else if (cnt_reset) begin
            clk_en_cnt <= value_for_rst;
        end else if (cnt_not_end) begin
            clk_en_cnt <= clk_en_cnt - 1'b1;
        end
    end

endmodule
