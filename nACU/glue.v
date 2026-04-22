//------------------------------------------------------------
// (C) Copyright CUBLAZER All Right Reserved.
//
// Abstract    : Glue logic module for merging clock enable and
//               per-bank command signals from PreCh, WrAp, and
//               RdAp blocks, then splitting the merged bus to
//               individual SubChannel/BankGroup outputs.
// File Name   : glue.v
// Module Name : GLUE
// Revision History:
// ver1.0  Author  email  nACU  2026-04-10
// Initial version
//------------------------------------------------------------

module Glue (
    // Inputs from PreCharge logic
    input  wire        PreCh_ck_en,                // PreCharge clock enable
    input  wire [31:0] prech_w_nACU,               // PreCharge per-bank command

    // Inputs from Write Amplifier logic
    input  wire        WrAp_ck_en,                 // Write Amplifier clock enable
    input  wire [31:0] WrAp_w_nACU,                // Write Amplifier per-bank command

    // Inputs from Read Amplifier logic
    input  wire        RdAp_ck_en,                 // Read Amplifier clock enable
    input  wire [31:0] RdAp_w_nACU,                // Read Amplifier per-bank command

    // Outputs to TOP
    output wire        CK_En_nACU,                 // Merged clock enable to TOP

    // PerBank PreCharge Commands (8 groups x 4 bits = 32 bits)
    output wire [3:0]  PreCh_SC0_BG0_Bnk_w_nACU,  // SubCh0 BankGroup0 per-bank command
    output wire [3:0]  PreCh_SC0_BG1_Bnk_w_nACU,  // SubCh0 BankGroup1 per-bank command
    output wire [3:0]  PreCh_SC0_BG2_Bnk_w_nACU,  // SubCh0 BankGroup2 per-bank command
    output wire [3:0]  PreCh_SC0_BG3_Bnk_w_nACU,  // SubCh0 BankGroup3 per-bank command
    output wire [3:0]  PreCh_SC1_BG0_Bnk_w_nACU,  // SubCh1 BankGroup0 per-bank command
    output wire [3:0]  PreCh_SC1_BG1_Bnk_w_nACU,  // SubCh1 BankGroup1 per-bank command
    output wire [3:0]  PreCh_SC1_BG2_Bnk_w_nACU,  // SubCh1 BankGroup2 per-bank command
    output wire [3:0]  PreCh_SC1_BG3_Bnk_w_nACU   // SubCh1 BankGroup3 per-bank command
);

    //------------------------------------------------------------
    // Internal Signal Declarations (CS.6, CS.13)
    //------------------------------------------------------------
    wire [31:0] merged_w_nACU;  // Merged 32-bit per-bank command bus

    //------------------------------------------------------------
    // Clock Enable OR Logic
    // Any source active enables the nACU clock
    //------------------------------------------------------------
    assign CK_En_nACU = PreCh_ck_en | WrAp_ck_en | RdAp_ck_en;

    //------------------------------------------------------------
    // PerBank Command Merge Logic
    // OR all per-bank commands from PreCh, WrAp, and RdAp
    //------------------------------------------------------------
    assign merged_w_nACU = prech_w_nACU | WrAp_w_nACU | RdAp_w_nACU;

    //------------------------------------------------------------
    // Output Bus Splitting
    // Map merged 32-bit bus to individual SubChannel/BankGroup outputs
    // Bit mapping: [3:0]=SC0_BG0, [7:4]=SC0_BG1, ... [31:28]=SC1_BG3
    //------------------------------------------------------------
    // SubChannel 0
    assign PreCh_SC0_BG0_Bnk_w_nACU = merged_w_nACU[3:0];
    assign PreCh_SC0_BG1_Bnk_w_nACU = merged_w_nACU[7:4];
    assign PreCh_SC0_BG2_Bnk_w_nACU = merged_w_nACU[11:8];
    assign PreCh_SC0_BG3_Bnk_w_nACU = merged_w_nACU[15:12];

    // SubChannel 1
    assign PreCh_SC1_BG0_Bnk_w_nACU = merged_w_nACU[19:16];
    assign PreCh_SC1_BG1_Bnk_w_nACU = merged_w_nACU[23:20];
    assign PreCh_SC1_BG2_Bnk_w_nACU = merged_w_nACU[27:24];
    assign PreCh_SC1_BG3_Bnk_w_nACU = merged_w_nACU[31:28];

endmodule
