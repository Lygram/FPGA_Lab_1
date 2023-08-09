`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Company:         Tel Aviv University
// Engineer:        Leo Segre
// 
// Create Date:     05/05/2019 00:19 AM
// Design Name:     EE3 lab1
// Module Name:     Stash
// Project Name:    Electrical Lab 3, FPGA Experiment #1
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool versions:   Vivado 2016.4
// Description:     a Stash that stores all the samples in order upon sample_in and sample_in_valid.
//                  It exposes the chosen sample by sample_out and the exposed sample can be changed by next_sample. 
// Dependencies:    Lim_Inc
//
// Revision         1.0
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Stash(clk, reset, sample_in, sample_in_valid, next_sample, sample_out);

   parameter DEPTH = 5;
   
   input clk, reset, sample_in_valid, next_sample;
   input [7:0] sample_in;
   output [7:0] sample_out;
   
   reg [$clog2(DEPTH)-1:0] nowShowing;
   reg [$clog2(DEPTH)-1:0] oldestSample;
   reg [7:0] memory [DEPTH-1:0];
   wire [$clog2(DEPTH)-1:0] nextShowing;
   wire showCycleToZero;
   wire [$clog2(DEPTH)-1:0] nextOldest;
   wire oldestCycleToZero;

   
   integer i;
  
   Lim_Inc #(DEPTH) depthCounter(nowShowing, 1'b1, nextShowing, showCycleToZero);
   Lim_Inc #(DEPTH) oldestCounter(oldestSample, 1'b1, nextOldest, oldestCycleToZero);
   
   always @ (posedge sample_in_valid or posedge next_sample or posedge reset)
    begin
        if (reset == 1)
            begin
                nowShowing = 0;
                oldestSample = 0;
                for (i = 0; i <= DEPTH; i = i + 1)
                    begin
                        memory[i] = 8'b0;
                    end
            end
        else 
            begin
                if (sample_in_valid == 1)
                    begin
                        memory[oldestSample] <= sample_in;
                        oldestSample <= nextOldest;
                    end
                if (next_sample == 1)
                    begin
                        nowShowing <= nextShowing;
                    end
                if (showCycleToZero == 1)
                    begin
                        nowShowing <= 0;
                    end
                if (oldestCycleToZero == 1)
                    begin
                        oldestSample <= 0;
                    end

            end
    
    end
            
assign sample_out = memory[nowShowing];
endmodule
