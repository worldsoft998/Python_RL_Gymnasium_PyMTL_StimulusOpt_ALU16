import argparse, csv, os
from stable_baselines3 import PPO
from gym_env.alu_env import ALUEnv

def evaluate(model_path, out_csv='sv/tb/vectors/vectors_rl.csv', episodes=20, steps=200):
    os.makedirs(os.path.dirname(out_csv), exist_ok=True)
    model = PPO.load(model_path)
    env = ALUEnv(max_steps=steps)
    rows = []
    for ep in range(episodes):
        obs, _ = env.reset()
        done = False
        while not done:
            action, _ = model.predict(obs, deterministic=True)
            obs, r, done, _, info = env.step(action)
            rows.append([int(action[0]), hex(int(action[1])), hex(int(action[2]))])
    with open(out_csv, 'w', newline='') as f:
        w = csv.writer(f)
        for r in rows:
            w.writerow(r)
    print('Wrote', len(rows), 'vectors to', out_csv)

if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--model', default='python/models/ppo_alu.zip')
    parser.add_argument('--out', default='sv/tb/vectors/vectors_rl.csv')
    args = parser.parse_args()
    evaluate(args.model, args.out)
