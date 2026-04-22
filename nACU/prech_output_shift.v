// ----------------------------------------
// © Copyright CUBLAZER All Right Reserved.
//
// Abstract  : Output stage with tag-based dynamic correction,
//             clock gating and FIFO drive
// File Name : prech_output_shift.v
// Module Name : prech_output_shift
// Revision History:
//      ver1.0 - Initial version
// ----------------------------------------

module prech_output_shift (
    // Clock and Reset
    input  wire       clk_2,          // Divided-by-2 clock source
    input  wire       rst_n,          // Asynchronous active-low reset

    // Data and control inputs
    input  wire [1:0] main_shift_in,  // Shift chain output with embedded tag
    input  wire       shift2_en_mr,   // Shift stage-2 enable (MR_DEC config)
    input  wire       shift2_mux_mr,  // Shift stage-2 mux select (MR_DEC config)

    // Outputs
    output wire       fifo_out1,      // FIFO output channel 1
    output wire       fifo_out2       // FIFO output channel 2
);

    // Internal signals
    wire       is_tag_11;          // Tag 2'b11: extra 2 CK/2 cycles detected
    wire       is_tag_10;          // Tag 2'b10: reserved for future use
    wire       actual_shift2_en;   // Corrected shift2 enable after tag check
    wire       actual_shift2_mux;  // Corrected shift2 mux after tag check
    wire       valid_pulse;        // Valid data pulse from shift chain
    wire       shift1_in;          // Shift stage-1 input (rising-edge filter)
    wire       clk_2_gated_shift2; // Gated clock for shift2 register
    reg        shift1_reg;         // Shift stage-1 register
    reg        shift2_reg;         // Shift stage-2 register (gated clock)
    reg        shift3_reg;         // Shift stage-3 register

    // ====================================================================
    // 1. Tag-based dynamic correction
    // ====================================================================
    assign is_tag_11 = (main_shift_in == 2'b11);
    assign is_tag_10 = (main_shift_in == 2'b10);

    // Disable shift2 when tag 11 detected (compensate extra delay)
    assign actual_shift2_en  = is_tag_11 ? 1'b0 : shift2_en_mr;
    assign actual_shift2_mux = is_tag_11 ? 1'b0 : shift2_mux_mr;

    // ====================================================================
    // 2. Valid pulse extraction and rising-edge filter
    // ====================================================================
    assign valid_pulse = main_shift_in[1] | main_shift_in[0];
    assign shift1_in   = valid_pulse & ~shift1_reg;

    // ====================================================================
    // 3. Clock gating for shift stage-2
    // ====================================================================
    clk_gate u_clk_gate_shift2 (
        .clk_in    (clk_2),
        .en        (actual_shift2_en),
        .clk_gated (clk_2_gated_shift2)
    );

    // ====================================================================
    // 4. Shift stage-1 register (always-on clock domain)
    // ====================================================================
    always @(posedge clk_2 or negedge rst_n) begin
        if (!rst_n) begin
            shift1_reg <= 1'b0;
        end else begin
            shift1_reg <= shift1_in;
        end
    end

    // ====================================================================
    // 5. Shift stage-3 register (always-on clock domain)
    // ====================================================================
    always @(posedge clk_2 or negedge rst_n) begin
        if (!rst_n) begin
            shift3_reg <= 1'b0;
        end else begin
            shift3_reg <= actual_shift2_mux ? shift2_reg : shift1_reg;
        end
    end

    // ====================================================================
    // 6. Shift stage-2 register (gated clock domain)
    // ====================================================================
    always @(posedge clk_2_gated_shift2 or negedge rst_n) begin
        if (!rst_n) begin
            shift2_reg <= 1'b0;
        end else begin
            shift2_reg <= shift1_reg;
        end
    end

    // ====================================================================
    // 7. Output assignments
    // ====================================================================
    assign fifo_out1 = actual_shift2_mux ? shift2_reg : shift1_reg;
    assign fifo_out2 = shift3_reg;

endmodule
