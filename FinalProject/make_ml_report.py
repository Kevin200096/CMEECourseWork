#!/usr/bin/env python3
# make_ml_report.py — 汇总 ML 结果 + 数据一致性检查 +（可选）Grid 的按 Ne 曲线 + 简易 HTML
#
# 用法：
#   python make_ml_report.py --dataset dataset_uniform.csv --pred_dir ml_uniform --name uniform
#   python make_ml_report.py --dataset dataset_grid.csv    --pred_dir ml_grid    --name grid --is_grid
#
# 产出（写到 pred_dir 下）：
#   - report_summary.txt         核心指标与数据完整性摘要（纯文本）
#   - dataset_summary.csv        每个 bin 的 NA/均值/标准差
#   - report.html                简易 HTML（指标表 + 自动收集到的图）
#   - (若 --is_grid) ld_by_ne.png   Strategy-1：每个 Ne 的 r² 曲线对比

import argparse, json
from pathlib import Path
import numpy as np
import pandas as pd

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

def summarize_dataset(df: pd.DataFrame):
    assert "Ne" in df.columns and "rep" in df.columns, "需要包含 Ne 与 rep 两列"
    bin_cols = [c for c in df.columns if c.startswith("bin")]
    assert len(bin_cols) == 30, f"应有 30 个 bin，实际 {len(bin_cols)}"
    na_per_col = df[bin_cols].isna().sum()
    all_na_bins = [c for c in bin_cols if na_per_col[c] == len(df)]
    stats = pd.DataFrame({
        "NA_count": na_per_col,
        "mean": df[bin_cols].mean(skipna=True),
        "std":  df[bin_cols].std(skipna=True)
    })
    return bin_cols, all_na_bins, stats

def load_metrics(pred_dir: Path):
    p = pred_dir / "metrics.json"
    if not p.exists(): return {}
    with open(p) as f: return json.load(f)

def plot_ld_by_ne_for_grid(df: pd.DataFrame, out_png: Path):
    bin_cols = [c for c in df.columns if c.startswith("bin")]
    nes = sorted(df["Ne"].unique())
    plt.figure(figsize=(8,5))
    x = np.arange(1, len(bin_cols)+1)
    for ne in nes:
        y = df.loc[df["Ne"] == ne, bin_cols].mean(axis=0, skipna=True).values
        plt.plot(x, y, marker='o', linewidth=1, label=f"Ne={int(ne)}")
    plt.xlabel("c-bins (1..30)"); plt.ylabel("mean r²"); plt.title("LD decay by Ne (grid)")
    plt.legend(ncol=2, fontsize=8); plt.tight_layout(); plt.savefig(out_png, dpi=200); plt.close()

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--dataset", required=True, help="dataset_uniform.csv 或 dataset_grid.csv")
    ap.add_argument("--pred_dir", required=True, help="训练脚本输出目录（含 metrics.json 等）")
    ap.add_argument("--name", default="", help="名字标签（可选）")
    ap.add_argument("--is_grid", action="store_true", help="Strategy-1：按 Ne 画多曲线图")
    args = ap.parse_args()

    pred_dir = Path(args.pred_dir); pred_dir.mkdir(parents=True, exist_ok=True)
    df = pd.read_csv(args.dataset)

    # 1) 数据检查与统计
    bin_cols, all_na_bins, stats = summarize_dataset(df)
    stats.to_csv(pred_dir / "dataset_summary.csv")

    # 2) 指标
    metrics = load_metrics(pred_dir)
    rf = metrics.get("RF", {})
    xgb = metrics.get("XGB", {})

    # 3) Grid 的多曲线（可选）
    extra_imgs = []
    if args.is_grid:
        out_png = pred_dir / "ld_by_ne.png"
        try:
            plot_ld_by_ne_for_grid(df, out_png)
            extra_imgs.append(out_png.name)
        except Exception as e:
            extra_imgs.append(f"(ld_by_ne failed: {e})")

    # 4) 收集可能的图（兼容多命名）
    fig_candidates = [
        # RF
        "parity_rf.png","residuals_rf.png",
        "calibration_true_bins_rf.png","calibration_pred_bins_rf.png",
        "feature_importance_rf.png","roc_rf.png",
        "shap_beeswarm_rf.png","shap_bar_rf.png",
        # XGB
        "parity_xgb.png","residuals_xgb.png",
        "calibration_true_bins_xgb.png","calibration_pred_bins_xgb.png",
        "feature_importance_xgb.png","roc_xgb.png",
        "shap_beeswarm_xgb.png","shap_bar_xgb.png",
    ]
    found_figs = [nm for nm in fig_candidates if (pred_dir / nm).exists()]

    # 5) 文本报告
    with open(pred_dir / "report_summary.txt", "w") as f:
        f.write(f"[Report] {args.name}\n")
        f.write(f"Dataset: {args.dataset}\n")
        f.write(f"Rows: {len(df)}   Bins: {len(bin_cols)}   Unique Ne: {df['Ne'].nunique()}\n")
        f.write(f"All-NA bins: {', '.join(all_na_bins) if all_na_bins else '(none)'}\n")
        f.write("\n[RF]\n")
        if rf: 
            for k,v in rf.items():
                if not isinstance(v,(dict,list)): f.write(f"  {k}: {v}\n")
        else:
            f.write("  (metrics not found)\n")
        f.write("\n[XGB]\n")
        if xgb:
            for k,v in xgb.items():
                if not isinstance(v,(dict,list)): f.write(f"  {k}: {v}\n")
        else:
            f.write("  (metrics not found / XGB unavailable)\n")
        f.write("\n[Figures found]\n")
        for nm in found_figs + [str(p) for p in extra_imgs]:
            f.write(f"  {nm}\n")

    # 6) 简易 HTML（老师浏览友好）
    rows = []
    for model, d in [("RF", rf), ("XGB", xgb)]:
        if not d: continue
        rows.append({
            "Model": model,
            "R2": d.get("R2"),
            "RMSE_log10": d.get("RMSE_log10"),
            "MAE_log10": d.get("MAE_log10"),
            "Spearman": d.get("Spearman"),
            "R2_cv_mean": d.get("R2_cv_mean"),
            "R2_cv_std": d.get("R2_cv_std"),
            "RMSE_log10_cv_mean": d.get("RMSE_log10_cv_mean"),
            "RMSE_log10_cv_std": d.get("RMSE_log10_cv_std"),
            "MAE_log10_cv_mean": d.get("MAE_log10_cv_mean"),
            "MAE_log10_cv_std": d.get("MAE_log10_cv_std"),
            "RMSE_multiplier": d.get("RMSE_multiplier"),
            "AUC": d.get("AUC"),
            "roc_threshold": d.get("roc_threshold"),
            "has_shap": d.get("has_shap"),
        })
    mdf = pd.DataFrame(rows)

    html = [
        "<!DOCTYPE html><html><head><meta charset='utf-8'><title>ML Report</title>",
        "<style>body{font-family:Arial;margin:20px;max-width:1200px} img{max-width:560px;margin:6px;border:1px solid #ddd}</style>",
        "</head><body>",
        f"<h1>ML Report — {args.name}</h1>",
        f"<p>Dataset: <code>{args.dataset}</code> | Rows: {len(df)} | Unique Ne: {df['Ne'].nunique()}</p>",
        "<h2>Metrics</h2>", mdf.to_html(index=False, float_format=lambda x: f"{x:.4f}" if isinstance(x,float) else x),
        "<h2>Figures</h2>"
    ]
    for nm in found_figs + [p for p in extra_imgs if isinstance(p,str)]:
        html += [f"<div><img src='{nm}' alt='{nm}'><br><small>{nm}</small></div>"]
    html += ["</body></html>"]
    (pred_dir/"report.html").write_text("\n".join(html), encoding="utf-8")

    print(f"✓ 写入 {pred_dir/'report_summary.txt'}、{pred_dir/'dataset_summary.csv'}、{pred_dir/'report.html'}")
    if args.is_grid:
        print(f"✓ 生成按 Ne 的多曲线图：{pred_dir/'ld_by_ne.png'}")

if __name__ == "__main__":
    main()
