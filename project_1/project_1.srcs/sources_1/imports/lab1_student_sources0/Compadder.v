`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Company:         Tel Aviv University
// Engineer:        
// 
// Create Date:     04/05/2019 08:59:38 PM
// Design Name:     EE3 lab1
// Module Name:     COMPADDER
// Project Name:    Electrical Lab 3, FPGA Experiment #1
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool Versions:   Vivado 2016.4
// Description:     Variable length binary adder. The parameter N determines
//                  the bit width of the operands. Implemented according to 
//                  Compound-Adder.
// 
// Dependencies:    FA
// 
// Revision:        3.0
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module Compadder(a, b, s, t);

    parameter N=4;
    localparam K = N >> 1;
    
    input [N-1:0] a;
    input [N-1:0] b;
    output [N:0] s;
    output [N:0] t;
    
    wire [N:0] wireS;
    wire [N:0] wireT;
    wire [N:0] wireSalt;
    wire [N:0] wireTalt;
    
    generate
    if (N==0)
        begin end
    else if (N==1)
        begin  
            FA faSumS(a, b, 1'b0, s[0], s[N]);
            FA faSumT(a, b, 1'b1, t[0], t[N]);
        end
    else
        begin
            Compadder #(K) CAHK(a[K-1:0], b[K-1:0], wireSalt[K:0], wireTalt[K:0]);
            Compadder #(N-K) CALK(a[N-1:K], b[N-1:K], wireS[N:K], wireT[N:K]);
            
            assign s[K-1:0] = wireSalt[K-1:0];
            assign t[K-1:0] = wireTalt[K-1:0];
            assign s[N:K] = wireSalt[K] ? wireT[N:K] : wireS[N:K];
            assign t[N:K] = wireTalt[K] ? wireT[N:K] : wireS[N:K]; 
            
        end
    endgenerate

    
endmodule
