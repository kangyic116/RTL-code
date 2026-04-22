// ----------------------------------------
// © Copyright CUBLAZER All Right Reserved.
//
// Abstract : Basic clock gating cell
// File Name : clk_gate.v
// Module Name : clk_gate
// Revision Histrory:
//      v1.0 zhuang nACU 2026-04-02
//           style cleanup only, no functional change
// ----------------------------------------

module clk_gate (
    input  wire clk_in,
    input  wire en,
    output wire clk_gated
);
    reg en_latch;

    always @(*) begin
        if (!clk_in) begin
            en_latch = en;
        end
    end

    assign clk_gated = en_latch & clk_in;

endmodule
