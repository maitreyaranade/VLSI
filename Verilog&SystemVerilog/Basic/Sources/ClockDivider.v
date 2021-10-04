module clock_divide_by_2 
    ( 
        input clk,
        input rst,
        output clk_out
    );

    reg  _clk_out;

    always @(posedge clk)
    begin
        if (rst)
            _clk_out <= 1'b0;
        else	
            _clk_out <= ~_clk_out;
    end
    assign clk_out = _clk_out;

endmodule // clock_divide_by_2

module clock_divide_by_even  #( 
        parameter DIVISOR = 6 
    )
    ( 
        input clk,
        input rst,
        output clk_out
    );
    
    reg  [$clog2(DIVISOR) -1:0] cntr;
    wire [$clog2(DIVISOR) -1:0] cntr_nxt;
    reg  _clk_out;
    
    always @(posedge clk or posedge rst)    
    begin
        if (rst)
        begin
            cntr <= 0;
            _clk_out <= 1'b0;
        end    
        else if (cntr_nxt == (DIVISOR >> 1))
        begin
            cntr <= 0;
            _clk_out <= ~_clk_out;
        end    
        else 
            cntr <= cntr_nxt;
    end
 
    assign cntr_nxt = cntr + 1;   	      
    assign clk_out = _clk_out;

endmodule  //clock_divide_by_even



module clock_divide_by_odd #(
        parameter DIVISOR = 5)
    ( 
        input clk,
        input rst,
        output clk_out
    );
 
    reg [$clog2(DIVISOR)-1:0] pos_cntr, neg_cntr;
    
    always @(posedge clk)
    begin
        if (rst)
            pos_cntr <=0;
        else
        begin
            if (pos_cntr == DIVISOR-1)
                pos_cntr <= 0;
            else 
                pos_cntr <= pos_cntr +1;            
        end
    end
    
    always @(negedge clk)
    begin
        if (rst)
            neg_cntr <=0;
        else 
        begin
            if (neg_cntr == DIVISOR-1) 
                neg_cntr <= 0;
            else 
                neg_cntr <= neg_cntr +1; 
        end
    end
    
    assign clk_out = ((pos_cntr > (DIVISOR >> 1)) | (neg_cntr > (DIVISOR >> 1))); 
    
endmodule //clock_divide_by_odd
 