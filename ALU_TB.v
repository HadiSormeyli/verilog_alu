`timescale 1ns/1ns

module ALU_TB;
    parameter CLOCK_SCALE = 5;//base on time scale
    parameter N = 8;
    wire signed [2*N-1:0] S;
    wire Carry_out;
    reg signed [N-1:0] A;
    reg signed [N-1:0] B;
    reg CLOCK;
    reg [3:0] OP;
   
    integer file;
    integer count = 0;
    integer i;
    reg exit_loop = 0;
    reg [N-1:0] B_neg;


    ALU #(N) alu(
        .A(A),
        .B(B),
        .CLOCK(CLOCK),
        .OP(OP),
        .S(S),
        .Carry_out(Carry_out)
    );

   
    always begin
	repeat(CLOCK_SCALE) begin #1; end
        CLOCK = ~CLOCK;
    end

    
    initial begin
     
        repeat(CLOCK_SCALE) begin #1; end CLOCK = 1;
       
        file = $fopen("TEST.txt", "r");

 	
         if (file != 0) begin
      	    $fscanf(file, "A         B         OP");
           $fscanf(file, "\n");
        end
       
        
        if (file != 0) begin
            while (!$feof(file)) begin
                if ($fscanf(file, "%b %b %b", A, B, OP) == 3) begin
		    count = 0;
		    if(OP == 4'b1111) begin
			 count = N;

			if(B[N-1] == 1)
				B_neg = ~B+1;
			else B_neg = B;
			 
			   for(i = N-1;i>=0;i = i -1) begin
				if (B_neg[i] == 1'b0) begin
    					count = count - 1;
				end
				else begin
    					exit_loop = 1;
				end
				
				if(exit_loop) begin
				  i = -1;
				end 
			   end
		    end 
		    exit_loop = 0;
    		    repeat((count+1)*CLOCK_SCALE) begin
                    	#2;
		    end
                end
                
                $display("\nA = %d, B = %d, OP = %b", A, B, OP);
                $display("S = %d, Carry_out = %b\n", S, Carry_out);
            end
	end
        
        if (file != 0)
            $fclose(file);
	$finish;
    end
endmodule

