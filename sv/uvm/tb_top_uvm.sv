`timescale 1ns/1ps
`include "sv/uvm/alu_if.sv"
`include "sv/uvm/alu_uvm_pkg.sv"
module tb_top_uvm;
  import uvm_pkg::*;
  import alu_uvm_pkg::*;
  logic clk; logic rst_n;
  initial clk = 0; always #5 clk = ~clk;
  alu_if vif(.clk(clk), .rst_n(rst_n));
  alu16 dut(.clk(clk), .rst_n(rst_n), .op(vif.op), .a(vif.a), .b(vif.b), .y(vif.y), .z(vif.z), .c(vif.c), .v(vif.v));
  initial begin
    rst_n = 0; vif.op = 0; vif.a = 0; vif.b = 0; #20; rst_n = 1;
    uvm_config_db#(virtual alu_if)::set(null, "*", "vif", vif);
    run_test("alu_test");
  end
endmodule
