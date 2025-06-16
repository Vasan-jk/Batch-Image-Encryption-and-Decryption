module decy_master(o,i,clk,rst);
output [23:0]o;
input [23:0]i;
input clk, rst;

decy_red e1({o[7:0]},{i[7:0]},clk,rst);
decy_green e2({o[15:8]}, {i[15:8]}, clk, rst);
decy_blue e3({o[23:16]}, {i[23:16]}, clk, rst);

endmodule


module decy_red(o,i,clk,rst);
output [7:0]o;
input clk,rst;
input [7:0]i;
//inout [7:0]oe;
wire [7:0]e;
wire [15:0]w;
//wire [15:0]we;

xor_gt x1(w[0], w[1], w[2], w[3], i[0], i[1], i[2], i[3], e[0], e[1], e[2], e[3]);
xor_gt x2(w[4], w[5], w[6], w[7], i[4], i[5], i[6], i[7], e[4], e[5], e[6], e[7]);
pphcg s1(w[8], w[9], w[10], w[11], w[0], w[1], w[2], w[3]);
pphcg s2(w[12], w[13], w[14], w[15], w[4], w[5], w[6], w[7]);
feynman_gt f1(o[3], o[4], w[11], w[12]);
peres p1(o[0], o[1], o[2], w[8], w[9], w[10]);
peres p2(o[5], o[6], o[7], w[13], w[14], w[15]);
lfsr_e1 e1(clk, rst, e);

endmodule


module decy_blue(o,i,clk,rst);
output [7:0]o;
input clk,rst;
input [7:0]i;
//inout [7:0]oe;
wire [7:0]e;
wire [15:0]w;
//wire [15:0]we;

xor_gt x1(w[0], w[1], w[2], w[3], i[0], i[1], i[2], i[3], e[0], e[1], e[2], e[3]);
xor_gt x2(w[4], w[5], w[6], w[7], i[4], i[5], i[6], i[7], e[4], e[5], e[6], e[7]);
pphcg s1(w[8], w[9], w[10], w[11], w[0], w[1], w[2], w[3]);
pphcg s2(w[12], w[13], w[14], w[15], w[4], w[5], w[6], w[7]);
feynman_gt f1(o[3], o[4], w[11], w[12]);
peres p1(o[0], o[1], o[2], w[8], w[9], w[10]);
peres p2(o[5], o[6], o[7], w[13], w[14], w[15]);
lfsr_e3 e3(clk, rst, e);


endmodule


module decy_green(o,i,clk,rst);
output [7:0]o;
input clk,rst;
input [7:0]i;
//inout [7:0]oe;
wire [7:0]e;
wire [15:0]w;
//wire [15:0]we;

xor_gt x1(w[0], w[1], w[2], w[3], i[0], i[1], i[2], i[3], e[0], e[1], e[2], e[3]);
xor_gt x2(w[4], w[5], w[6], w[7], i[4], i[5], i[6], i[7], e[4], e[5], e[6], e[7]);
pphcg s1(w[8], w[9], w[10], w[11], w[0], w[1], w[2], w[3]);
pphcg s2(w[12], w[13], w[14], w[15], w[4], w[5], w[6], w[7]);
feynman_gt f1(o[3], o[4], w[11], w[12]);
peres p1(o[0], o[1], o[2], w[8], w[9], w[10]);
peres p2(o[5], o[6], o[7], w[13], w[14], w[15]);
lfsr_e2 e2(clk, rst, e);

endmodule


module lfsr_e1 (
    input wire clk,
    input wire rst,         
    output reg [7:0] lfsr
);

wire feedback;

assign feedback = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3];

always @(posedge clk) begin
    if (rst)
        lfsr <= 8'b00000001;  // Seed value (must be non-zero)
    else
        lfsr <= {lfsr[6:0], feedback};
end

endmodule



module lfsr_e2 (
    input wire clk,
    input wire rst,         // Active-high synchronous reset
    output reg [7:0] lfsr
);

wire feedback;

// New feedback taps at positions 7, 5, 4, 3, 2, 1
assign feedback = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3] ^ lfsr[2] ^ lfsr[1];

always @(posedge clk) begin
    if (rst)
        lfsr <= 8'b00000001;  // Seed value (must be non-zero)
    else
        lfsr <= {lfsr[6:0], feedback};
end

endmodule


module lfsr_e3 (
    input wire clk,
    input wire rst,         // Active-high synchronous reset
    output reg [7:0] lfsr
);

wire feedback;

// New feedback function with taps at positions 7, 5, 4, 1
assign feedback = lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[1];

always @(posedge clk) begin
    if (rst)
        lfsr <= 8'b00000001;  // Seed value (must be non-zero)
    else
        lfsr <= {lfsr[6:0], feedback};
end

endmodule


 module xor_gt(p, q, r, s, f1, f2, f3, fy, k1, k2, k3, k4);
    input f1, f2, f3, fy, k1, k2, k3, k4;
    output p, q, r, s;
    assign p = f1 ^ k1;
    assign q = f2 ^ k2;
    assign r = f3 ^ k3;
    assign s = fy ^ k4;
endmodule


module feynman_gt(p, q, a, b);
    input a, b;
    output p, q;
    assign p = a;
    assign q = a ^ b;
endmodule



module pphcg(a,b,c,d,w,x,y,z);
output a,b,c,d;
input w,x,y,z;
assign a=x^y^z;
assign b=w^x^y;
assign c=w^x^z;
assign d=w^y^z;
endmodule

module peres(a,b,c,x,y,z);
output a,b,c;
input x,y,z;
assign a=x;
assign b=x^y;
assign c=x&y^z;
endmodule
