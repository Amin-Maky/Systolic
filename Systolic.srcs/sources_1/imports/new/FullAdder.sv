`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Am/148
// Engineer: AminMaky
//////////////////////////////////////////////////////////////////////////////////
module FullAdder #(parameter N = 5) ( a, b, cin, sum, cout );

    input  logic [N-1:0] a;
    input  logic [N-1:0] b;
    input  logic         cin;
    output logic [N-1:0] sum;
    output logic         cout;


    logic [N:0] carry; 
    
    buf (carry[0] , cin);

    generate
        genvar i;
        for (i = 0; i < N; i = i + 1) begin : FullAdder_Bit
            wire xor1_out, and1_out, and2_out, and3_out;

            xor (xor1_out, a[i], b[i]);
            xor (sum[i], xor1_out, carry[i]);

            and (and1_out, a[i], b[i]);
            and (and2_out, a[i], carry[i]);
            and (and3_out, b[i], carry[i]);
            or  (carry[i+1], and1_out, and2_out, and3_out);
        end
    endgenerate

    buf (cout , carry[N]);
endmodule
