#!/usr/bin/env python3
# train_ne_regression.py  —  回归 Ne（含 SHAP、CV、校准、ROC、版本记录）
# 用法：
#   python train_ne_regression.py --csv dataset_uniform.csv --outdir ml_uniform --seed 202 --cv 5 --with-shap --roc-threshold 100000
#   python train_ne_regression.py --csv dataset_grid.csv    --outdir ml_grid     --seed 202 --cv 5 --with-shap

import os, sys, json, random, warnings, argparse, platform
from pathlib import Path
import numpy as np
import pandas as pd

import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

from sklearn.model_selection import train_test_split, StratifiedKFold
from sklearn.preprocessing import StandardScaler
from sklearn.metrics import r2_score, mean_squared_error, mean_absolute_error, roc_auc_score, roc_curve
from scipy.stats import spearmanr
from sklearn.ensemble import RandomForestRegressor

# xgboost / shap 可选
HAS_XGB, HAS_SHAP = True, True
try:
    from xgboost import XGBRegressor
except Exception:
    HAS_XGB = False
try:
    import shap
except Exception:
    HAS_SHAP = False

import joblib
import sklearn

def rmse(y_true, y_pred): return float(np.sqrt(mean_squared_error(y_true, y_pred)))
def mae(y_true, y_pred):  return float(mean_absolute_error(y_true, y_pred))

def set_global_seed(seed: int):
    os.environ["PYTHONHASHSEED"] = str(seed)
    random.seed(seed); np.random.seed(seed)

def parity_plot(y_true, y_pred, outpng, title):
    plt.figure(figsize=(6,6))
    plt.scatter(y_true, y_pred, s=12, alpha=0.6)
    lo, hi = min(y_true.min(), y_pred.min()), max(y_true.max(), y_pred.max())
    pad = 0.03*(hi-lo)
    lims = [lo-pad, hi+pad]
    plt.plot(lims, lims, "k--", lw=1)
    plt.xlabel("True log10(Ne)"); plt.ylabel("Pred log10(Ne)")
    plt.title(title); plt.xlim(lims); plt.ylim(lims); plt.tight_layout()
    plt.savefig(outpng, dpi=180); plt.close()

def residual_plot(y_true, y_pred, outpng, title):
    res = y_pred - y_true
    plt.figure(figsize=(7,4))
    plt.axhline(0, color="k", lw=1, ls="--")
    plt.scatter(y_true, res, s=12, alpha=0.6)
    plt.xlabel("True log10(Ne)"); plt.ylabel("Residual (pred - true)")
    plt.title(title); plt.tight_layout(); plt.savefig(outpng, dpi=180); plt.close()

def barplot_importance(imp, names, outpng, title, topk=30):
    order = np.argsort(imp)[::-1][:topk]
    plt.figure(figsize=(6,5))
    plt.bar(range(len(order)), np.array(imp)[order])
    plt.xticks(range(len(order)), np.array(names)[order], rotation=90)
    plt.ylabel("importance"); plt.title(title)
    plt.tight_layout(); plt.savefig(outpng, dpi=180); plt.close()

def calibration_by_quantile(y_true, y_pred, n_bins=10, by="pred"):
    if by not in ("pred","true"): raise ValueError("by must be 'pred' or 'true'")
    base = y_pred if by=="pred" else y_true
    qs = np.quantile(base, q=np.linspace(0,1,n_bins+1))
    idx = np.digitize(base, qs[1:-1], right=True)
    xs, ys = [], []
    for b in range(n_bins):
        m_pred = np.mean(y_pred[idx==b]) if np.any(idx==b) else np.nan
        m_true = np.mean(y_true[idx==b]) if np.any(idx==b) else np.nan
        xs.append(m_pred); ys.append(m_true)
    return np.array(xs), np.array(ys)

def calibration_plot(y_true, y_pred, outpng, n_bins=10, by="pred", title="Calibration"):
    xs, ys = calibration_by_quantile(y_true, y_pred, n_bins=n_bins, by=by)
    plt.figure(figsize=(5,5))
    lims = [np.nanmin([xs,ys]), np.nanmax([xs,ys])]
    pad = 0.03*(lims[1]-lims[0]); lims = [lims[0]-pad, lims[1]+pad]
    plt.plot(lims, lims, "k--", lw=1, label="ideal")
    plt.scatter(xs, ys, s=40)
    plt.xlabel("bin mean of predicted log10(Ne)" if by=="pred" else "bin mean of true log10(Ne)")
    plt.ylabel("bin mean of true log10(Ne)")
    plt.title(title); plt.xlim(lims); plt.ylim(lims); plt.tight_layout()
    plt.savefig(outpng, dpi=180); plt.close()

def cv_scores(model_ctor, X, y, strat, n_splits=5, seed=42):
    skf = StratifiedKFold(n_splits=n_splits, shuffle=True, random_state=seed)
    r2_list, rmse_list, mae_list = [], [], []
    scaler = StandardScaler()
    for tr_idx, va_idx in skf.split(X, strat):
        Xtr, Xva = X[tr_idx], X[va_idx]
        ytr, yva = y[tr_idx], y[va_idx]
        Xtr = scaler.fit_transform(Xtr)
        Xva = scaler.transform(Xva)
        mdl = model_ctor()
        mdl.fit(Xtr, ytr)
        pred = mdl.predict(Xva)
        r2_list.append(r2_score(yva, pred))
        rmse_list.append(rmse(yva, pred))
        mae_list.append(mae(yva, pred))
    return {
        "R2_cv_mean": float(np.mean(r2_list)),
        "R2_cv_std": float(np.std(r2_list, ddof=1)),
        "RMSE_log10_cv_mean": float(np.mean(rmse_list)),
        "RMSE_log10_cv_std": float(np.std(rmse_list, ddof=1)),
        "MAE_log10_cv_mean": float(np.mean(mae_list)),
        "MAE_log10_cv_std": float(np.std(mae_list, ddof=1)),
    }

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--csv", required=True, help="dataset_uniform.csv 或 dataset_grid.csv")
    ap.add_argument("--outdir", required=True, help="输出目录（新建或覆盖）")
    ap.add_argument("--seed", type=int, default=202)
    ap.add_argument("--cv", type=int, default=5, help="CV 折数")
    ap.add_argument("--model", choices=["both","rf","xgb"], default="both")
    ap.add_argument("--with-shap", action="store_true", help="若安装 shap，则计算并保存 SHAP 图")
    ap.add_argument("--topk-importance", type=int, default=30)
    ap.add_argument("--roc-threshold", type=float, default=-1,
                   help="阈值（单位 Ne，>0 时计算 ROC/AUC 图）")
    ap.add_argument("--calib-bins", type=int, default=10)
    args = ap.parse_args()

    set_global_seed(args.seed)

    outdir = Path(args.outdir); outdir.mkdir(parents=True, exist_ok=True)

    # 1) 读数据与列检查
    df = pd.read_csv(args.csv)
    assert "Ne" in df.columns, "dataset 缺少 Ne 列"
    bin_cols = [c for c in df.columns if c.startswith("bin")]
    assert len(bin_cols) == 30, f"Expect 30 bins, got {len(bin_cols)}"

    # 目标：log10(Ne)
    y = np.log10(df["Ne"].astype(float).values)
    ne_true = df["Ne"].astype(float).values
    X = df[bin_cols].copy()

    # 列层面缺失：>30% 的 bin 列剔除
    na_ratio = X.isna().mean()
    keep_cols = [c for c in bin_cols if na_ratio[c] <= 0.30]
    drop_cols = [c for c in bin_cols if c not in keep_cols]
    if drop_cols:
        print(f"[info] drop columns (>30% NA): {drop_cols}")
        X = X[keep_cols]

    # 行层面缺失：用列中位数补齐
    X = X.fillna(X.median())

    # 2) stratified 划分（按 y 分位做“桶”）
    qs = np.quantile(y, q=np.linspace(0,1,11))
    strat = np.digitize(y, qs[1:-1], right=True)
    X_tr, X_te, y_tr, y_te, ne_tr, ne_te = train_test_split(
        X.values, y, ne_true, test_size=0.2, random_state=args.seed, stratify=strat
    )

    # 标准化（对树不敏感，对 XGB/NN 有益）——统一保存
    scaler = StandardScaler()
    X_trs = scaler.fit_transform(X_tr)
    X_tes = scaler.transform(X_te)

    # 先保存 scaler & used_bins（无论训练哪个模型）
    joblib.dump(scaler, outdir/"scaler.pkl")
    with open(outdir/"used_bins.json","w") as f: json.dump(keep_cols, f, indent=2)

    results = {
        "dataset": args.csv,
        "used_bins": keep_cols,
        "dropped_bins": drop_cols
    }

    # 3) RF
    y_pred_rf = None
    if args.model in ["both","rf"]:
        rf = RandomForestRegressor(
            n_estimators=700, max_depth=None, min_samples_leaf=2,
            random_state=args.seed, n_jobs=-1
        )
        rf.fit(X_trs, y_tr)
        yhat = rf.predict(X_tes); y_pred_rf = yhat

        res = {
            "R2": r2_score(y_te, yhat),
            "RMSE_log10": rmse(y_te, yhat),
            "MAE_log10": mae(y_te, yhat),
            "Spearman": float(spearmanr(y_te, yhat).statistic),
            "has_shap": False
        }
        # CV
        res.update(cv_scores(
            lambda: RandomForestRegressor(n_estimators=700, max_depth=None, min_samples_leaf=2,
                                          random_state=args.seed, n_jobs=-1),
            X.values, y, strat, n_splits=args.cv, seed=args.seed
        ))
        res["RMSE_multiplier"] = float(10 ** res["RMSE_log10"])
        results["RF"] = res

        # 预测与图
        pd.DataFrame({"Ne_true": ne_te, "y_true_log10": y_te, "y_pred_rf": yhat}).to_csv(outdir/"pred_test_rf.csv", index=False)
        parity_plot(y_te, yhat, outdir/"parity_rf.png", "RF: parity plot")
        residual_plot(y_te, yhat, outdir/"residuals_rf.png", "RF: residuals")
        calibration_plot(y_te, yhat, outdir/"calibration_true_bins_rf.png", n_bins=args.calib_bins, by="true",
                         title="RF: calibration (by true quantiles)")
        calibration_plot(y_te, yhat, outdir/"calibration_pred_bins_rf.png", n_bins=args.calib_bins, by="pred",
                         title="RF: calibration (by pred quantiles)")

        # 重要性
        try:
            imp = rf.feature_importances_
            pd.DataFrame({"feature": keep_cols, "importance": imp}).to_csv(outdir/"feature_importance_rf.csv", index=False)
            barplot_importance(imp, keep_cols, outdir/"feature_importance_rf.png", "RF feature importance", topk=args.topk_importance)
        except Exception as e:
            print("[warn] RF importance failed:", e)

        # ROC（回归分数当概率，阈值在 Ne 标度）
        if args.roc_threshold and args.roc_threshold > 0:
            thr_log = np.log10(args.roc_threshold)
            y_cls = (y_te > thr_log).astype(int)
            auc = roc_auc_score(y_cls, yhat)
            fpr, tpr, _ = roc_curve(y_cls, yhat)
            plt.figure(figsize=(5,5))
            plt.plot(fpr, tpr, label=f"AUC={auc:.3f}")
            plt.plot([0,1],[0,1],"k--", lw=1)
            plt.xlabel("FPR"); plt.ylabel("TPR"); plt.title(f"RF ROC (threshold Ne={int(args.roc_threshold)})")
            plt.legend(); plt.tight_layout(); plt.savefig(outdir/"roc_rf.png", dpi=180); plt.close()
            results["RF"]["AUC"] = float(auc)
            results["RF"]["roc_threshold"] = float(args.roc_threshold)

        # SHAP（可选）
        if args.with_shap and HAS_SHAP:
            try:
                expl = shap.TreeExplainer(rf)
                sv = expl.shap_values(X_tes)
                # 保存图
                plt.figure(); shap.summary_plot(sv, X_tes, feature_names=keep_cols, show=False)
                plt.tight_layout(); plt.savefig(outdir/"shap_beeswarm_rf.png", dpi=180); plt.close()
                plt.figure(); shap.summary_plot(sv, X_tes, plot_type="bar", feature_names=keep_cols, show=False)
                plt.tight_layout(); plt.savefig(outdir/"shap_bar_rf.png", dpi=180); plt.close()
                results["RF"]["has_shap"] = True
            except Exception as e:
                print("[warn] RF SHAP failed:", e)

        # 保存模型
        joblib.dump(rf, outdir/"rf.pkl")

    # 4) XGB
    y_pred_xgb = None
    if args.model in ["both","xgb"] and HAS_XGB:
        xgb = XGBRegressor(
            n_estimators=1200, max_depth=6, learning_rate=0.03,
            subsample=0.9, colsample_bytree=0.8, reg_lambda=1.0,
            random_state=args.seed, n_jobs=0, tree_method="hist"
        )
        xgb.fit(X_trs, y_tr)
        yhat = xgb.predict(X_tes); y_pred_xgb = yhat

        res = {
            "R2": r2_score(y_te, yhat),
            "RMSE_log10": rmse(y_te, yhat),
            "MAE_log10": mae(y_te, yhat),
            "Spearman": float(spearmanr(y_te, yhat).statistic),
            "has_shap": False
        }
        # CV
        res.update(cv_scores(
            lambda: XGBRegressor(n_estimators=1200, max_depth=6, learning_rate=0.03,
                                 subsample=0.9, colsample_bytree=0.8, reg_lambda=1.0,
                                 random_state=args.seed, n_jobs=0, tree_method="hist"),
            X.values, y, strat, n_splits=args.cv, seed=args.seed
        ))
        res["RMSE_multiplier"] = float(10 ** res["RMSE_log10"])
        results["XGB"] = res

        # 预测与图
        pd.DataFrame({"Ne_true": ne_te, "y_true_log10": y_te, "y_pred_xgb": yhat}).to_csv(outdir/"pred_test_xgb.csv", index=False)
        parity_plot(y_te, yhat, outdir/"parity_xgb.png", "XGB: parity plot")
        residual_plot(y_te, yhat, outdir/"residuals_xgb.png", "XGB: residuals")
        calibration_plot(y_te, yhat, outdir/"calibration_true_bins_xgb.png", n_bins=args.calib_bins, by="true",
                         title="XGB: calibration (by true quantiles)")
        calibration_plot(y_te, yhat, outdir/"calibration_pred_bins_xgb.png", n_bins=args.calib_bins, by="pred",
                         title="XGB: calibration (by pred quantiles)")

        # 重要性
        try:
            imp = xgb.feature_importances_
            pd.DataFrame({"feature": keep_cols, "importance": imp}).to_csv(outdir/"feature_importance_xgb.csv", index=False)
            barplot_importance(imp, keep_cols, outdir/"feature_importance_xgb.png", "XGB feature importance", topk=args.topk_importance)
        except Exception as e:
            print("[warn] XGB importance failed:", e)

        # ROC
        if args.roc_threshold and args.roc_threshold > 0:
            thr_log = np.log10(args.roc_threshold)
            y_cls = (y_te > thr_log).astype(int)
            auc = roc_auc_score(y_cls, yhat)
            fpr, tpr, _ = roc_curve(y_cls, yhat)
            plt.figure(figsize=(5,5))
            plt.plot(fpr, tpr, label=f"AUC={auc:.3f}")
            plt.plot([0,1],[0,1],"k--", lw=1)
            plt.xlabel("FPR"); plt.ylabel("TPR"); plt.title(f"XGB ROC (threshold Ne={int(args.roc_threshold)})")
            plt.legend(); plt.tight_layout(); plt.savefig(outdir/"roc_xgb.png", dpi=180); plt.close()
            results["XGB"]["AUC"] = float(auc)
            results["XGB"]["roc_threshold"] = float(args.roc_threshold)

        # SHAP
        if args.with_shap and HAS_SHAP:
            try:
                expl = shap.TreeExplainer(xgb)
                sv = expl.shap_values(X_tes)
                plt.figure(); shap.summary_plot(sv, X_tes, feature_names=keep_cols, show=False)
                plt.tight_layout(); plt.savefig(outdir/"shap_beeswarm_xgb.png", dpi=180); plt.close()
                plt.figure(); shap.summary_plot(sv, X_tes, plot_type="bar", feature_names=keep_cols, show=False)
                plt.tight_layout(); plt.savefig(outdir/"shap_bar_xgb.png", dpi=180); plt.close()
                results["XGB"]["has_shap"] = True
            except Exception as e:
                print("[warn] XGB SHAP failed:", e)

        # 保存模型
        joblib.dump(xgb, outdir/"xgb.pkl")

    # 5) 合并预测导出（统一格式）
    pred_df = pd.DataFrame({"Ne_true": ne_te, "y_true_log10": y_te})
    if y_pred_rf  is not None: pred_df["y_pred_rf"]  = y_pred_rf
    if y_pred_xgb is not None: pred_df["y_pred_xgb"] = y_pred_xgb
    pred_df.to_csv(outdir/"pred_test.csv", index=False)

    # 6) 保存指标
    with open(outdir/"metrics.json", "w") as f:
        json.dump(results, f, indent=2)

    # 7) 运行配置与版本信息
    info = {
        "csv": args.csv,
        "outdir": str(outdir),
        "seed": args.seed,
        "cv": args.cv,
        "model": args.model,
        "with_shap": bool(args.with_shap and HAS_SHAP),
        "roc_threshold": args.roc_threshold,
        "calib_bins": args.calib_bins,
        "python": sys.version.replace("\n"," "),
        "platform": platform.platform(),
        "numpy": np.__version__,
        "pandas": pd.__version__,
        "sklearn": sklearn.__version__,
        "xgboost": (None if not HAS_XGB else __import__("xgboost").__version__),
        "shap": (None if not HAS_SHAP else __import__("shap").__version__),
    }
    with open(outdir/"run_config.json", "w") as f:
        json.dump(info, f, indent=2)

    print(json.dumps(results, indent=2))
    print(f"[done] outputs written to: {outdir}")

if __name__ == "__main__":
    warnings.filterwarnings("ignore", category=UserWarning)
    main()
