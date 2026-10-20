module TOP_contador9 (
    input  wire       CLOCK_50,
    input  wire       BTN_RESET_N,
    input  wire       BTN_PAUSE_N,
    input  wire       SW_FREQ,
    input  wire       SW_INC,
    input  wire       SW_DEC,
    output wire [6:0] HEX0,
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3,
    output wire [9:0] LEDR
);

    localparam [1:0] S_PAUSE = 2'd0;
    localparam [1:0] S_UP    = 2'd1;
    localparam [1:0] S_DOWN  = 2'd2;

    wire reset = ~BTN_RESET_N;

    wire              pause_pulse;
    wire              tick;
    wire [1:0]        state;
    wire signed [8:0] count;
    wire              running = |state;

    reg [2:0] meta;
    reg [2:0] sinc;

    always @(posedge CLOCK_50 or posedge reset) begin
        if (reset) begin
            meta <= 3'b000;
            sinc <= 3'b000;
        end
        else begin
            meta <= {SW_DEC, SW_INC, SW_FREQ};
            sinc <= meta;
        end
    end

    wire speed_sync = sinc[0];
    wire inc_sync   = sinc[1];
    wire dec_sync   = sinc[2];

    pulsoBoton_v1 u_pause (
        .clk(CLOCK_50),
        .reset(reset),
        .button_n(BTN_PAUSE_N),
        .press_pulse(pause_pulse)
    );

    tickGen_1 u_tick (
        .clk(CLOCK_50),
        .reset(reset),
        .enable(running),
        .speed_sel(speed_sync),
        .tick(tick)
    );

    contadorFSM_9b u_counter (
        .clk(CLOCK_50),
        .reset(reset),
        .tick(tick),
        .pause_pulse(pause_pulse),
        .inc_switch(inc_sync),
        .dec_switch(dec_sync),
        .count(count),
        .state(state)
    );

    displaySigno9b u_display (
        .value(count),
        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3)
    );

    assign LEDR[0]   = (state == S_PAUSE);
    assign LEDR[1]   = (state == S_UP);
    assign LEDR[2]   = (state == S_DOWN);
    assign LEDR[3]   = speed_sync;
    assign LEDR[8:4] = 5'b00000;
    assign LEDR[9]   = count[8];

endmodule
