module clk_gate (
    input  wire clk,
    input  wire en,
    input  wire test_en,
    output wire gclk
);
    reg en_latched;

    always @(negedge clk or posedge test_en) begin
        if (test_en) begin
            en_latched <= 1'b1;
        end else begin
            en_latched <= en;
        end
    end

    assign gclk = clk & (en_latched | test_en);
endmodule

