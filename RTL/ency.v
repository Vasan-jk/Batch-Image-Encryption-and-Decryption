module ency_master(o,i,clk,rst);
output [23:0]o;
input [23:0]i;
input clk, rst;

ency_red e1({o[7:0]},{i[7:0]},clk,rst);
ency_green e2({o[15:8]}, {i[15:8]}, clk, rst);
ency_blue e3({o[23:16]}, {i[23:16]}, clk, rst);

endmodule



module ency_red(o,i,clk,rst);
output [7:0]o;
input clk,rst;
input [7:0]i;
//inout [7:0]oe;
wire [7:0]e;
wire [15:0]w;
//wire [15:0]we;

peres p1(w[0],w[1],w[2],i[0],i[1],i[2]);
peres p2(w[3],w[4],w[5],i[5],i[6],i[7]);
feynman_gt f1(w[6],w[7],i[3],i[4]);
pphcg s1(w[8],w[9],w[10],w[11],w[0],w[1],w[2],w[6]);
pphcg s2(w[12],w[13],w[14],w[15],w[7],w[3],w[4],w[5]);
xor_gt x1(o[0],o[1],o[2],o[3],w[8],w[9],w[10],w[11],e[0],e[1],e[2],e[3]);
xor_gt x2(o[4],o[5],o[6],o[7],w[12],w[13],w[14],w[15],e[4],e[5],e[6],e[7]);
lfsr_e1 l1(clk,rst, e);

//xor_gt x3(we[0],we[1],we[2],we[3],oe[0],oe[1],oe[2],oe[3],e[0],e[1],e[2],e[3]);
//xor_gt x4(we[4],we[5],we[6],we[7],oe[4],oe[5],oe[6],oe[7],e[4],e[5],e[6],e[7]);
//scl_gt s3(we[8],we[9],we[10],we[11],we[0],we[1],we[2],we[3]);
//scl_gt s4(we[12],we[13],we[14],we[15],we[4],we[5],we[6],we[7]);
//feynman_gt f2(o[3],o[4],we[11],we[12]);
//peres p3(o[0],o[1],o[2],we[8],we[9],we[10]);
//peres p4(o[5],o[6],o[7],we[13],we[14],we[15]);


endmodule


module ency_blue(o,i,clk,rst);
output [7:0]o;
input clk,rst;
input [7:0]i;
//inout [7:0]oe;
wire [7:0]e;
wire [15:0]w;
//wire [15:0]we;

peres p1(w[0],w[1],w[2],i[0],i[1],i[2]);
peres p2(w[3],w[4],w[5],i[5],i[6],i[7]);
feynman_gt f1(w[6],w[7],i[3],i[4]);
pphcg s1(w[8],w[9],w[10],w[11],w[0],w[1],w[2],w[6]);
pphcg s2(w[12],w[13],w[14],w[15],w[7],w[3],w[4],w[5]);
xor_gt x1(o[0],o[1],o[2],o[3],w[8],w[9],w[10],w[11],e[0],e[1],e[2],e[3]);
xor_gt x2(o[4],o[5],o[6],o[7],w[12],w[13],w[14],w[15],e[4],e[5],e[6],e[7]);
lfsr_e3 l1(clk,rst, e);

//xor_gt x3(we[0],we[1],we[2],we[3],oe[0],oe[1],oe[2],oe[3],e[0],e[1],e[2],e[3]);
//xor_gt x4(we[4],we[5],we[6],we[7],oe[4],oe[5],oe[6],oe[7],e[4],e[5],e[6],e[7]);
//scl_gt s3(we[8],we[9],we[10],we[11],we[0],we[1],we[2],we[3]);
//scl_gt s4(we[12],we[13],we[14],we[15],we[4],we[5],we[6],we[7]);
//feynman_gt f2(o[3],o[4],we[11],we[12]);
//peres p3(o[0],o[1],o[2],we[8],we[9],we[10]);
//peres p4(o[5],o[6],o[7],we[13],we[14],we[15]);


endmodule


module ency_green(o,i,clk,rst);
output [7:0]o;
input clk,rst;
input [7:0]i;
//inout [7:0]oe;
wire [7:0]e;
wire [15:0]w;
//wire [15:0]we;

peres p1(w[0],w[1],w[2],i[0],i[1],i[2]);
peres p2(w[3],w[4],w[5],i[5],i[6],i[7]);
feynman_gt f1(w[6],w[7],i[3],i[4]);
pphcg s1(w[8],w[9],w[10],w[11],w[0],w[1],w[2],w[6]);
pphcg s2(w[12],w[13],w[14],w[15],w[7],w[3],w[4],w[5]);
xor_gt x1(o[0],o[1],o[2],o[3],w[8],w[9],w[10],w[11],e[0],e[1],e[2],e[3]);
xor_gt x2(o[4],o[5],o[6],o[7],w[12],w[13],w[14],w[15],e[4],e[5],e[6],e[7]);
lfsr_e2 l1(clk,rst, e);

//xor_gt x3(we[0],we[1],we[2],we[3],oe[0],oe[1],oe[2],oe[3],e[0],e[1],e[2],e[3]);
//xor_gt x4(we[4],we[5],we[6],we[7],oe[4],oe[5],oe[6],oe[7],e[4],e[5],e[6],e[7]);
//scl_gt s3(we[8],we[9],we[10],we[11],we[0],we[1],we[2],we[3]);
//scl_gt s4(we[12],we[13],we[14],we[15],we[4],we[5],we[6],we[7]);
//feynman_gt f2(o[3],o[4],we[11],we[12]);
//peres p3(o[0],o[1],o[2],we[8],we[9],we[10]);
//peres p4(o[5],o[6],o[7],we[13],we[14],we[15]);


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
