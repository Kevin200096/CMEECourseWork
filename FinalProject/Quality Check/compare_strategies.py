#!/usr/bin/env python3
# compare_strategies.py
import json, pandas as pd
from pathlib import Path
import subprocess, sys

pairs = [
    ("dataset_uniform.csv", "ml_uniform"),
    ("dataset_grid.csv",    "ml_grid")
]

for csv, outdir in pairs:
    if not Path(outdir, "metrics.json").exists():
        print(f"[run] {csv} → {outdir}")
        subprocess.check_call([sys.executable, "train_ne_regression.py",
                               "--csv", csv, "--outdir", outdir, "--seed", "202", "--cv", "5"])

rows = []
for csv, outdir in pairs:
    with open(Path(outdir, "metrics.json")) as f:
        m = json.load(f)
    for mdl in ("RF", "XGB"):
        if mdl in m:
            rows.append({
                "dataset": Path(csv).stem,
                "model": mdl,
                "R2": m[mdl]["R2"],
                "RMSE_log10": m[mdl]["RMSE_log10"],
                "RMSE_multiplier": m[mdl]["RMSE_multiplier"],
                "Spearman": m[mdl]["Spearman"],
                "R2_cv_mean": m[mdl].get("R2_cv_mean", None),
                "RMSE_log10_cv_mean": m[mdl].get("RMSE_log10_cv_mean", None)
            })

pd.DataFrame(rows).to_csv("ml_compare_uniform_vs_grid.csv", index=False)
print("=> 写入 ml_compare_uniform_vs_grid.csv")
