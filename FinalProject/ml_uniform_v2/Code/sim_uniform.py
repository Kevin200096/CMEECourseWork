#!/usr/bin/env python3
"""
sim_uniform.py  —  Strategy-2: Ne ~ Uniform(5e2, 5e5)
双种子：
  * seed_ne   = 30000 + idx   # 只用于抽样 Ne
  * seed_anc  = 10000 + idx   # ancestry
  * seed_mut  = 20000 + idx   # mutations
输出：
  sim_Ne{Ne_int}_rep{idx:03d}.trees / .vcf
参数（与 3R 接近）：
  samples=50 (50 蚊子，二倍体)
  L=52 Mb,  r=1e-8 /bp,  μ=1e-9 /bp
"""
import os, sys, pathlib, numpy as np, msprime, tskit

idx = int(sys.argv[1])  # PBS_ARRAY_INDEX

# --- 采样 Ne（与 ancestry/mutation 分离） ---
rng_ne  = np.random.default_rng(30000 + idx)
Ne      = rng_ne.uniform(5e2, 5e5)    # 连续 Ne
Ne_int  = int(round(Ne))

seed_anc = 10000 + idx
seed_mut = 20000 + idx

# --- 模拟 ---
ts = msprime.sim_ancestry(
    samples=50, ploidy=2,
    sequence_length=52_000_000,
    recombination_rate=1e-8,
    population_size=Ne,
    random_seed=seed_anc
)
ts = msprime.sim_mutations(ts, rate=1e-9, random_seed=seed_mut)

# --- 文件名 ---
prefix = pathlib.Path(f"sim_Ne{Ne_int:06d}_rep{idx:03d}")
trees  = prefix.with_suffix(".trees")
vcf    = prefix.with_suffix(".vcf")
tmpvcf = prefix.with_suffix(".vcf.tmp")

# --- 保存 .trees ---
ts.dump(trees)

# --- 写 VCF：先写到临时文件，再原子重命名，且确保 POS ≥ 1 ---
with tmpvcf.open("w") as f:
    # 某些旧版 tskit 会出现 0 位置，稳妥起见加一并取整
    ts.write_vcf(f, position_transform=lambda x: [max(1, int(p) + 1) for p in x])

os.replace(tmpvcf, vcf)
print(f"✓ idx={idx:03d}  Ne≈{Ne:.0f}  →  {vcf.name}")
