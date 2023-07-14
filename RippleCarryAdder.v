module RippleCarryAdder  #(parameter N = 8) (
    input signed [N-1:0] A,
    input signed [N-1:0] B,
    output signed [N-1:0] Sum,
    output Cout
);

wire [N-1:0] SumTemp;
wire [N:0] Carry;

assign Carry[0] = 1'b0;

genvar i;
generate
    for (i = 0; i < N; i = i + 1) begin : ADDER_LOOP
        FullAdder FA (
            .A(A[i]),
            .B(B[i]),
            .Cin(Carry[i]),
            .Sum(SumTemp[i]),
            .Cout(Carry[i+1])
        );
    end
endgenerate

assign Cout = Carry[N];
assign Sum = {Cout, SumTemp};

endmodule

module FullAdder (
    input A,
    input B,
    input Cin,
    output Sum,
    output Cout
);

wire CoutIntermediate;
wire SumIntermediate;

assign SumIntermediate = A ^ B ^ Cin;
assign CoutIntermediate = (A & B) | (Cin & (A ^ B));
assign Sum = SumIntermediate;
assign Cout = CoutIntermediate;

endmodule
