#!/usr/bin/env bash
set -e
VCS=vcs
OUT=simv
mkdir -p $OUT
SVS="rtl/alu.sv sv/uvm/alu_if.sv sv/uvm/alu_uvm_pkg.sv sv/uvm/tb_top_uvm.sv"
echo "Compiling..."
$VCS -full64 -sverilog +acc +vpi $SVS -o $OUT/simv
echo "Running sim..."
$OUT/simv +UVM_TESTNAME=alu_test +mode=file +vecfile=${1:-sv/tb/vectors/vectors_rl.csv}
