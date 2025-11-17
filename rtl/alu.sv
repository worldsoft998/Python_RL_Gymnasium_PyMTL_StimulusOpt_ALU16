`timescale 1ns/1ps
module alu16 (
  input  logic        clk,
  input  logic        rst_n,
  input  logic [3:0]  op,
  input  logic [15:0] a,
  input  logic [15:0] b,
  output logic [15:0] y,
  output logic        z,
  output logic        c,
  output logic        v
);
  logic [16:0] tmp;
  always_comb begin
    case (op)
      4'd0: tmp = {1'b0,a} + {1'b0,b}; // add
      4'd1: tmp = {1'b0,a} - {1'b0,b}; // sub
      4'd2: tmp = {1'b0,a} & {1'b0,b};
      4'd3: tmp = {1'b0,a} | {1'b0,b};
      4'd4: tmp = {1'b0,a} ^ {1'b0,b};
      default: tmp = {1'b0,a} + {1'b0,b};
    endcase
  end

  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      y <= 16'd0; z <= 1'b1; c <= 1'b0; v <= 1'b0;
    end else begin
      y <= tmp[15:0];
      c <= tmp[16];
      z <= (tmp[15:0] == 16'd0);
      // simple signed overflow detection for add/sub
      v <= 1'b0;
      if (op == 0) v <= ((a[15] == b[15]) && (y[15] != a[15]));
      else if (op == 1) v <= ((a[15] != b[15]) && (y[15] != a[15]));
    end
  end
endmodule
