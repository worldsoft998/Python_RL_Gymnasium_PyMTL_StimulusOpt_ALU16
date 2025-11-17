interface alu_if (input logic clk, input logic rst_n);
  logic [3:0] op;
  logic [15:0] a;
  logic [15:0] b;
  logic [15:0] y;
  logic z,c,v;
endinterface
