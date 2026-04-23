module prech_input_shift (
    input  wire clk,
    input  wire Reset,
    input  wire prech_in,
    input  wire T3_en,
    input  wire Save_edge_en,
    input  wire Shift0_mux,
    output reg  main_in,
    output reg  activity_hint
);
    reg t1_dff;
    reg t2_dff;
    reg t3_dff;
    reg save_edge_dff;

    always @(posedge clk or posedge Reset) begin
        if (Reset) begin
            t1_dff       <= 1'b0;
            t2_dff       <= 1'b0;
            t3_dff       <= 1'b0;
            save_edge_dff <= 1'b0;
            main_in      <= 1'b0;
            activity_hint <= 1'b0;
        end else begin
            t1_dff <= prech_in;
            t2_dff <= t1_dff;

            if (T3_en) begin
                t3_dff <= t2_dff;
            end else begin
                t3_dff <= 1'b0;
            end

            if (Save_edge_en) begin
                save_edge_dff <= prech_in & ~t1_dff;
            end else begin
                save_edge_dff <= 1'b0;
            end

            if (Shift0_mux && T3_en) begin
                main_in <= t3_dff | save_edge_dff;
            end else begin
                main_in <= t2_dff;
            end

            activity_hint <= prech_in | t1_dff | t2_dff | t3_dff | save_edge_dff;
        end
    end
endmodule

