module Stash_tb();

    reg clk, reset, sample_in_valid, next_sample, correct, loop_was_skipped;
    reg [7:0] sample_in;
    wire [7:0] sample_out;
    integer ini;
    
    Stash stsh (clk, reset, sample_in, sample_in_valid, next_sample, sample_out);
        
    
    initial begin
        correct = 1;
        clk = 0; 
        reset = 1; 
        loop_was_skipped = 1;
        next_sample = 0;
        sample_in_valid = 0;
        #6;
        reset = 0;
        for( ini=0; ini<7; ini=ini+1 ) begin  
            #10 sample_in = 7 + ini;
            sample_in_valid <= 1;
            #10
            correct =  (sample_out == sample_in) & correct;
            loop_was_skipped = 0;
            sample_in_valid = 0;
            next_sample <= 1;
            #5
            next_sample <= 0;
        end
        #5
        if (correct && ~loop_was_skipped)
            $display("Test Passed - %m");
        else
            $display("Test Failed - %m");
        $finish;
    end
    
    always #5 clk = ~clk;
    
endmodule