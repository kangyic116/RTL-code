module glue (
    input  wire       PreCh_clk_en,
    input  wire [31:0] prech_w_nACU,
    input  wire       WrAp_clk_en,
    input  wire [31:0] WrAp_w_nACU,
    input  wire       RdAp_clk_en,
    input  wire [31:0] RdAp_w_nACU,
    output wire       CK_En_nACU,
    output wire [3:0] PreCh_SC0_BG0_Bnk_w_nACU,
    output wire [3:0] PreCh_SC0_BG1_Bnk_w_nACU,
    output wire [3:0] PreCh_SC0_BG2_Bnk_w_nACU,
    output wire [3:0] PreCh_SC0_BG3_Bnk_w_nACU,
    output wire [3:0] PreCh_SC1_BG0_Bnk_w_nACU,
    output wire [3:0] PreCh_SC1_BG1_Bnk_w_nACU,
    output wire [3:0] PreCh_SC1_BG2_Bnk_w_nACU,
    output wire [3:0] PreCh_SC1_BG3_Bnk_w_nACU
);
    wire [31:0] merged_prech;

    assign CK_En_nACU = PreCh_clk_en | WrAp_clk_en | RdAp_clk_en;
    assign merged_prech = prech_w_nACU | WrAp_w_nACU | RdAp_w_nACU;

    assign PreCh_SC0_BG0_Bnk_w_nACU = merged_prech[3:0];
    assign PreCh_SC0_BG1_Bnk_w_nACU = merged_prech[7:4];
    assign PreCh_SC0_BG2_Bnk_w_nACU = merged_prech[11:8];
    assign PreCh_SC0_BG3_Bnk_w_nACU = merged_prech[15:12];
    assign PreCh_SC1_BG0_Bnk_w_nACU = merged_prech[19:16];
    assign PreCh_SC1_BG1_Bnk_w_nACU = merged_prech[23:20];
    assign PreCh_SC1_BG2_Bnk_w_nACU = merged_prech[27:24];
    assign PreCh_SC1_BG3_Bnk_w_nACU = merged_prech[31:28];
endmodule

