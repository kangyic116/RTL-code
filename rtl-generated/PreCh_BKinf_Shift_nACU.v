module PreCh_BKinf_Shift_nACU (
    input  wire       CK_nACU,
    input  wire       CK_div2_nACU,
    input  wire       Reset,
    input  wire       PreCh_wo_nACU,
    input  wire       PreCh_SC_wo_nACU,
    input  wire       PreCh_AB_wo_nACU,
    input  wire       PreCh_BA0_wo_nACU,
    input  wire       PreCh_BA1_wo_nACU,
    input  wire       PreCh_BG0_wo_nACU,
    input  wire       PreCh_BG1_wo_nACU,
    input  wire       PreCh_fifo_out1,
    input  wire       PreCh_fifo_out2,
    input  wire       Shift4_en,
    input  wire       Shift4_mux,
    output wire [31:0] prech_w_nACU
);
    localparam integer FIFO_DEPTH = 24;
    localparam integer PTR_W      = 5;

    reg [5:0] fifo_mem [0:FIFO_DEPTH-1];
    reg [PTR_W-1:0] wr_ptr;
    reg [PTR_W-1:0] rd_ptr;

    reg [31:0] prech_cmd_ck2;
    reg [31:0] shift4_dff;
    reg [31:0] prech_cmd_ck;

    function [31:0] decode_bank;
        input [5:0] bank_info;
        reg sc;
        reg ab;
        reg bg1;
        reg bg0;
        reg ba1;
        reg ba0;
        reg [31:0] tmp;
        integer bg_idx;
        integer ba_idx;
        integer bit_idx;
        begin
            sc  = bank_info[5];
            ab  = bank_info[4];
            bg1 = bank_info[3];
            bg0 = bank_info[2];
            ba1 = bank_info[1];
            ba0 = bank_info[0];

            tmp = 32'b0;
            if (ab) begin
                if (sc) begin
                    tmp[31:16] = 16'hFFFF;
                end else begin
                    tmp[15:0]  = 16'hFFFF;
                end
            end else begin
                bg_idx  = (bg1 << 1) | bg0;
                ba_idx  = (ba1 << 1) | ba0;
                bit_idx = (sc ? 16 : 0) + (bg_idx * 4) + ba_idx;
                tmp[bit_idx] = 1'b1;
            end
            decode_bank = tmp;
        end
    endfunction

    // FIFO write: each incoming command generates one write in CK/2 domain.
    always @(posedge CK_div2_nACU or posedge Reset) begin
        if (Reset) begin
            wr_ptr <= {PTR_W{1'b0}};
        end else if (PreCh_wo_nACU) begin
            fifo_mem[wr_ptr] <= {
                PreCh_SC_wo_nACU,
                PreCh_AB_wo_nACU,
                PreCh_BG1_wo_nACU,
                PreCh_BG0_wo_nACU,
                PreCh_BA1_wo_nACU,
                PreCh_BA0_wo_nACU
            };

            if (wr_ptr == FIFO_DEPTH-1) begin
                wr_ptr <= {PTR_W{1'b0}};
            end else begin
                wr_ptr <= wr_ptr + 1'b1;
            end
        end
    end

    // FIFO read + pulse shaping in CK/2 domain: out1 sets, out2 clears.
    always @(posedge CK_div2_nACU or posedge Reset) begin
        if (Reset) begin
            rd_ptr       <= {PTR_W{1'b0}};
            prech_cmd_ck2 <= 32'b0;
        end else begin
            if (PreCh_fifo_out1) begin
                prech_cmd_ck2 <= decode_bank(fifo_mem[rd_ptr]);
                if (rd_ptr == FIFO_DEPTH-1) begin
                    rd_ptr <= {PTR_W{1'b0}};
                end else begin
                    rd_ptr <= rd_ptr + 1'b1;
                end
            end else if (PreCh_fifo_out2) begin
                prech_cmd_ck2 <= 32'b0;
            end
        end
    end

    // Shift4 fine adjustment in CK domain.
    always @(posedge CK_nACU or posedge Reset) begin
        if (Reset) begin
            shift4_dff  <= 32'b0;
            prech_cmd_ck <= 32'b0;
        end else begin
            shift4_dff <= prech_cmd_ck2;
            if (Shift4_en) begin
                if (Shift4_mux) begin
                    prech_cmd_ck <= shift4_dff;
                end else begin
                    prech_cmd_ck <= prech_cmd_ck2;
                end
            end else begin
                prech_cmd_ck <= prech_cmd_ck2;
            end
        end
    end

    assign prech_w_nACU = prech_cmd_ck;
endmodule
