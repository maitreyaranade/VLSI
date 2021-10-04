`timescale 1ns/100ps
module clock_divide_tb();

    reg clk, rst;
    wire clk_out_divide_by_2, clk_out_even, clk_out_odd;

    parameter DIVISOR_ODD = 5;
    parameter DIVISOR_EVEN = 6;
    
    clock_divide_by_2 clock_divide_by_2_inst (
        .clk      (clk),
        .rst      (rst),
        .clk_out  (clk_out_divide_by_2)
    );
    
    clock_divide_by_even #(
        .DIVISOR  (DIVISOR_EVEN)
    )  clock_divide_by_even_inst (
        .clk      (clk),
        .rst      (rst),
        .clk_out  (clk_out_even)
    );
    
    clock_divide_by_odd #(
        .DIVISOR  (DIVISOR_ODD)
    )  clock_divide_by_odd_inst (
        .clk      (clk),
        .rst      (rst),
        .clk_out  (clk_out_odd)
    );

        initial
        clk = 1'b0;

        always
        #5  clk = ~clk; 

        initial
        begin
            rst =1'b1;
            #15 rst =1'b0;
            #500 
            $finish;
        end

endmodule // clock_divide_tb