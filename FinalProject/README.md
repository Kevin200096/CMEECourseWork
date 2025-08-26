# LD-based Ne inference with msprime simulations + Machine Learning

Use linkage disequilibrium (LD) decay summaries (Burrows’ r² binned on the c scale) to infer effective population size (Ne).  
We provide two constant-Ne settings—Strategy-1 (grid) and Strategy-2 (uniform)—and a three-epoch Ne variant.  
Ready-to-run scripts reproduce the ML results from the provided datasets.

---

## Table of Contents
- [What’s in this repo](#whats-in-this-repo)
- [Background](#background)
- [Datasets](#datasets)
- [Environment](#environment)
- [Quick start](#quick-start)
- [How to run (by scenario)](#how-to-run-by-scenario)
- [Outputs](#outputs)
- [Data provenance & pipeline sketch](#data-provenance--pipeline-sketch)
- [Reproducibility notes](#reproducibility-notes)
- [Troubleshooting](#troubleshooting)
- [Acknowledgements & citations](#acknowledgements--citations)
- [License](#license)

---

## What’s in this repo

```
FinalProject/
├── Initial Sample/                  # 单文件演示：VCF→LD曲线（本地）
│   ├── ana_sim.vcf
│   ├── ld_curve.png
│   ├── ld_curve_c.csv
│   ├── run_ld.R
│   └── simulate_to_vcf.py
│
├── Quality Check/                   # 质检与对比小脚本
│   ├── compare_strategies.py
│   ├── inspect_dataset.py
│   └── quick_check.R
│
├── ml_grid_v2/                      # Strategy-1（离散10档Ne）的ML结果
│   ├── Code/
│   ├── Results/
│   ├── dataset_grid.csv
│   ├── make_ml_report.py
│   └── train_ne_regression.py
│
├── ml_threeepoch_rf_xgb/            # Three-epoch Ne 的ML结果
│   ├── Code/
│   ├── Results/
│   ├── dataset_threeepoch.csv
│   └── train_ne_threeepoch.py
│
├── ml_uniform_v2/                   # Strategy-2（连续Uniform Ne）的ML结果
│   ├── Code/
│   ├── Results/
│   ├── dataset_uniform.csv
│   ├── make_ml_report.py
│   └── train_ne_regression.py
│
├── dataset_grid.csv
├── dataset_threeepoch.csv
├── dataset_uniform.csv
├── make_ml_report.py
├── train_ne_regression.py
└── train_ne_threeepoch.py
```

---

## Background

We simulate diploid populations with **msprime**, compute Burrows’ *r²* (Hill 1981), and bin LD on the *c* scale (0.005–0.305, 30 bins).  
Each sample yields a 30-D r² vector and one or three effective population sizes (labels).  
We apply **Random Forest (RF)** and **XGBoost (XGB)** regression on log₁₀(Ne), with **SHAP** for interpretability.

---

## Datasets

- **dataset_uniform.csv** — Ne ~ Uniform(5e2, 5e5)  
- **dataset_grid.csv** — 10 fixed Ne grid values  
- **dataset_threeepoch.csv** — three epochs (Ne1, Ne2, Ne3)  

---

## Environment

- Python ≥ 3.10  
- Recommended: conda/virtualenv  

Install dependencies:
```bash
pip install numpy pandas scikit-learn xgboost shap matplotlib joblib
```

R scripts in `Initial Sample` and `Quality Check` are optional (demo/QC only).

---

## Quick start

```bash
# Example: Strategy-2 (Uniform)
python train_ne_regression.py --csv dataset_uniform.csv --outdir ml_uniform \
       --seed 202 --cv 5 --with-shap --roc-threshold 100000

python make_ml_report.py --dataset dataset_uniform.csv \
       --pred_dir ml_uniform --name "Uniform Ne"
```

---

## How to run (by scenario)

### Strategy-2: continuous Ne ~ Uniform
```bash
python train_ne_regression.py --csv dataset_uniform.csv \
       --outdir ml_uniform --seed 202 --cv 5 --with-shap
```

### Strategy-1: 10 fixed Ne grid
```bash
python train_ne_regression.py --csv dataset_grid.csv \
       --outdir ml_grid --seed 202 --cv 5 --with-shap
```

### Three-epoch Ne (Ne1, Ne2, Ne3)
```bash
python train_ne_threeepoch.py --csv dataset_threeepoch.csv \
       --outdir ml_threeepoch --seed 202 --cv 5 --with-shap
```

---

## Outputs

- `metrics.json` / `metrics_3epoch.json`  
- Prediction CSVs  
- Plots: parity, residuals, SHAP, feature_importance  
- `report.html`

---

## Data provenance & pipeline sketch

- r²: Burrows’ r² (unphased), binned on c-scale (0.005–0.305).  
- Features: 30 bin averages.  
- Labels: Ne / (Ne1,Ne2,Ne3).  
- Baseline: 52 Mb, r=1e-8/bp, μ=1e-9/bp, 50 diploids.  

---

## Reproducibility notes

- Fixed seeds, results stable at metric level.  
- Scripts save `scaler.pkl` and `used_bins.json`.  

---

## Troubleshooting

- SHAP warnings: ignorable.  
- Missing bins: rare, low SNP density.  
- XGB not installed: `pip install xgboost`.  

---

## Acknowledgements & citations

- **msprime, tskit**  
- **scikit-learn, XGBoost, SHAP, NumPy, Pandas, Matplotlib**  
- Burrows’ r² (Hill 1981), Haldane mapping function  

If used in publications:  
> “c-scale binning (0.005–0.305, 30 bins), Burrows’ r² as LD summary, RF/XGB regression on log₁₀(Ne), SHAP for interpretability.”

---

## License

MIT License.
