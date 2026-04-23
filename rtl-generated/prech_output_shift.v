module prech_output_shift (
    input  wire clk,
    input  wire Reset,
    input  wire cmd_in,
    input  wire Shift2_en,
    input  wire Shift2_mux,
    output reg  PreCh_fifo_out1,
    output reg  PreCh_fifo_out2
);
    reg shift2_dff;
    reg shift3_dff;

    always @(posedge clk or posedge Reset) begin
        if (Reset) begin
            shift2_dff     <= 1'b0;
            shift3_dff     <= 1'b0;
            PreCh_fifo_out1 <= 1'b0;
            PreCh_fifo_out2 <= 1'b0;
        end else begin
            shift2_dff <= cmd_in;

            if (Shift2_en) begin
                if (Shift2_mux) begin
                    shift3_dff <= shift2_dff;
                end else begin
                    shift3_dff <= cmd_in;
                end
            end else begin
                shift3_dff <= cmd_in;
            end

            PreCh_fifo_out1 <= shift3_dff;
            PreCh_fifo_out2 <= PreCh_fifo_out1;
        end
    end
endmodule

