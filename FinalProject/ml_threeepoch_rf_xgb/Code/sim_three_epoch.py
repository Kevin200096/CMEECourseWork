#!/usr/bin/env python3
"""
sim_three_epoch.py — Strategy-3: 三段常数 Ne（近10代 / 11–50代 / >50代）
每个 PBS 子任务（idx）生成一组三元 (Ne1,Ne2,Ne3)，并导出 .trees 和 .vcf

参数（与之前保持一致）：
  samples=50（二倍体 50 只蚊子），L=52 Mb，r=1e-8/bp，μ=1e-9/bp
Ne 取值：Ne1,Ne2,Ne3 ~ Uniform(5e2, 5e4)  （导师要求的范围）
时间分段（以“代”为单位）：
  0–10 代    → Ne1
  10–50 代   → Ne2
  >50 代     → Ne3
"""
import os, sys, pathlib
import numpy as np
import msprime, tskit

assert len(sys.argv) >= 2, "usage: python sim_three_epoch.py <PBS_ARRAY_INDEX>"
idx = int(sys.argv[1])  # 1..2000

# ---- 双种子设计（可复现）----
rng_ne   = np.random.default_rng(40000 + idx)  # 只用于抽样三段 Ne
Ne1 = float(rng_ne.uniform(5e2, 5e4))
Ne2 = float(rng_ne.uniform(5e2, 5e4))
Ne3 = float(rng_ne.uniform(5e2, 5e4))
Ne1_i, Ne2_i, Ne3_i = int(round(Ne1)), int(round(Ne2)), int(round(Ne3))

seed_anc = 10000 + idx  # ancestry
seed_mut = 20000 + idx  # mutations

# ---- 三段常数 Ne 的 demography ----
dem = msprime.Demography()
dem.add_population(name="pop", initial_size=Ne1)                       # 0–10 代为 Ne1
dem.add_population_parameters_change(time=10,  initial_size=Ne2, population="pop")  # 10–50 代
dem.add_population_parameters_change(time=50,  initial_size=Ne3, population="pop")  # >50 代

# ---- 模拟 ----
ts = msprime.sim_ancestry(
    samples=50, ploidy=2,
    sequence_length=52_000_000,
    recombination_rate=1e-8,
    demography=dem,
    random_seed=seed_anc
)
ts = msprime.sim_mutations(ts, rate=1e-9, random_seed=seed_mut)

# ---- 文件名（零填充，便于解析）----
prefix = pathlib.Path(f"sim_Ne1{Ne1_i:05d}_Ne2{Ne2_i:05d}_Ne3{Ne3_i:05d}_rep{idx:04d}")
trees  = prefix.with_suffix(".trees")
vcf    = prefix.with_suffix(".vcf")
tmpvcf = prefix.with_suffix(".vcf.tmp")

# ---- 保存 .trees ----
ts.dump(trees)

# ---- 写 VCF：先写临时文件，再原子重命名；确保 POS≥1（规避旧 tskit 的 POS=0）----
with tmpvcf.open("w") as f:
    ts.write_vcf(f, position_transform=lambda x: [max(1, int(p) + 1) for p in x])
os.replace(tmpvcf, vcf)

print(f"✓ idx={idx:04d}  Ne1≈{Ne1_i} Ne2≈{Ne2_i} Ne3≈{Ne3_i}  →  {vcf.name}")
