`ifndef ALU_UVM_PKG_SV
`define ALU_UVM_PKG_SV
import uvm_pkg::*;
`include "uvm_macros.svh"

package alu_uvm_pkg;
  // seq_item
  typedef struct packed { logic [3:0] op; logic [15:0] a; logic [15:0] b; } alu_trans_t;

  class alu_seq_item extends uvm_sequence_item;
    `uvm_object_utils(alu_seq_item)
    rand bit [3:0] op;
    rand bit [15:0] a,b;
    function new(string name="alu_seq_item"); super.new(name); endfunction
  endclass

  class alu_sequencer extends uvm_sequencer #(alu_seq_item);
    `uvm_component_utils(alu_sequencer)
    function new(string name, uvm_component parent); super.new(name,parent); endfunction
  endclass

  class alu_driver extends uvm_driver #(alu_seq_item);
    `uvm_component_utils(alu_driver)
    virtual alu_if vif;
    function new(string name, uvm_component parent); super.new(name,parent); endfunction
    function void build_phase(uvm_phase phase);
      if(!uvm_config_db#(virtual alu_if)::get(this,"","vif",vif)) `uvm_fatal("NOVIF","no vif");
    endfunction
    task run_phase(uvm_phase phase);
      alu_seq_item it;
      forever begin
        seq_item_port.get_next_item(it);
        @(posedge vif.clk);
        vif.op <= it.op; vif.a <= it.a; vif.b <= it.b;
        @(posedge vif.clk);
        seq_item_port.item_done();
      end
    endtask
  endclass

  class alu_monitor extends uvm_component;
    `uvm_component_utils(alu_monitor)
    virtual alu_if vif;
    uvm_analysis_port #(alu_trans_t) ap;
    function new(string name, uvm_component parent); super.new(name,parent); ap = new("ap", this); endfunction
    function void build_phase(uvm_phase phase);
      if(!uvm_config_db#(virtual alu_if)::get(this,"","vif",vif)) `uvm_fatal("NOVIF","no vif");
    endfunction
    task run_phase(uvm_phase phase);
      alu_trans_t tr;
      forever begin
        @(posedge vif.clk);
        tr.op = vif.op; tr.a = vif.a; tr.b = vif.b;
        ap.write(tr);
      end
    endtask
  endclass

  class alu_scoreboard extends uvm_component;
    `uvm_component_utils(alu_scoreboard)
    uvm_analysis_imp#(alu_trans_t, alu_scoreboard) imp;
    int unsigned uniq_cnt;
    typedef string key_t;
    static bit seen_map[string];
    function new(string name, uvm_component parent); super.new(name,parent); imp = new("imp", this); uniq_cnt = 0; endfunction

    function void write(alu_trans_t t);
      logic [16:0] tmp;
      logic [15:0] exp_y;
      tmp = {1'b0,t.a} + {1'b0,t.b};
      exp_y = tmp[15:0];
      string k = $sformatf("%0d_%0h", t.op, exp_y);
      if (!seen_map.exists(k)) begin
        seen_map[k] = 1; uniq_cnt++;
      end
    endfunction

    function void report_phase(uvm_phase phase);
      `uvm_info("SCORE","Unique op,y pairs: " $sformatf("%0d", uniq_cnt), UVM_LOW);
    endfunction
  endclass

  class alu_env extends uvm_env;
    `uvm_component_utils(alu_env)
    alu_sequencer seqr; alu_driver drv; alu_monitor mon; alu_scoreboard sb;
    function new(string name, uvm_component parent); super.new(name,parent); endfunction
    function void build_phase(uvm_phase phase);
      seqr = alu_sequencer::type_id::create("seqr", this);
      drv  = alu_driver::type_id::create("drv", this);
      mon  = alu_monitor::type_id::create("mon", this);
      sb   = alu_scoreboard::type_id::create("sb", this);
    endfunction
    function void connect_phase(uvm_phase phase);
      drv.seq_item_port.connect(seqr.seq_item_export);
      mon.ap.connect(sb.imp);
    endfunction
  endclass

  class alu_test extends uvm_test;
    `uvm_component_utils(alu_test)
    alu_env env;
    function new(string name="alu_test", uvm_component parent=null); super.new(name,parent); endfunction
    function void build_phase(uvm_phase phase);
      env = alu_env::type_id::create("env",this);
    endfunction

    task run_phase(uvm_phase phase);
      phase.raise_objection(this);
      alu_seq_item it;
      repeat(1000) begin
        it = alu_seq_item::type_id::create("it");
        assert(it.randomize() with { op inside {0,1,2,3,4}; });
        env.seqr.start_item(it);
        env.seqr.finish_item(it);
      end
      phase.drop_objection(this);
    endtask
  endclass

endpackage : alu_uvm_pkg
`endif
