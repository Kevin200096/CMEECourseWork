#!/usr/bin/env python3
"""
merge_csv_3epoch.py  ^`^t  ^p^h     ^i    Ne  ^z^d CSV  ^h  dataset_threeepoch.csv
  ^o    ^m^u  ^l CSV      ^b  ^zrep,Ne1,Ne2,Ne3,bin1..bin30    ^h ^e  34  ^h^w  ^i
"""
import glob, re
import numpy as np, pandas as pd

def parse_ids(fn):
    m1 = re.search(r"Ne1(\d+)", fn)
    m2 = re.search(r"Ne2(\d+)", fn)
    m3 = re.search(r"Ne3(\d+)", fn)
    mr = re.search(r"rep(\d+)", fn)
    if not (m1 and m2 and m3 and mr):
        raise ValueError(f"bad filename: {fn}")
    return int(m1.group(1)), int(m2.group(1)), int(m3.group(1)), int(mr.group(1))

rows = []
bad  = []
for f in sorted(glob.glob("sim_Ne1*_Ne2*_Ne3*_rep*.csv")):
    try:
        Ne1, Ne2, Ne3, rep = parse_ids(f)
        arr = pd.read_csv(f, header=None).values.flatten().astype(float)
        #   ^d ^|^= 34  ^h^w  ^hrep,Ne1,Ne2,Ne3 + 30bins  ^i
        if len(arr) >= 30:
            bins = arr[-30:]
        else:
            raise ValueError(f"columns={len(arr)} < 30")
        rows.append([Ne1,Ne2,Ne3,rep] + bins.tolist())
    except Exception as e:
        bad.append((f, str(e)))

cols = ["Ne1","Ne2","Ne3","rep"] + [f"bin{i}" for i in range(1,31)]
out  = pd.DataFrame(rows, columns=cols).sort_values(["rep"]).reset_index(drop=True)
out.to_csv("dataset_threeepoch.csv", index=False)
print(f"dataset_threeepoch.csv generated with {len(out)} rows")

if bad:
    import sys
    print(f"[warn] {len(bad)} csv failed to merge; see merge_3epoch_errors.log", file=sys.stderr)
    with open("merge_3epoch_errors.log","w") as fh:
        for f,msg in bad: fh.write(f"{f}\t{msg}\n")