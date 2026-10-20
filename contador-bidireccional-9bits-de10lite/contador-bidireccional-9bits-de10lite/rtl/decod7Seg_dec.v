module decod7Seg_dec (
    input  wire [3:0] digit,
    output wire [6:0] seg
);

    localparam [69:0] TABLA = {
        7'b0010000,
        7'b0000000,
        7'b1111000,
        7'b0000010,
        7'b0010010,
        7'b0011001,
        7'b0110000,
        7'b0100100,
        7'b1111001,
        7'b1000000
    };

    assign seg = (digit < 4'd10) ? TABLA[digit*7 +: 7] : 7'b1111111;

endmodule
