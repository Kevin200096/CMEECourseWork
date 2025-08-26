#!/usr/bin/env python
"""
sim_grid.py   usage:  python sim_grid.py  <PBS_ARRAY_INDEX>
                ^o    ^z^o ^|   ^m  ^p = 1000 + idx
                ^s ^g   sim_Ne{Ne}_rep{r}.vcf
"""
import msprime, pathlib, sys

idx = int(sys.argv[1])                    # 1 ^` N  ^t  PBS -J     ^e 

# ----  ^o^b ^u   ^q    -------------------------------------------------
Ne_list = [5e2, 1e3, 2e3, 5e3, 1e4,
           2e4, 5e4, 1e5, 2e5, 5e5]      # 10        ^u  Ne
R   = 30                                  #   ^o    Ne 30   ^m ^h 
Ne  = Ne_list[(idx-1)//R]
rep = (idx-1) % R + 1

# ---- msprime     ^k^= --------------------------------------------
ts = msprime.sim_ancestry(
        samples          = 50,            # 50  ^z^j  ^p
        ploidy           = 2,
        sequence_length  = 52_000_000,    # 52 ^` Mb 3R  ^u    
        recombination_rate = 1e-8,
        population_size  = Ne,
        random_seed	 = 1000 + idx
)
ts = msprime.sim_mutations(ts, rate = 1e-9)

out = pathlib.Path(f"sim_Ne{int(Ne):06d}_rep{rep:02d}.vcf")
with out.open("w") as f: ts.write_vcf(f)
print(" ^|^s", out)