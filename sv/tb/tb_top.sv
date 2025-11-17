`timescale 1ns/1ps
module tb_top;
  logic clk;
  logic rst_n;
  logic [3:0] op;
  logic [15:0] a,b;
  logic [15:0] y;
  logic z,c,v;

  // DUT
  alu16 dut(.clk(clk), .rst_n(rst_n), .op(op), .a(a), .b(b), .y(y), .z(z), .c(c), .v(v));

  // simple clock
  initial clk = 0;
  always #5 clk = ~clk;

  initial begin
    rst_n = 0;
    #20;
    rst_n = 1;
    // example: apply two vectors then finish
    op = 0; a = 16'h0001; b = 16'h0002; @(posedge clk); @(posedge clk);
    op = 1; a = 16'h0003; b = 16'h0001; @(posedge clk); @(posedge clk);
    $display("Done"); $finish;
  end
endmodule
