module displaySigno9b (
    input  wire signed [8:0] value,
    output wire [6:0] HEX0,
    output wire [6:0] HEX1,
    output wire [6:0] HEX2,
    output wire [6:0] HEX3
);

    wire       negativo = value[8];
    wire [8:0] magnitud = negativo ? (~value + 9'd1) : value;

    wire [3:0] centenas = magnitud / 9'd100;
    wire [8:0] resto    = magnitud - centenas * 9'd100;
    wire [3:0] decenas  = resto / 9'd10;
    wire [3:0] unidades = resto - decenas * 9'd10;

    decod7Seg_dec seg0 (.digit(unidades), .seg(HEX0));
    decod7Seg_dec seg1 (.digit(decenas),  .seg(HEX1));
    decod7Seg_dec seg2 (.digit(centenas), .seg(HEX2));

    assign HEX3 = {~negativo, 6'b111111};

endmodule
