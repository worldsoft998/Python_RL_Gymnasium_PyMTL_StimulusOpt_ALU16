# ALU-RL-Verification — Professional Demo Repo

This repository demonstrates a complete flow for Reinforcement-Learning (RL) assisted verification of a 16-bit ALU.

It includes:

- SystemVerilog RTL for a 16-bit ALU (`rtl/alu.sv`).
- A full UVM testbench (driver, monitor, sequencer, scoreboard, tests) under `uvm/`.
- Python-side RL training using Gymnasium + stable-baselines3, with a PyMTL3-compatible ALU model (`python/`).
- Scripts and Makefile to train, export vectors, and run Synopsys VCS simulations.
- Functional coverage hooks and a simple golden-model checker.
- Documentation and architecture diagram (`docs/architecture.svg`).
- MIT License, CONTRIBUTING notes, and example run recipes.

> **Goal**: show how an RL agent can generate high-value stimulus to maximize coverage and reduce test vectors compared to random stimulus.

---

## Quick start (recommended)

1. Install Python requirements:
```bash
python3 -m venv venv
source venv/bin/activate
python3 -m pip install -r python/requirements.txt
# Install torch appropriate for your platform if needed before stable-baselines3
```

2. Prepare vectors directory:
```bash
mkdir -p sv/tb/vectors
```

3. Train an RL agent (example):
```bash
make install_py_reqs
make train_rl TIMESTEPS=50000
```

4. Export vectors (RL-driven) for simulation:
```bash
make export_vectors MODEL=python/models/ppo_alu.zip OUT=sv/tb/vectors/vectors_rl.csv
```

5. Run VCS simulation with RL vectors:
```bash
make sim_vcs VECFILE=sv/tb/vectors/vectors_rl.csv
```

6. Compare with baseline random vectors:
```bash
make random_vectors N=1000 OUT=sv/tb/vectors/vectors_rand.csv
make sim_vcs VECFILE=sv/tb/vectors/vectors_rand.csv
```

---

## Repo layout

```
alu_rl_repo_professional/
├─ Makefile
├─ LICENSE
├─ README.md
├─ CONTRIBUTING.md
├─ docs/
│  ├─ architecture.svg
│  └─ architecture.md
├─ rtl/
│  └─ alu.sv
├─ sv/
│  └─ tb/
│     └─ tb_top.sv
├─ sv/uvm/
│  ├─ alu_if.sv
│  ├─ alu_uvm_pkg.sv
│  └─ tb_top_uvm.sv
├─ python/
│  ├─ requirements.txt
│  ├─ pymtl_model/
│  │  └─ alu_pymtl.py
│  ├─ gym_env/
│  │  └─ alu_env.py
│  ├─ agents/
│  │  ├─ train.py
│  │  ├─ evaluate.py
│  │  └─ export_vectors.py
│  └─ baseline/
│     └─ random_gen.py
└─ scripts/
   └─ run_vcs.sh
```

---

## Notes

- The Python training is faster using the PyMTL3 model as a stand‑in for the RTL — this repo includes a PyMTL3 behavioural model that matches the RTL semantics.
- The VCS flow uses an export-and-replay method: RL trains in Python, exports stimulus CSV, then the UVM testbench (or simple SV TB) replays vectors in VCS. This design avoids complicated live co-simulation but keeps a practical workflow.
- For live co-simulation (agent interacting with RTL during RTL simulation), a socket/DPI approach can be added; contact me if you want that.

If you'd like, I can now:
- add a CI script,
- add richer functional coverage and a coverage collection script,
- or produce a pre-built run on your target environment (with specific VCS flags).

