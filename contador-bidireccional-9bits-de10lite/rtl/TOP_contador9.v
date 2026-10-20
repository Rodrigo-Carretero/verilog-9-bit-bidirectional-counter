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

    // =====================================================
    // Estados
    // =====================================================

    localparam [1:0] S_PAUSE = 2'd0;
    localparam [1:0] S_UP    = 2'd1;
    localparam [1:0] S_DOWN  = 2'd2;


    // =====================================================
    // Señales internas
    // =====================================================

    wire reset;

    wire pause_pulse;

    wire tick;

    wire [1:0] state;

    wire signed [8:0] count;

    wire running;


    assign reset = ~BTN_RESET_N;

    assign running = (state != S_PAUSE);


    // =====================================================
    // Sincronización de switches
    // =====================================================

    reg speed_meta;
    reg speed_sync;

    reg inc_meta;
    reg inc_sync;

    reg dec_meta;
    reg dec_sync;


    always @(posedge CLOCK_50 or posedge reset) begin

        if (reset) begin

            speed_meta <= 1'b0;
            speed_sync <= 1'b0;

            inc_meta <= 1'b0;
            inc_sync <= 1'b0;

            dec_meta <= 1'b0;
            dec_sync <= 1'b0;

        end

        else begin

            speed_meta <= SW_FREQ;
            speed_sync <= speed_meta;

            inc_meta <= SW_INC;
            inc_sync <= inc_meta;

            dec_meta <= SW_DEC;
            dec_sync <= dec_meta;

        end

    end


    // =====================================================
    // Botón PAUSA
    // =====================================================

    pulsoBoton_v1 u_pause (
        .clk(CLOCK_50),
        .reset(reset),
        .button_n(BTN_PAUSE_N),
        .press_pulse(pause_pulse)
    );


    // =====================================================
    // Generador de tick
    // =====================================================

    tickGen_1 u_tick (
        .clk(CLOCK_50),
        .reset(reset),
        .enable(running),
        .speed_sel(speed_sync),
        .tick(tick)
    );


    // =====================================================
    // FSM + contador
    // =====================================================

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


    // =====================================================
    // Displays
    // =====================================================

    displaySigno9b u_display (
        .value(count),

        .HEX0(HEX0),
        .HEX1(HEX1),
        .HEX2(HEX2),
        .HEX3(HEX3)
    );


    // =====================================================
    // LEDs
    // =====================================================

    // LEDR[0] = PAUSA
    // LEDR[1] = ASCENDENTE
    // LEDR[2] = DESCENDENTE
    // LEDR[3] = 100 ms
    // LEDR[9] = NEGATIVO

    assign LEDR = {
        (count < 0),
        5'b00000,
        speed_sync,
        (state == S_DOWN),
        (state == S_UP),
        (state == S_PAUSE)
    };


endmodule
