module mr_dec (
    input  wire [4:0] MR1_OP,
    input  wire       MR11_OP,
    input  wire       edge_flag,
    input  wire       PracEn,
    input  wire       EcsEnWin,

    output wire       T3_en,
    output wire       Div2_en,
    output wire       _clk_mux,
    output wire       Save_edge_en,
    output wire       Shift0_mux,
    output wire       Oddshift_en,
    output wire       Odd_mux,
    output wire       Switch00,
    output wire [7:0] Switch0_7,
    output wire [7:0] Gate0_7,
    output wire       Shift2_en,
    output wire       Shift2_mux,
    output wire [4:0] Value_for_rst,
    output wire       Shift4_en,
    output wire       Shift4_mux,
    output wire [32:0] ctrl_bus
);
    reg [32:0] ctrl_bus_r;

    function [32:0] mkcfg;
        input       t3;
        input       div2;
        input       clk_mux;
        input       save_edge;
        input       shift0;
        input       odd_en;
        input       odd_mux;
        input       sw00;
        input       shift2;
        input       shift4;
        input [7:0] swg;
        input [4:0] rstv;
        begin
            mkcfg = 33'd0;
            mkcfg[0]      = t3;
            mkcfg[1]      = div2;
            mkcfg[2]      = clk_mux;
            mkcfg[3]      = save_edge;
            mkcfg[4]      = shift0;
            mkcfg[5]      = odd_en;
            mkcfg[6]      = odd_mux;
            mkcfg[7]      = sw00;
            mkcfg[15:8]   = swg;     // Switch0_7
            mkcfg[23:16]  = swg;     // Gate0_7
            mkcfg[24]     = shift2;  // Shift2_en
            mkcfg[25]     = shift2;  // Shift2_mux
            mkcfg[30:26]  = rstv;
            mkcfg[31]     = shift4;  // Shift4_en
            mkcfg[32]     = shift4;  // Shift4_mux
        end
    endfunction

    always @* begin
        // PracEn=0 -> disable nACU_shift control outputs.
        ctrl_bus_r = 33'd0;

        if (PracEn) begin
            if (MR11_OP) begin
                // DVFSL enabled (table defines explicit rows up to MR1_OP=00100).
                case (MR1_OP)
                    5'b00000: ctrl_bus_r = mkcfg(1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b1,8'b0000_0000,5'd4);
                    5'b00001: ctrl_bus_r = mkcfg(1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,8'b0000_0001,5'd6);
                    5'b00010: ctrl_bus_r = mkcfg(1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,8'b0000_0010,5'd8);
                    5'b00011: ctrl_bus_r = mkcfg(1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,8'b0000_0100,5'd10);
                    5'b00100: ctrl_bus_r = mkcfg(1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,1'b1,8'b0000_0100,5'd11);
                    default : ctrl_bus_r = mkcfg(1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,1'b1,8'b0000_0100,5'd11);
                endcase
            end else begin
                // DVFSL Disable
                case (MR1_OP)
                    5'b00000: ctrl_bus_r = mkcfg(1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b0,1'b0,8'b0000_0000,5'd4);
                    5'b00001: ctrl_bus_r = mkcfg(1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,1'b1,8'b0000_0000,5'd5);
                    5'b00010: ctrl_bus_r = mkcfg(1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,1'b0,8'b0000_0001,5'd7);
                    5'b00011: ctrl_bus_r = mkcfg(1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,1'b0,8'b0000_0010,5'd9);
                    5'b00100: ctrl_bus_r = mkcfg(1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,8'b0000_0100,5'd10);
                    5'b00101: ctrl_bus_r = mkcfg(1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,1'b1,8'b0000_0100,5'd11);
                    5'b00110: ctrl_bus_r = mkcfg(1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,1'b0,8'b0000_1000,5'd13);
                    5'b00111: ctrl_bus_r = mkcfg(1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,8'b0001_0000,5'd14);
                    5'b01000: ctrl_bus_r = mkcfg(1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,8'b0010_0000,5'd16);
                    5'b01001: ctrl_bus_r = mkcfg(1'b0,1'b0,1'b0,1'b0,1'b0,1'b1,1'b1,1'b0,1'b0,1'b0,8'b0100_0000,5'd19);

                    5'b01010: ctrl_bus_r = edge_flag ?
                                           mkcfg(1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b1,1'b0,8'b0000_0000,5'd9) :
                                           mkcfg(1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,1'b0,1'b0,1'b0,8'b0000_1000,5'd10);
                    5'b01011: ctrl_bus_r = edge_flag ?
                                           mkcfg(1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,1'b0,1'b1,1'b1,8'b0000_0000,5'd10) :
                                           mkcfg(1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,1'b1,8'b0000_1000,5'd11);
                    5'b01100: ctrl_bus_r = edge_flag ?
                                           mkcfg(1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,1'b0,1'b0,1'b1,8'b0000_0000,5'd12) :
                                           mkcfg(1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,1'b0,1'b1,1'b1,8'b0001_0000,5'd12);
                    5'b01101: ctrl_bus_r = edge_flag ?
                                           mkcfg(1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b1,1'b1,8'b0000_0000,5'd13) :
                                           mkcfg(1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,1'b0,1'b0,1'b1,8'b0010_0000,5'd14);
                    5'b01110: ctrl_bus_r = edge_flag ?
                                           mkcfg(1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,1'b1,8'b0000_0000,5'd15) :
                                           mkcfg(1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b1,1'b1,8'b0010_0000,5'd15);
                    5'b01111: ctrl_bus_r = edge_flag ?
                                           mkcfg(1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,1'b0,1'b1,1'b1,8'b0000_0000,5'd16) :
                                           mkcfg(1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,1'b1,8'b0100_0000,5'd17);
                    5'b10000: ctrl_bus_r = edge_flag ?
                                           mkcfg(1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,1'b0,8'b0000_0000,5'd19) :
                                           mkcfg(1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b1,1'b0,8'b1000_0000,5'd19);

                    default : ctrl_bus_r = edge_flag ?
                                           mkcfg(1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,1'b0,8'b0000_0000,5'd19) :
                                           mkcfg(1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b1,1'b0,1'b1,1'b0,8'b1000_0000,5'd19);
                endcase
            end
        end
    end

    // EcsEnWin is marked as legacy/obsolete in the spec, so it is not decoded.
    wire ecs_enwin_unused;
    assign ecs_enwin_unused = EcsEnWin;

    assign ctrl_bus      = ctrl_bus_r;
    assign T3_en         = ctrl_bus_r[0];
    assign Div2_en       = ctrl_bus_r[1];
    assign _clk_mux      = ctrl_bus_r[2];
    assign Save_edge_en  = ctrl_bus_r[3];
    assign Shift0_mux    = ctrl_bus_r[4];
    assign Oddshift_en   = ctrl_bus_r[5];
    assign Odd_mux       = ctrl_bus_r[6];
    assign Switch00      = ctrl_bus_r[7];
    assign Switch0_7     = ctrl_bus_r[15:8];
    assign Gate0_7       = ctrl_bus_r[23:16];
    assign Shift2_en     = ctrl_bus_r[24];
    assign Shift2_mux    = ctrl_bus_r[25];
    assign Value_for_rst = ctrl_bus_r[30:26];
    assign Shift4_en     = ctrl_bus_r[31];
    assign Shift4_mux    = ctrl_bus_r[32];
endmodule
