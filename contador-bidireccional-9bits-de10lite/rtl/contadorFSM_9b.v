module contadorFSM_9b (
    input  wire              clk,
    input  wire              reset,
    input  wire              tick,

    input  wire              pause_pulse,
    input  wire              inc_switch,
    input  wire              dec_switch,

    output reg signed [8:0]   count,
    output reg [1:0]          state
);

    localparam S_PAUSE = 2'd0;
    localparam S_UP    = 2'd1;
    localparam S_DOWN  = 2'd2;

    always @(posedge clk or posedge reset) begin

        if (reset) begin
            count <= 9'sd0;
            state <= S_PAUSE;
        end

        else begin

            // =============================================
            // CONTROL DE ESTADO
            //
            // Prioridad:
            // PAUSA > ASCENDENTE > DESCENDENTE
            // =============================================

            if (pause_pulse)
                state <= S_PAUSE;

            else if (inc_switch)
                state <= S_UP;

            else if (dec_switch)
                state <= S_DOWN;


            // =============================================
            // CONTADOR
            // =============================================

            if (tick) begin

                case (state)

                    S_UP: begin
                        if (count == 9'sd255)
                            count <= -9'sd256;
                        else
                            count <= count + 9'sd1;
                    end


                    S_DOWN: begin
                        if (count == -9'sd256)
                            count <= 9'sd255;
                        else
                            count <= count - 9'sd1;
                    end


                    default: begin
                        count <= count;
                    end

                endcase

            end

        end

    end

endmodule
