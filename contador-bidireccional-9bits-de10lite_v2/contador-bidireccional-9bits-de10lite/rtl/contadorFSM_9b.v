module contadorFSM_9b (
    input  wire              clk,
    input  wire              reset,
    input  wire              tick,
    input  wire              pause_pulse,
    input  wire              inc_switch,
    input  wire              dec_switch,
    output reg signed [8:0]  count,
    output reg [1:0]         state
);

    localparam S_PAUSE = 2'd0;
    localparam S_UP    = 2'd1;
    localparam S_DOWN  = 2'd2;

    reg [1:0] proximo;

    always @(*) begin
        proximo = state;
        if (pause_pulse)     proximo = S_PAUSE;
        else if (inc_switch) proximo = S_UP;
        else if (dec_switch) proximo = S_DOWN;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 9'sd0;
            state <= S_PAUSE;
        end
        else begin
            state <= proximo;

            if (tick && state == S_UP)
                count <= (count == 9'sd255) ? -9'sd256 : count + 9'sd1;
            else if (tick && state == S_DOWN)
                count <= (count == -9'sd256) ? 9'sd255 : count - 9'sd1;
        end
    end

endmodule
