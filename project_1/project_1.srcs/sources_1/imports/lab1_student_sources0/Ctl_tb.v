`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Company:         Tel Aviv University
// Engineer:        
// 
// Create Date:     05/05/2019 02:59:38 AM
// Design Name:     EE3 lab1
// Module Name:     Ctl_tb
// Project Name:    Electrical Lab 3, FPGA Experiment #1
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool versions:   Vivado 2016.4
// Description:     test bennch for the control.
// Dependencies:    None
//
// Revision: 		3.0
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Ctl_tb();

    reg clk, reset, trig, split, correct, loop_was_skipped;
    wire init_regs, count_enabled;
    //integer ai,cii;
    
    // Instantiate the UUT (Unit Under Test)
    Ctl uut(clk, reset, trig, split, init_regs, count_enabled); 
    // FILL HERE
    
    initial begin
        correct = 1;
        clk = 0; 
        reset = 1; 
        trig = 0;
        split = 0;
        loop_was_skipped = 0;
        #10
        reset = 0; 
        correct = correct & init_regs & ~count_enabled;
        #20
        #2
        trig = 0;
        // FILL HERE - TEST VARIOUS STATE TRANSITION 
		// AND COMPARE AGAINST EXPECTED OUTPUT SIGNALS
		 #5 
        correct = correct & init_regs & ~count_enabled ;
        // IDLE -> IDLE
        #5 
        trig = 1; 
        #5 
        correct = correct & ~init_regs & count_enabled ;
        // IDLE -> COUNTING
        #5 
        trig = 0;
        #5 
        correct = correct & ~init_regs & count_enabled;
        //  COUNTING -> COUNTING
        #5 
        trig = 1; 
        #5 
        correct = correct & ~init_regs & ~count_enabled;
        //  COUNTING -> PAUSED
        #5 
        trig = 0; 
        split = 0;  
        #5 
        correct = correct & ~init_regs & ~count_enabled;
        // PAUSED -> PAUSED
        #5 
        trig = 1;
        #5
        correct = correct & ~init_regs & count_enabled;
        // PAUSED -> COUNTING
        #5 
        reset=1; 
        #5 
        correct = correct & init_regs & ~count_enabled;
        // COUNTING -> IDLE
        #5
        reset = 0;
        trig = 1;
        #5     
        correct = correct & ~init_regs & count_enabled ;
        // IDLE -> COUNTING
        #5 
        trig = 1; 
        #5 
        correct = correct & ~init_regs & ~count_enabled;
        //  COUNTING -> PAUSED
        #5 
        split = 1;
        trig  = 0;
        #5
        correct = correct & init_regs & ~count_enabled;
        // PAUSED -> IDLE
        #5       
          
        if (correct)
            $display("Test Passed - %m");
        else
            $display("Test Failed - %m");
        $finish;
    end
    
    always #5 clk = ~clk;
    
endmodule
