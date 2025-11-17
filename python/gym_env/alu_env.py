import gymnasium as gym
from gymnasium import spaces
import numpy as np
from pymtl_model.alu_pymtl import ALU16

class ALUEnv(gym.Env):
    def __init__(self, max_steps=200):
        super().__init__()
        self.action_space = spaces.Box(low=0, high=65535, shape=(3,), dtype=np.uint32)
        self.observation_space = spaces.Box(low=0, high=65535, shape=(4,), dtype=np.uint32)
        self.max_steps = max_steps
        self.model = ALU16()
        self.steps = 0
        self.coverage = set()

    def reset(self, seed=None, options=None):
        self.steps = 0
        self.coverage = set()
        return np.array([0,0,0,0], dtype=np.uint32), {}

    def step(self, action):
        op = int(action[0]) & 0xF
        a  = int(action[1]) & 0xFFFF
        b  = int(action[2]) & 0xFFFF
        # apply to model (combinational)
        self.model.op @= op
        self.model.a  @= a
        self.model.b  @= b
        y = int(self.model.y)
        cover = (op, y)
        new = 0
        if cover not in self.coverage:
            self.coverage.add(cover)
            new = 1
        reward = float(new) - 0.01
        self.steps += 1
        done = self.steps >= self.max_steps
        obs = np.array([y, 0,0,0], dtype=np.uint32)
        return obs, reward, done, False, {'coverage':len(self.coverage)}
