module tickGen_1 (
    input  wire clk,
    input  wire reset,
    input  wire enable,
    input  wire speed_sel,
    output reg  tick
);

    localparam [25:0] CICLOS_1S    = 26'd49_999_999;
    localparam [25:0] CICLOS_100MS = 26'd4_999_999;

    reg [25:0] cuenta;

    wire [25:0] limite  = speed_sel ? CICLOS_100MS : CICLOS_1S;
    wire        llegada = (cuenta >= limite);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            cuenta <= 26'd0;
            tick   <= 1'b0;
        end
        else begin
            tick   <= enable & llegada;
            cuenta <= (enable & ~llegada) ? cuenta + 26'd1 : 26'd0;
        end
    end

endmodule
