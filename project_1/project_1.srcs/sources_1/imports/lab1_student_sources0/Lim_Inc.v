`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Company:         Tel Aviv University
// Engineer:        
// 
// Create Date:     05/05/2019 00:16 AM
// Design Name:     EE3 lab1
// Module Name:     Lim_Inc
// Project Name:    Electrical Lab 3, FPGA Experiment #1
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool Versions:   Vivado 2016.4
// Description:     Incrementor modulo L, where the input a is *saturated* at L 
//                  If a+ci>L, then the output will be s=0,co=1 anyway.
// 
// Dependencies:    Compadder
// 
// Revision:        3.0
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module Lim_Inc(a, ci, sum, co);
    
    parameter L = 10;
    localparam N = $clog2(L);
    input [N-1:0] a;
    input ci;
    output [N-1:0] sum;
    output co;
    
    wire[N-1:0] b;
    assign b = 0;
    
    wire[N:0] sWire;
    wire[N:0] tWire;
    
    reg _c0;
    reg[N-1:0] _sum;
    
    Compadder #(N) cmpadr(a, b, sWire, tWire);
    
    always @(*)
    begin
        if (ci == 1)
            begin
                if (tWire >= L)
                    begin
                        _c0 <= 1;
                        _sum <= 0;
                    end
                else //Doesn't oveflow
                    begin
                        _c0 <= 0;
                        _sum <= tWire[N-1:0];
                    end
            end
            
        else //if (ci == 0)
            begin
                if (sWire >= L)
                    begin  
                        _c0 <= 1;
                        _sum <= 0;
                    end
                else
                    begin
                        _c0 <= 0;
                        _sum <= sWire[N-1:0];
                    end
            end
        
    end
    
    assign sum = _sum;
    assign co = _c0;
endmodule
