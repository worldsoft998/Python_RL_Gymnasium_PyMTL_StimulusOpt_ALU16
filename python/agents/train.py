import argparse
from stable_baselines3 import PPO
from stable_baselines3.common.vec_env import DummyVecEnv
from gym_env.alu_env import ALUEnv
import os

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--timesteps", type=int, default=20000)
    parser.add_argument("--save", type=str, default="python/models/ppo_alu.zip")
    args = parser.parse_args()
    os.makedirs(os.path.dirname(args.save), exist_ok=True)
    env = DummyVecEnv([lambda: ALUEnv(max_steps=200)])
    model = PPO('MlpPolicy', env, verbose=1)
    model.learn(total_timesteps=args.timesteps)
    model.save(args.save)
    print("Saved model to", args.save)

if __name__ == '__main__':
    main()
