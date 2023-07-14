module ALU  #(parameter N = 8) (
    input signed [N-1:0] A,
    input signed [N-1:0] B,
    input CLOCK,
    input [3:0] OP,
    output reg signed [2*N-1:0] S,
    output reg Carry_out
);


  wire signed [N-1:0] Sum;
  wire Cout_sum;

  wire signed [N-1:0] Sub;
  wire Cout_sub;
    
  wire Cout_neg_B;
  wire Cout_neg_A;

  wire signed [N-1:0] result_neg_B;
  wire signed [N-1:0] result_neg_A;

  reg [N-1:0] T;
  reg [2*N-1:0] shifted_A;
  reg [2*N-1:0] product_reg;
 
   RippleCarryAdder #(N) adder (
        .A(A),
        .B(B),
        .Sum(Sum),
        .Cout(Cout_sum)
    );


    RippleCarryAdder #(N) negate_b (
        .A(~B),
        .B(1),
        .Sum(result_neg_B),
        .Cout(Cout_neg_B)
    );

    RippleCarryAdder #(N) negate_a (
         .A(~A),
         .B(1),
         .Sum(result_neg_A),
         .Cout(Cout_neg_A)
    );

             
    RippleCarryAdder #(N) subtractor (
        .A(A),
        .B(result_neg_B),
        .Sum(Sub),
        .Cout(Cout_sub)
    );


   
    always @(posedge CLOCK) begin
        case(OP)
            // Addition (A + B)
            4'b0000: begin
                S <= Sum;
                Carry_out <= Cout_sum;
            end
            
            // Subtraction (A - B)
            4'b0001: begin
                S <= Sub;
                Carry_out <= Cout_sub;
            end
            
            // Bitwise OR (|A)
            4'b0010: begin
                S <= |A;
                Carry_out <= 1'b0;
            end
            
            // Bitwise OR (|B)
            4'b0011: begin
                S <= |B;
                Carry_out <= 1'b0;
            end
            
            // Bitwise OR (A | B)
            4'b0100: begin
                S <= A | B;
                Carry_out <= 1'b0;
            end
            
            // Logical OR (A || B)
            4'b0101: begin
                S <= A || B;
                Carry_out <= 1'b0;
            end
            
            // Bitwise XOR (^A)
            4'b0110: begin
                S <= ^A;
                Carry_out <= 1'b0;
            end
            
            // Bitwise XOR (^B)
            4'b0111: begin
                S <= ^B;
                Carry_out <= 1'b0;
            end
            
            // Bitwise XOR (A ^ B)
            4'b1000: begin
                S <= A ^ B;
                Carry_out <= 1'b0;
            end
            
            // Bitwise AND (&A)
            4'b1001: begin
                S <= &A;
                Carry_out <= 1'b0;
            end
            
            // Bitwise AND (&B)
            4'b1010: begin
                S <= &B;
                Carry_out <= 1'b0;
            end
            
            // Bitwise AND (A & B)
            4'b1011: begin
                S <= A & B;
                Carry_out <= 1'b0;
            end
            
            // Logical AND (A && B)
            4'b1100: begin
                S <= A && B;
                Carry_out <= 1'b0;
            end
            
            // Two's Complement (~A + 1)
            4'b1101: begin
                S <= result_neg_A;
                Carry_out <= Cout_neg_A;
            end
            
            // Two's Complement (~B + 1)
            4'b1110: begin
                S <= result_neg_B;
                Carry_out <= Cout_neg_B;
            end
            
            // Serial Multiplier (A * B)
            4'b1111: begin
  		if (T[0] == 1'b1) begin
		    product_reg <= product_reg + shifted_A;  	
		    
		end
        	T <= T >> 1;
       		shifted_A <= shifted_A << 1;
		
 		S <= product_reg;
		Carry_out <= 1'b0;
            end
        endcase
    end

       always @(A,B) begin
		if(OP == 4'b1111) begin 
 			
			if(B[N-1] == 1) begin
				shifted_A = ~A+1;
				T = ~B+1;
			end else begin shifted_A = A; T = B; end
			product_reg = 0;
		end
   	end
endmodule

