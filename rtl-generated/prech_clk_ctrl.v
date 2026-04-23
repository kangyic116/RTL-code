module prech_clk_ctrl (
    input  wire       clk,
    input  wire       Reset,
    input  wire       activity_hint,
    input  wire       main_in_pulse,
    input  wire       Div2_en,
    input  wire       _clk_mux,
    input  wire [4:0] Value_for_rst,
    output reg        PreCh_clk_en,
    output reg        main_ce
);
    reg [4:0] clk_en_cnt;
    reg       div2_toggle;
    wire      use_div4;

    assign use_div4 = Div2_en & _clk_mux;

    always @(posedge clk or posedge Reset) begin
        if (Reset) begin
            PreCh_clk_en <= 1'b0;
            main_ce      <= 1'b0;
            clk_en_cnt   <= 5'd0;
            div2_toggle  <= 1'b0;
        end else begin
            if (activity_hint) begin
                PreCh_clk_en <= 1'b1;
            end else if ((clk_en_cnt == 5'd0) && !main_in_pulse) begin
                PreCh_clk_en <= 1'b0;
            end

            if (main_in_pulse) begin
                clk_en_cnt <= Value_for_rst;
            end else if (PreCh_clk_en && (clk_en_cnt != 5'd0)) begin
                clk_en_cnt <= clk_en_cnt - 1'b1;
            end

            if (!PreCh_clk_en) begin
                div2_toggle <= 1'b0;
                main_ce     <= 1'b0;
            end else if (use_div4) begin
                div2_toggle <= ~div2_toggle;
                main_ce     <= div2_toggle;
            end else begin
                div2_toggle <= 1'b0;
                main_ce     <= 1'b1;
            end
        end
    end
endmodule

