module prech_main_shift (
    input  wire       clk,
    input  wire       Reset,
    input  wire       main_ce,
    input  wire       cmd_in,
    input  wire       Oddshift_en,
    input  wire       Odd_mux,
    input  wire       Switch00,
    input  wire [7:0] Switch0_7,
    input  wire [7:0] Gate0_7,
    output wire       cmd_out
);
    reg [7:0] shift_dff;
    reg       odd_dff;
    reg       tap_cmd;
    integer i;

    // Gate0_7 is preserved for low-power control compatibility.
    wire gate_unused;
    assign gate_unused = ^Gate0_7;

    always @* begin
        if (Switch00) begin
            tap_cmd = cmd_in;
        end else begin
            case (1'b1)
                Switch0_7[0]: tap_cmd = shift_dff[0];
                Switch0_7[1]: tap_cmd = shift_dff[1];
                Switch0_7[2]: tap_cmd = shift_dff[2];
                Switch0_7[3]: tap_cmd = shift_dff[3];
                Switch0_7[4]: tap_cmd = shift_dff[4];
                Switch0_7[5]: tap_cmd = shift_dff[5];
                Switch0_7[6]: tap_cmd = shift_dff[6];
                Switch0_7[7]: tap_cmd = shift_dff[7];
                default     : tap_cmd = cmd_in;
            endcase
        end
    end

    always @(posedge clk or posedge Reset) begin
        if (Reset) begin
            shift_dff <= 8'b0;
            odd_dff   <= 1'b0;
        end else if (main_ce) begin
            shift_dff[0] <= cmd_in;
            for (i = 1; i < 8; i = i + 1) begin
                shift_dff[i] <= shift_dff[i-1];
            end
            odd_dff <= tap_cmd;
        end
    end

    assign cmd_out = (Oddshift_en & Odd_mux) ? odd_dff : tap_cmd;
endmodule
