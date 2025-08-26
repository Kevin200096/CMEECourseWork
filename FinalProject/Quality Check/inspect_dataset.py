#!/usr/bin/env python3
# inspect_dataset.py
import argparse, pandas as pd

ap = argparse.ArgumentParser()
ap.add_argument("--csv", required=True)
args = ap.parse_args()

df = pd.read_csv(args.csv)
print(f"[info] shape: {df.shape}")
print("[info] columns:", list(df.columns))

# 识别 bin 列
bin_cols = [c for c in df.columns if str(c).startswith("bin")]
print(f"[info] #bins detected: {len(bin_cols)} -> {bin_cols[:6]}{' ...' if len(bin_cols)>6 else ''}")

# NA 概览
na_rat = df[bin_cols].isna().mean().sort_index()
print("[info] NA ratio per bin (前10列):")
print(na_rat.head(10))

# 全 NA 列
all_na = na_rat[na_rat == 1.0].index.tolist()
if all_na:
    print("[warn] 全 NA 的 bin 列：", all_na)

# Ne、rep 检查
assert "Ne" in df.columns, "缺少 Ne 列"
assert "rep" in df.columns, "缺少 rep 列"
print("[ok] 基本列齐全")
