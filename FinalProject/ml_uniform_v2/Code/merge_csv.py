#!/usr/bin/env python3
# merge_csv.py — robust merger for mixed CSV formats
# Outputs: dataset.csv with columns: Ne, rep, bin1..bin30

import glob, re
import numpy as np
import pandas as pd
from pathlib import Path

def parse_ids(fname):
    m_ne  = re.search(r"Ne(\d+)", fname)
    m_rep = re.search(r"rep(\d+)", fname)
    if not (m_ne and m_rep):
        raise ValueError(f"Cannot parse Ne/rep from {fname}")
    return int(m_ne.group(1)), int(m_rep.group(1))

rows, bad = [], []
files = sorted(glob.glob("sim_Ne*_rep*.csv"))

for f in files:
    try:
        ne, rep = parse_ids(f)
        df = pd.read_csv(f, header=None)
        vals = df.values.flatten().astype(float)

        if len(vals) == 30:
            # old style: bins only
            bins = vals
        elif len(vals) == 32:
            # new style: likely [rep, Ne, 30 bins] 或 [Ne, rep, 30 bins]
            a, b = vals[0], vals[1]
            # 与文件名的 rep/ne 做一致性检查
            if abs(a - rep) < 1e-6 and abs(b - ne) < 1e-6:
                bins = vals[2:]
            elif abs(a - ne) < 1e-6 and abs(b - rep) < 1e-6:
                bins = vals[2:]
            else:
                # 保险起见，取最后 30 个数作为 bins
                bins = vals[-30:]
            if len(bins) != 30:
                raise ValueError("32 列文件未能正确解析 30 个 bins")
        else:
            # 其他异常列数（例如 34），尽量取最后 30 个
            bins = vals[-30:]
            if len(bins) != 30:
                raise ValueError(f"Unexpected {len(vals)} columns")

        row = [ne, rep] + bins.tolist()
        rows.append(row)

    except Exception as e:
        bad.append((f, str(e)))

cols = ["Ne", "rep"] + [f"bin{i}" for i in range(1, 31)]
out = pd.DataFrame(rows, columns=cols).sort_values(["Ne", "rep"]).reset_index(drop=True)
out.to_csv("dataset.csv", index=False)
print(f"dataset.csv generated with {len(out)} rows")

if bad:
    with open("merge_errors.log", "w") as fh:
        for f, msg in bad:
            fh.write(f"{f}\t{msg}\n")
    print(f"[warn] {len(bad)} CSV had issues. See merge_errors.log")