module sequence_detector_101101_mealy(
    input clk,
    input rst,
    input in,
    output reg out
    );

    reg [2:0] state;
    reg [2:0] next_state;

    parameter [2:0] s0 = 3'b000;
    parameter [2:0] s1 = 3'b001;
    parameter [2:0] s2 = 3'b010;
    parameter [2:0] s3 = 3'b011;
    parameter [2:0] s4 = 3'b100;
    parameter [2:0] s5 = 3'b101;

    always @(posedge clk)
    begin
        if (rst)
            state = s0;
        else
            state = next_state;
    end

    always @ *
    begin
        case(state)        
        s0:
        begin
            if (in)
            begin
                next_state = s1;
                out = 1'b0;
            end
            else
            begin
                next_state = s0;
                out = 1'b0;
            end
        end

        s1:
        begin
            if (in)
            begin
                next_state = s1;
                out = 1'b0;
            end
            else
            begin
                next_state = s2;
                out = 1'b0;
            end
        end

        s2:
        begin
            if (in)
            begin
                next_state = s3;
                out = 1'b0;
            end
            else
            begin
                next_state = s0;
                out = 1'b0;
            end
        end

        s3:
        begin
            if (in)
            begin
                next_state = s4;
                out = 1'b0;
            end
            else
            begin
                next_state = s2;
                out = 1'b0;
            end
        end

        s4:
        begin
            if (in)
            begin
                next_state = s1;
                out = 1'b0;
            end
            else
            begin
                next_state = s5;
                out = 1'b0;
            end
        end

        s5:
        begin
            if (in)
            begin
                next_state = s3;
                out = 1'b1;
            end
            else
            begin
                next_state = s0;
                out = 1'b0;
            end
        end

        default:
        begin
            next_state = s0;
            out = 1'b0;
        end
    endcase
 	end
endmodule  //sequence_detector_101101_mealy














module sequence_detector_101101_moore(
    input clk,
    input rst,
    input in,
    output reg out
    );

    reg [2:0] state;
    reg [2:0] next_state;

    parameter [2:0] A = 3'b000;
    parameter [2:0] B = 3'b001;
    parameter [2:0] C = 3'b010;
    parameter [2:0] D = 3'b011;
    parameter [2:0] E = 3'b100;
    parameter [2:0] F = 3'b101;
    parameter [2:0] G = 3'b110;

    always @(posedge clk)
    begin
        if (rst)
            state <= A;
        else
            state <= next_state;
    end

    always @ *
    begin
        case(state)        
        A:
        begin
            out <= 1'b0;
            if (in)
                next_state <= B;
            else
                next_state <= A;
        end

        B:
        begin
            out <= 1'b0;
            if (in)
                next_state <= B;
            else
                next_state <= C;
        end

        C:
        begin
            out <= 1'b0;
            if (in)
                next_state <= D;
            else
                next_state <= A;
        end

        D:
        begin
            out <= 1'b0;
            if (in)
                next_state <= E;
            else
                next_state <= C;
        end

        E:
        begin
            out <= 1'b0;
            if (in)
                next_state <= B;
            else
                next_state <= F;
        end

        F:
        begin
            out <= 1'b0;
            if (in)
                next_state <= G;
            else
                next_state <= A;
        end

        G:
        begin
            out <= 1'b1;
            if (in)
                next_state <= E;
            else
                next_state <= C;
        end

        default:
            next_state <= A;
    endcase
 	end
endmodule  //sequence_detector_101101_moore