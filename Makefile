PY=python3
PIP=python3 -m pip

.PHONY: install_py_reqs train_rl export_vectors random_vectors sim_vcs clean

install_py_reqs:
	$(PIP) install -r python/requirements.txt

train_rl:
	$(PY) python/agents/train.py --timesteps $(TIMESTEPS) --save python/models/ppo_alu.zip

export_vectors:
	$(PY) python/agents/evaluate.py --model $(MODEL) --out $(OUT)

random_vectors:
	$(PY) python/baseline/random_gen.py

sim_vcs:
	bash scripts/run_vcs.sh $(VECFILE)

clean:
	rm -rf python/models simv* csrc DVEfiles
