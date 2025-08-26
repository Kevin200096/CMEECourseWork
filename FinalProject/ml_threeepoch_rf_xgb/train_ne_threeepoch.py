#!/usr/bin/env python3
# train_ne_threeepoch.py — 多目标回归 Ne1/Ne2/Ne3（含 SHAP、CV、图表）
import argparse, json, warnings, os, random
from pathlib import Path
import numpy as np, pandas as pd

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

from sklearn.model_selection import train_test_split, StratifiedKFold
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import r2_score, mean_squared_error, mean_absolute_error
from sklearn.ensemble import RandomForestRegressor
from scipy.stats import spearmanr

HAS_XGB = True
try:
    from xgboost import XGBRegressor
except Exception:
    HAS_XGB = False

HAS_SHAP = True
try:
    import shap
except Exception:
    HAS_SHAP = False

def rmse(a,b): return float(np.sqrt(mean_squared_error(a,b)))
def mae(a,b):  return float(mean_absolute_error(a,b))

def parity(y_true, y_pred, outpng, title):
    plt.figure(figsize=(6,6))
    plt.scatter(y_true, y_pred, s=10, alpha=0.6)
    lo, hi = min(y_true.min(), y_pred.min()), max(y_true.max(), y_pred.max())
    plt.plot([lo,hi], [lo,hi], "k--", lw=1)
    plt.xlabel("true log10 Ne"); plt.ylabel("pred log10 Ne"); plt.title(title)
    plt.tight_layout(); plt.savefig(outpng, dpi=160); plt.close()

def residual(y_true, y_pred, outpng, title):
    res = y_pred - y_true
    plt.figure(figsize=(7,4))
    plt.axhline(0, color="k", lw=1, ls="--")
    plt.scatter(y_true, res, s=10, alpha=0.6)
    plt.xlabel("true log10 Ne"); plt.ylabel("residual")
    plt.title(title); plt.tight_layout(); plt.savefig(outpng, dpi=160); plt.close()

def bar_importance(imp, names, outpng, title, top=None):
    order = np.argsort(imp)[::-1]
    if top: order = order[:top]
    plt.figure(figsize=(7,4.5))
    plt.bar(np.array(names)[order], np.array(imp)[order])
    plt.xticks(rotation=90); plt.ylabel("importance"); plt.title(title)
    plt.tight_layout(); plt.savefig(outpng, dpi=170); plt.close()

def fit_one(name, Xtr, ytr, Xte, model_kind, seed):
    if model_kind == "rf":
        mdl = RandomForestRegressor(
            n_estimators=700, max_depth=None, min_samples_leaf=2,
            random_state=seed, n_jobs=-1
        )
    elif model_kind == "xgb":
        mdl = XGBRegressor(
            n_estimators=1200, max_depth=6, learning_rate=0.03,
            subsample=0.9, colsample_bytree=0.8, reg_lambda=1.0,
            random_state=seed, n_jobs=0, tree_method="hist"
        )
    else:
        raise ValueError("model_kind must be rf/xgb")
    mdl.fit(Xtr, ytr)
    yhat = mdl.predict(Xte)
    return mdl, yhat

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--csv", required=True, help="dataset_threeepoch.csv")
    ap.add_argument("--outdir", required=True)
    ap.add_argument("--seed", type=int, default=202)
    ap.add_argument("--cv", type=int, default=5)
    ap.add_argument("--model", choices=["both","rf","xgb"], default="both")
    ap.add_argument("--with-shap", action="store_true")
    args = ap.parse_args()

    # 固定随机种子（增强可复现性）
    random.seed(args.seed); np.random.seed(args.seed)

    outdir = Path(args.outdir); outdir.mkdir(parents=True, exist_ok=True)

    # 1) 读数据
    df = pd.read_csv(args.csv)
    for col in ["Ne1","Ne2","Ne3","rep"]: 
        assert col in df.columns
    bin_cols = [c for c in df.columns if c.startswith("bin")]
    assert len(bin_cols) == 30, f"expect 30 bins, got {len(bin_cols)}"

    # 目标：log10 Ne1/2/3（分别回归）
    y1 = np.log10(df["Ne1"].astype(float).values)
    y2 = np.log10(df["Ne2"].astype(float).values)
    y3 = np.log10(df["Ne3"].astype(float).values)
    X  = df[bin_cols].copy()

    # 缺失：列 >30% NA 删除，行用列中位数补
    na_ratio = X.isna().mean()
    keep = [c for c in bin_cols if na_ratio[c] <= 0.30]
    drop = [c for c in bin_cols if c not in keep]
    if drop: print("[info] drop cols due to NA >", ", ".join(drop))
    X = X[keep].fillna(X[keep].median())
    used_bins = keep

    # 分层划分：按平均的 y 分位（让三目标的难度接近）
    y_avg = (y1 + y2 + y3) / 3
    qs = np.quantile(y_avg, q=np.linspace(0,1,11))
    strat = np.digitize(y_avg, qs[1:-1], right=True)
    X_tr, X_te, y1_tr, y1_te, y2_tr, y2_te, y3_tr, y3_te = \
        train_test_split(X.values, y1, y2, y3, test_size=0.2, random_state=args.seed, stratify=strat)

    # 标准化（树模型不敏感，但对稳定性有益；SHAP 用相同输入）
    scaler = StandardScaler()
    X_trs = scaler.fit_transform(X_tr)
    X_tes = scaler.transform(X_te)

    results = {"dataset": args.csv, "used_bins": used_bins, "dropped_bins": drop}

    def eval_target(tag, model_kind, ytr, yte):
        mdl, yhat = fit_one(tag, X_trs, ytr, X_tes, model_kind, args.seed)
        res = {
            "R2": r2_score(yte, yhat),
            "RMSE_log10": rmse(yte, yhat),
            "MAE_log10": mae(yte, yhat),
            "Spearman": float(spearmanr(yte, yhat).statistic)
        }
        # CV（分层K折）
        skf = StratifiedKFold(n_splits=args.cv, shuffle=True, random_state=args.seed)
        tmp = []
        for tr_idx, va_idx in skf.split(X.values, strat):
            Xtr, Xva = X.values[tr_idx], X.values[va_idx]
            ytr_cv, yva_cv = ((y1, y1), (y2, y2), (y3, y3))[("Ne1","Ne2","Ne3").index(tag)]
            ytr_cv, yva_cv = ytr_cv[tr_idx], yva_cv[va_idx]
            Xtr = scaler.fit_transform(Xtr); Xva = scaler.transform(Xva)
            mdl_cv, _ = fit_one(tag, Xtr, ytr_cv, Xva, model_kind, args.seed)
            pred = mdl_cv.predict(Xva)
            tmp.append((r2_score(yva_cv, pred), rmse(yva_cv, pred), mae(yva_cv, pred)))
        r2m, rmsm, maem = np.mean([t[0] for t in tmp]), np.mean([t[1] for t in tmp]), np.mean([t[2] for t in tmp])
        r2s, rmss, maes = np.std([t[0] for t in tmp], ddof=1), np.std([t[1] for t in tmp], ddof=1), np.std([t[2] for t in tmp], ddof=1)
        res.update({"R2_cv_mean":float(r2m),"R2_cv_std":float(r2s),
                    "RMSE_log10_cv_mean":float(rmsm),"RMSE_log10_cv_std":float(rmss),
                    "MAE_log10_cv_mean":float(maem),"MAE_log10_cv_std":float(maes),
                    "RMSE_multiplier": float(10 ** res["RMSE_log10"])})
        # 保存预测与图
        pd.DataFrame({"y_true_log10": yte, "y_pred": yhat}).to_csv(outdir/f"pred_{model_kind}_{tag}.csv", index=False)
        parity(yte, yhat, outdir/f"parity_{model_kind}_{tag}.png", f"{model_kind.upper()} parity {tag}")
        residual(yte, yhat, outdir/f"residuals_{model_kind}_{tag}.png", f"{model_kind.upper()} residuals {tag}")
        # 重要性
        try:
            imp = mdl.feature_importances_
            pd.DataFrame({"feature": used_bins, "importance": imp}).to_csv(outdir/f"feature_importance_{model_kind}_{tag}.csv", index=False)
            bar_importance(imp, used_bins, outdir/f"feature_importance_{model_kind}_{tag}.png", f"{model_kind.upper()} importance {tag}", top=30)
        except Exception as e:
            print(f"[warn] importance failed ({model_kind}/{tag}):", e)
        # SHAP（可选）
        has_shap = False
        if HAS_SHAP and args.with_shap:
            try:
                expl = shap.TreeExplainer(mdl)
                sv = expl.shap_values(X_tes)
                pd.DataFrame(np.array(sv), columns=used_bins).to_csv(outdir/f"shap_values_{model_kind}_{tag}.csv", index=False)
                plt.figure(); shap.summary_plot(sv, X_tes, feature_names=used_bins, show=False)
                plt.tight_layout(); plt.savefig(outdir/f"shap_beeswarm_{model_kind}_{tag}.png", dpi=170); plt.close()
                plt.figure(); shap.summary_plot(sv, X_tes, plot_type="bar", feature_names=used_bins, show=False)
                plt.tight_layout(); plt.savefig(outdir/f"shap_bar_{model_kind}_{tag}.png", dpi=170); plt.close()
                has_shap = True
            except Exception as e:
                print(f"[warn] SHAP failed ({model_kind}/{tag}):", e)
        res["has_shap"] = has_shap
        return mdl, res

    # 训练（RF / XGB）
    all_metrics = {}
    for mk in (["rf","xgb"] if args.model=="both" else [args.model]):
        if mk == "xgb" and not HAS_XGB:
            print("[warn] xgboost not available; skip XGB."); continue
        m1, r1 = eval_target("Ne1", mk, y1_tr, y1_te)
        m2, r2 = eval_target("Ne2", mk, y2_tr, y2_te)
        m3, r3 = eval_target("Ne3", mk, y3_tr, y3_te)
        all_metrics[mk.upper()] = {"Ne1":r1, "Ne2":r2, "Ne3":r3,
                                   "AVG":{"R2":np.mean([r1["R2"],r2["R2"],r3["R2"]]),
                                          "RMSE_log10":np.mean([r1["RMSE_log10"],r2["RMSE_log10"],r3["RMSE_log10"]]),
                                          "MAE_log10":np.mean([r1["MAE_log10"],r2["MAE_log10"],r3["MAE_log10"]])}}
    results.update(all_metrics)

    # 保存配置与指标
    with open(outdir/"metrics.json","w") as f: json.dump(results, f, indent=2)
    with open(outdir/"run_config.json","w") as f:
        json.dump({
            "csv": args.csv, "outdir": str(outdir), "seed": args.seed, "cv": args.cv,
            "has_xgb": HAS_XGB, "has_shap": HAS_SHAP, "used_bins": used_bins, "dropped_bins": drop
        }, f, indent=2)

    print(json.dumps(results, indent=2))
    print(f"[done] outputs written to: {outdir}")

if __name__ == "__main__":
    warnings.filterwarnings("ignore", category=UserWarning)
    main()
