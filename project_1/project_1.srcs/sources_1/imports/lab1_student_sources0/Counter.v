`timescale 1ns/10ps
//////////////////////////////////////////////////////////////////////////////////
// Company:         Tel Aviv University
// Engineer:        
// 
// Create Date:     05/05/2019 00:19 AM
// Design Name:     EE3 lab1
// Module Name:     Counter
// Project Name:    Electrical Lab 3, FPGA Experiment #1
// Target Devices:  Xilinx BASYS3 Board, FPGA model XC7A35T-lcpg236C
// Tool versions:   Vivado 2016.4
// Description:     a counter that advances its reading as long as time_reading 
//                  signal is high and zeroes its reading upon init_regs=1 input.
//                  the time_reading output represents: 
//                  {dekaseconds,seconds}
// Dependencies:    Lim_Inc
//
// Revision         3.0
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Counter(clk, init_regs, count_enabled, time_reading);

   parameter CLK_FREQ = 100000000;// in Hz
   //parameter CLK_FREQ = 1000;
   parameter CHAR_LIMIT = $clog2(CLK_FREQ)-1;
   
   input clk, init_regs, count_enabled;
   output [7:0] time_reading;

   reg [CHAR_LIMIT:0] clk_cnt;
   reg [3:0] ones_seconds;    
   reg [3:0] tens_seconds;    
   reg [3:0] compInput;
   wire [3:0] compOutput;
   wire compCout;
   
   wire [CHAR_LIMIT:0] clk_verify;
   wire [3:0] sec_verify;
   wire clk_overflow;
   wire sec_overflow;
     
   
   Lim_Inc #(CLK_FREQ) clkInc(clk_cnt, 1'b1, clk_verify, clk_overflow);
   Lim_Inc #(4) minInc(ones_seconds, 1'b1, sec_verify, sec_overflow);
   Compadder #(4) cmpAdr(compInput, 4'b0001, compOutput, compCout);
   
   //------------- Synchronous ----------------
   always @(posedge clk)
     begin
        if (init_regs == 1)
            begin
                ones_seconds <= 4'b0000;
                tens_seconds <= 4'b0000;
                clk_cnt <= 0;
                compInput = 4'b0000;
            end
        else
            begin
                if (sec_overflow == 1)
                    begin
                        compInput = tens_seconds;
                        tens_seconds <= compOutput;
                        ones_seconds <= 4'b0000;
                    end
                if (clk_overflow == 1)
                    begin
                        compInput = ones_seconds;
                        ones_seconds <= compOutput;
                        clk_cnt <= 0;
                    end
            end
        if (count_enabled == 1)
            begin
                clk_cnt <= clk_verify;
            end
     end
    assign time_reading = {tens_seconds, ones_seconds};

endmodule
