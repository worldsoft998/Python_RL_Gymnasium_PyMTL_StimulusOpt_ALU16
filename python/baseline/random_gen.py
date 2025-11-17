import numpy as np, csv, os
def generate(n=1000, out='sv/tb/vectors/vectors_rand.csv', seed=42):
    os.makedirs(os.path.dirname(out), exist_ok=True)
    rng = np.random.RandomState(seed)
    with open(out,'w',newline='') as f:
        w=csv.writer(f)
        for _ in range(n):
            op = int(rng.randint(0,5))
            a = int(rng.randint(0,2**16))
            b = int(rng.randint(0,2**16))
            w.writerow([op, hex(a), hex(b)])
    print('Wrote', n, 'random vectors to', out)

if __name__ == '__main__':
    generate()
