// ----------------------------------------
// © Copyright CUBLAZER All Right Reserved.
//
// Abstract  : Core shift chain with odd-phase adjustment,
//             one-hot injection and 8-group DFF pipeline
// File Name : prech_main_shift.v
// Module Name : prech_main_shift
// Revision History:
//      ver1.0 - Initial version
// ----------------------------------------

module prech_main_shift (
    // Clock and Reset
    input  wire       clk_main,       // Main shift clock
    input  wire       rst_n,          // Asynchronous active-low reset

    // Shift input and control
    input  wire [1:0] shift0_sc_in,   // Stage-0 shift shortcut tag input
    input  wire       odd_shift_en,   // Odd-phase shift register enable
    input  wire       odd_mux,        // Odd mux: 0=direct, 1=odd delayed
    input  wire       switch00,       // Zero-delay bypass control

    input  wire [7:0] switch0_7_in,   // One-hot injection stage select
    input  wire [7:0] gate0_7_in,     // Per-group gate control (reserved，no use)

    // Output
    output wire [1:0] main_shift_out  // Shift chain output data
);

    // Internal signals
    wire [7:0] gate_therm;        // Thermometer-coded clock gate enable
    reg  [1:0] odd_shift_reg;     // Odd-phase shift register
    wire [1:0] shift0;            // Muxed shift input for injection
    reg  [1:0] dff_stage1 [7:0]; // Per-group DFF stage 1
    reg  [1:0] dff_stage2 [7:0]; // Per-group DFF stage 2

    // ====================================================================
    // 1. One-hot to thermometer conversion (gate enable generation)
    // ====================================================================
    // When switch[i] is selected, stages i down to 0 are all enabled.
    assign gate_therm[7] = switch0_7_in[7];

    genvar k;
    generate
        for (k = 6; k >= 0; k = k - 1) begin : gen_gate_therm
            assign gate_therm[k] = gate_therm[k+1] | switch0_7_in[k];
        end
    endgenerate

    // ====================================================================
    // 2. Odd-phase shift (1-cycle fine adjustment)
    // ====================================================================
    always @(posedge clk_main or negedge rst_n) begin
        if (!rst_n) begin
            odd_shift_reg <= 2'b00;
        end else if (odd_shift_en) begin
            odd_shift_reg <= shift0_sc_in;
        end
    end

    assign shift0 = odd_mux ? odd_shift_reg : shift0_sc_in;

    // ====================================================================
    // 3. Main shift chain (8 groups, 2 DFFs per group)
    // ====================================================================
    integer i;
    always @(posedge clk_main or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i <= 7; i = i + 1) begin
                dff_stage1[i] <= 2'b00;
                dff_stage2[i] <= 2'b00;
            end
        end else begin
            if (gate_therm[7]) begin
                dff_stage1[7] <= switch0_7_in[7] ? shift0 : 2'b00;
                dff_stage2[7] <= dff_stage1[7];
            end

            for (i = 6; i >= 0; i = i - 1) begin
                if (gate_therm[i]) begin
                    dff_stage1[i] <= switch0_7_in[i] ? shift0 : dff_stage2[i+1];
                    dff_stage2[i] <= dff_stage1[i];
                end
            end
        end
    end

    // ====================================================================
    // 4. Output mux
    // ====================================================================
    assign main_shift_out = switch00 ? shift0 : dff_stage2[0];

endmodule


// 下面是采用时钟门控的代码实现
// module prech_main_shift (
//     input  wire       clk_main,
//     input  wire       rst_n,
    
//     input  wire [1:0] shift0_sc_in,
//     input  wire       odd_gate_en,   // 对应图中的 Odd_gate 控制信号
//     input  wire       odd_mux,       // 0: 选通 shift0_sc_in, 1: 选通 odd_shift (延迟1拍)
//     input  wire       switch00,      // 0延迟 bypass 控制
//     input  wire [7:0] switch0_7_in,  // 独热码，控制在哪一级注入 Shift0
    
//     output wire [1:0] main_shift_out
// );

//     // ========================================================
//     // 1. 独热码转温度计码 (生成 Clock Gating 使能信号)
//     // ========================================================
//     wire [7:0] gate_therm;
    
//     assign gate_therm[7] = switch0_7_in[7];
//     genvar k;
//     generate
//         for (k = 6; k >= 0; k = k - 1) begin : gen_gate_therm
//             // 级联或逻辑：当前级使能 = 上一级使能 | 当前级注入
//             assign gate_therm[k] = gate_therm[k+1] | switch0_7_in[k];
//         end
//     endgenerate

//     // ========================================================
//     // 2. 显式例化时钟门控单元 (ICG)
//     // ========================================================
//     // 2.1 Odd Shift 的门控时钟
//     wire clk_odd_gated;
//     clk_gate u_cg_odd (
//         .clk_in   (clk_main),
//         .en       (odd_gate_en),
//         .clk_gated(clk_odd_gated)
//     );

//     // 2.2 主移位链的门控时钟 (8组独立时钟)
//     wire [7:0] clk_gated_main;
//     genvar j;
//     generate
//         for (j = 0; j <= 7; j = j + 1) begin : gen_cg_main
//             clk_gate u_cg_main (
//                 .clk_in   (clk_main),
//                 .en       (gate_therm[j]),
//                 .clk_gated(clk_gated_main[j])
//             );
//         end
//     endgenerate

//     // ========================================================
//     // 3. 奇偶移位处理 (Odd Shift, 1周期细调)
//     // ========================================================
//     reg [1:0] odd_shift_reg;
//     // 注意：这里的敏感列表改为了门控后的时钟，并移除了 if (odd_gate_en)
//     always @(posedge clk_odd_gated or negedge rst_n) begin
//         if (!rst_n) begin
//             odd_shift_reg <= 2'b00;
//         end else begin 
//             odd_shift_reg <= shift0_sc_in;
//         end
//     end
    
//     wire [1:0] shift0 = odd_mux ? odd_shift_reg : shift0_sc_in;

//     // ========================================================
//     // 4. 主移位链 (8组，每组2个DFF)
//     // ========================================================
//     reg [1:0] dff_stage1 [7:0];
//     reg [1:0] dff_stage2 [7:0];

//     // 使用 generate block 为每一级生成独立的 always 块
//     genvar i;
//     generate
//         for (i = 0; i <= 7; i = i + 1) begin : gen_dff_stages
//             // 每一级都使用自己专属的门控时钟
//             always @(posedge clk_gated_main[i] or negedge rst_n) begin
//                 if (!rst_n) begin
//                     dff_stage1[i] <= 2'b00;
//                     dff_stage2[i] <= 2'b00;
//                 end else begin
//                     // 移除了 if (gate_therm[i])，因为时钟本身已经被门控
//                     if (i == 7) begin
//                         // 最高延迟级 (Group 7)
//                         dff_stage1[7] <= switch0_7_in[7] ? shift0 : 2'b00;
//                         dff_stage2[7] <= dff_stage1[7];
//                     end else begin
//                         // 级联传递 (Group 6 下降到 Group 0)
//                         dff_stage1[i] <= switch0_7_in[i] ? shift0 : dff_stage2[i+1];
//                         dff_stage2[i] <= dff_stage1[i];
//                     end
//                 end
//             end
//         end
//     endgenerate

//     // ========================================================
//     // 5. 最终输出选择
//     // ========================================================
//     assign main_shift_out = switch00 ? shift0 : dff_stage2[0];

// endmodule
