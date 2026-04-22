// ----------------------------------------
// © Copyright CUBLAZER All Right Reserved.
//
// Abstract  : Input pipeline (t1/t2/t3), edge capture
//             and shift stage-0 tag generation
// File Name : prech_input_shift.v
// Module Name : prech_input_shift
// Revision History:
//      ver1.0 - Initial version
// ----------------------------------------

module prech_input_shift (
    // Clock and Reset
    input  wire       clk_2,          // Divided-by-2 clock source
    input  wire       rst_n,          // Asynchronous active-low reset

    // Data and control inputs
    input  wire       prech_in,       // Precharge input signal
    input  wire       t3_en,          // T3 pipeline stage clock gate enable
    input  wire       save_edge_en,   // Edge capture mode enable
    input  wire       shift0_sc_mux,  // Stage-0 tag source mux select

    // Outputs
    output wire [1:0] shift0_sc_out,  // Stage-0 shift shortcut tag
    output wire       clk_en_set      // Clock enable trigger to clk_ctrl
);

    // Internal signals
    reg        t1_out;         // Pipeline stage-1 register
    reg        t2_out;         // Pipeline stage-2 register
    reg        t3_out;         // Pipeline stage-3 register (gated clock)
    wire       clk_2_t3;      // Gated clock for t3 stage
    reg  [1:0] save_edge_reg; // Edge capture result register

    // ====================================================================
    // 1. Pipeline stage-1: sample precharge input
    // ====================================================================
    always @(posedge clk_2 or negedge rst_n) begin
        if (!rst_n) begin
            t1_out <= 1'b0;
        end else begin
            t1_out <= prech_in;
        end
    end

    // ====================================================================
    // 2. Pipeline stage-2: delay by one cycle
    // ====================================================================
    always @(posedge clk_2 or negedge rst_n) begin
        if (!rst_n) begin
            t2_out <= 1'b0;
        end else begin
            t2_out <= t1_out;
        end
    end

    // ====================================================================
    // 3. Clock gating for pipeline stage-3
    // ====================================================================
    clk_gate u_clk_gate_t3 (
        .clk_in   (clk_2),
        .en       (t3_en),
        .clk_gated(clk_2_t3)
    );

    // ====================================================================
    // 4. Pipeline stage-3: runs on gated clock
    // ====================================================================
    always @(posedge clk_2_t3 or negedge rst_n) begin
        if (!rst_n) begin
            t3_out <= 1'b0;
        end else begin
            t3_out <= t2_out;
        end
    end

    // Clock enable trigger: active when any pipeline stage is non-zero
    assign clk_en_set = prech_in | t1_out | t2_out | t3_out;

    // ====================================================================
    // 5. Edge capture and tag mapping
    // ====================================================================
    // Not a typical clock-gating pattern because the else branch
    // also performs an assignment (low-speed passthrough).
    always @(posedge clk_2 or negedge rst_n) begin
        if (!rst_n) begin
            save_edge_reg <= 2'b00;
        end else if (save_edge_en) begin
            if (t1_out == 1'b1 && t2_out == 1'b0)
                save_edge_reg <= 2'b11;
            else if (t1_out == 1'b0 && t2_out == 1'b1)
                save_edge_reg <= 2'b10;
            else
                save_edge_reg <= 2'b00;
        end else begin
            save_edge_reg <= {1'b0, t1_out};
        end
    end

    // Stage-0 tag output mux
    assign shift0_sc_out = shift0_sc_mux ? save_edge_reg : {t1_out, 1'b0};

endmodule
