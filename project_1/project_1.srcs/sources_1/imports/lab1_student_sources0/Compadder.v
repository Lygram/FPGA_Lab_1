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
 
    
	
    // FILL HERE

    
endmodule
