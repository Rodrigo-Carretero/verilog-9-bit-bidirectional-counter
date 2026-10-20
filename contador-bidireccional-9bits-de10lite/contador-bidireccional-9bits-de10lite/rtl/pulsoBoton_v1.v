module pulsoBoton_v1 (
    input  wire clk,
    input  wire reset,
    input  wire button_n,
    output reg  press_pulse
);

    localparam [18:0] ESPERA = 19'd499_999;

    reg [1:0]  ff;
    reg        estable;
    reg [18:0] restante;

    wire cambio  = (ff[1] != estable);
    wire vencido = (restante == 19'd0);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ff          <= 2'b11;
            estable     <= 1'b1;
            restante    <= ESPERA;
            press_pulse <= 1'b0;
        end
        else begin
            ff          <= {ff[0], button_n};
            press_pulse <= cambio & vencido & estable;

            if (!cambio)
                restante <= ESPERA;
            else if (vencido) begin
                restante <= ESPERA;
                estable  <= ff[1];
            end
            else
                restante <= restante - 19'd1;
        end
    end

endmodule
