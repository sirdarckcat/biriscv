`define MAX(a,b) (a >  b ? a : b)

`ifndef Y_MIN_WIDTH
`define Y_MIN_WIDTH   1
`endif

`ifndef REDUCE_SIGNED
`define REDUCE_SIGNED 0
`endif

(* techmap_celltype = "$add" *)
module add_dsp (A, B, Y);
    parameter A_SIGNED = 0;
    parameter B_SIGNED = 0;
    parameter A_WIDTH = 1;
    parameter B_WIDTH = 1;
    parameter Y_WIDTH = 1;

    (* force_downto *)
    input [A_WIDTH-1:0] A;
    (* force_downto *)
    input [B_WIDTH-1:0] B;
    (* force_downto *)
    output [Y_WIDTH-1:0] Y;

    localparam SIGNED_ADDER = (A_SIGNED == 1 && B_SIGNED == 1);

    generate
        localparam ADDER_WIDTH  = `MAX(`Y_MIN_WIDTH, A_WIDTH+1);

        \$__SUMDSP #(
            .A_SIGNED(A_SIGNED), 
            .B_SIGNED(B_SIGNED), 
            .A_WIDTH(A_WIDTH),
            .B_WIDTH(B_WIDTH),
            .Y_WIDTH(ADDER_WIDTH)
        ) _TECHMAP_REPLACE_ (
            .A(A), 
            .B(B), 
            .Y(Y[ADDER_WIDTH-1:0]) 
        );
        assign Y[Y_WIDTH-1:ADDER_WIDTH] = { (Y_WIDTH-ADDER_WIDTH){SIGNED_ADDER ? Y[ADDER_WIDTH-1] : 1'b0} };
    endgenerate

    
endmodule