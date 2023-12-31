`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Company:         Tel Aviv University
// Engineer:        
// 
// Create Date:     05/05/2019 08:59:38 PM
// Design Name:     EE3 lab1
// Module Name:     Ctl
// Project Name:    Electrical Lab 3, FPGA Experiment #1
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool versions:   Vivado 2016.4
// Description:     Control module that receives reset,trig and split inputs from the buttons
//                  outpputs the init_regs and count_enabled level signals that should govern the 
//                  operation of the Counter module.
// Dependencies:    None
//
// Revision:  	    3.0
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Ctl(clk, reset, trig, split, init_regs, count_enabled);

   input clk, reset, trig, split;
   output init_regs, count_enabled;
   
   //-------------Internal Constants--------------------------
   localparam SIZE = 3;
   localparam IDLE  = 3'b001, COUNTING = 3'b010, PAUSED = 3'b100 ;
   reg [SIZE-1:0] 	  state;

   //-------------Transition Function (Delta) ----------------
   always @(posedge clk)
     begin
        if (reset)
          state <= IDLE;
        else begin //reset=0
            if (state == IDLE) begin
                if(trig == 1'b1)
                    state <= COUNTING;
            end
            else if (state == COUNTING) begin
                if(trig == 1'b1) begin
                    state <= PAUSED;
                 end
            end
            else begin
                if(trig == 1'b1) begin
                    state <= COUNTING;
                 end else if(split == 1'b1) begin
                     state <= IDLE;
                 end
            end
        end                             
     end
   //-------------Output Function (Lambda) ----------------
	 assign init_regs     = (state == IDLE) ? 1 : 0;
	 assign count_enabled = (state == COUNTING) ? 1 : 0;
endmodule
