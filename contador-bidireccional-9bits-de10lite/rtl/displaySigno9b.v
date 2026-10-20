module displaySigno9b (
    input  wire signed [8:0] value,

    output wire [6:0] HEX0,
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3
);

    reg [8:0] magnitude;

    reg [3:0] hundreds;
    reg [3:0] tens;
    reg [3:0] units;

    always @(*) begin

        // Obtener magnitud absoluta
        if (value < 0)
            magnitude = -value;
        else
            magnitude = value;

        hundreds = magnitude / 100;
        tens     = (magnitude % 100) / 10;
        units    = magnitude % 10;

    end


    decod7Seg_dec seg0 (
        .digit(units),
        .seg(HEX0)
    );

    decod7Seg_dec seg1 (
        .digit(tens),
        .seg(HEX1)
    );

    decod7Seg_dec seg2 (
        .digit(hundreds),
        .seg(HEX2)
    );


    // HEX3 muestra "-" si el número es negativo
    assign HEX3 =
        (value < 0)
        ? 7'b0111111
        : 7'b1111111;

endmodule
