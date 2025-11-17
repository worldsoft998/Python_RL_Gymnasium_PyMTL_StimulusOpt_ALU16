# Architecture

This repository is split into three main areas:

1. RTL (SystemVerilog): the Device Under Test (DUT).
2. UVM Testbench: driver/monitor/sequencer/scoreboard; can replay CSV stimulus.
3. Python (PyMTL3 + Gymnasium + SB3): trains RL agents and exports vectors for replay.

The simple flow:
- Train RL in Python using a PyMTL3 model.
- Export vectors to CSV.
- Replay vectors in UVM (VCS) and collect coverage.

See `docs/architecture.svg` for a diagram.
