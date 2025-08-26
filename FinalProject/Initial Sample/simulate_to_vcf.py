# simulate_to_vcf.py  (52 Mb • r=1e-8 • μ=1e-9)
import msprime, pathlib

L = 52_000_000          # 52 Mb
r = 1e-8                # recomb per bp
mu = 1e-9               # mut per bp  (≈1/10 of r)

ts = msprime.sim_ancestry(
        samples=50, ploidy=2,    # 50 个二倍体（=100 单倍体) + 让 msprime 自行建 Individuals
        sequence_length=L,
        recombination_rate=r,    # Anopheles 参考比率 ≈10× mutation
        population_size=2_000,
        random_seed=42
)
ts = msprime.sim_mutations(ts, rate=mu)

out = pathlib.Path("ana_sim.vcf")
with out.open("w") as f:
    ts.write_vcf(f)       # ← 删除 ploidy 参数
print("VCF written →", out.resolve())
