`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Company:         Tel Aviv University
// Engineer:        
// 
// Create Date:     05/05/2019 01:28AM
// Design Name:     EE3 lab1
// Module Name:     Stopwatch
// Project Name:    Electrical Lab 3, FPGA Experiment #1
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool versions:   Vivado 2016.4
// Description:     Top module of the stopwatch circuit. Displays 2 independent 
//                  stopwatches on the 4 digits of the 7-segment component.
//                  Uses btnC as reset, btnU as trigger, and btnR as split button to
//                  control the currently selected stopwatch.
//                  Pressing btnL at any time - toggles the selection between the 
//                  left hand side (LHS) and the RHS stopwatches.
//                  The stopwatch's time reading is outputted using an, seg and dp signals
//                  that should be connected to the 4-digit-7-segment display and driven
//                  by 100MHz clock. 
// Dependencies:    Debouncer, Ctl, Counter, Seg_7_Display
//
// Revision:        3.0
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Stopwatch(clk, btnC, btnU, btnR, btnL, btnD, seg, an, dp, led_left, led_right);

    input              clk, btnC, btnU, btnR, btnL, btnD;
    output  wire [6:0] seg;
    output  wire [3:0] an;
    output  wire       dp; 
    output  wire [2:0] led_left;
    output  wire [2:0] led_right;
    
    reg [15:0] time_save;
    wire [15:0] time_reading;
    wire trig, split, reset, toggle, sample;
    wire trig_right, split_right, count_enabled_right;
    wire valid_sample_left, next_sample_left, init_regs;
    reg selected_stopwatch = 1;
    
	//Debouncers
	Debouncer debC(clk, btnC, reset);
	Debouncer debU(clk, btnU, trig);
	Debouncer debR(clk, btnR, split);
	Debouncer debL(clk, btnL, toggle);
	Debouncer debD(clk, btnD, sample);
	
	//Counter
	Counter counter(clk, reset, count_enabled_right, time_reading[7:0]);
	
	//Stash
	Stash stash(clk, reset, time_reading[7:0], sample, next_sample_left & ~selected_stopwatch, time_reading[15:8]);
	
	//7Seg
	Seg_7_Display(time_reading, clk, reset, seg, an, dp);
	
	//Control
	Ctl control(clk, reset, trig & stopwatch_select, split, init_regs, count_enabled_right);
	
	//LEDs
    assign led_left = ~selected_stopwatch? 3'b111 : 3'b000;
    //Stash
    assign led_right = selected_stopwatch? 3'b111 : 3'b000;
	
	//Selector
	always @(posedge toggle)
	begin
	   selected_stopwatch = selected_stopwatch + 1;
	end
	
	always @(posedge clk)
	begin
	   time_save[15:0] <= time_reading[15:0];
	end
	

endmodule
