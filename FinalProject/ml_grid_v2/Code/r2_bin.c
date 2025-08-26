/*  r2_bin.c —— Burrows r² (unphased) with c‑binning
 *  Build:  R CMD SHLIB r2_bin.c -fopenmp
 *
 *  Interface:
 *    .Call("cal_r2_bins",
 *          genotype,          // integer matrix (indiv × loci)
 *          POS,               // integer vector (bp positions)
 *          c_lb, c_ub,        // double vectors, len = bins
 *          r_bp,              // double scalar (per‑bp r)
 *          r_vec = NULL)      // optional double vector (loci‑specific r)
 *
 *  若 r_vec != NULL && length == loci，则按局部 r 计算；
 *  否则使用常数 r_bp。
 */

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <omp.h>
#include <R.h>
#include <Rinternals.h>

/* ---------- Burrows r² ---------- */
static double burrows(const int *x, const int *y, int s)
{
    long delta = 0, pA = 0, pB = 0, hA = 0, hB = 0;
    for (int i = 0; i < s; i++) {
        delta += x[i] * y[i];
        pA    += x[i];
        pB    += y[i];
        hA    += (x[i] == 1);
        hB    += (y[i] == 1);
    }
    double dpA = (double)pA / (2 * s), dpB = (double)pB / (2 * s);
    double dhA = (double)hA /  s,       dhB = (double)hB /  s;
    double D   = (double)delta / (2 * s) - 2 * dpA * dpB;
    D *= (double)s / (s - 1);                     /* bias correction */

    double varA = dpA * (1.0 - dpA) + dhA / 2.0;
    double varB = dpB * (1.0 - dpB) + dhB / 2.0;
    if (varA <= 0 || varB <= 0) return NAN;

    double r2 = (D * D) / (varA * varB);          /* ≤ s/(s-1) */
    return r2 / ((double)s / (s - 1));            /* scale to 0–1 */
}

/* ---------- .Call 接口 ---------- */
SEXP cal_r2_bins(SEXP GENO, SEXP POS, SEXP CLB, SEXP CUB,
                 SEXP RBP,  SEXP RVEC)
{
    /* 基本维度 */
    int loci = INTEGER(getAttrib(GENO, R_DimSymbol))[1];
    int s    = INTEGER(getAttrib(GENO, R_DimSymbol))[0];
    int bins = LENGTH(CLB);

    /* 输出向量 */
    SEXP R2 = PROTECT(allocVector(REALSXP, bins));
    SEXP N  = PROTECT(allocVector(REALSXP, bins));
    for (int i = 0; i < bins; i++) { REAL(R2)[i] = 0; REAL(N)[i] = 0; }

    /* 指针 */
    const int    *g      = INTEGER(GENO);
    const int    *pos    = INTEGER(POS);
    const double *c_lb   = REAL(CLB);
    const double *c_ub   = REAL(CUB);
    double       *sum    = REAL(R2);
    double       *cnt    = REAL(N);

    /* 重组率 */
    double r_const           = asReal(RBP);
    const double *rvec       = (RVEC == R_NilValue) ? NULL : REAL(RVEC);
    int has_vec              = (rvec != NULL && LENGTH(RVEC) == loci);

    #pragma omp parallel for schedule(dynamic)
    for (int i = 0; i < loci - 1; i++) {
        for (int j = i + 1; j < loci; j++) {

            /* 物理距离 */
            int dist = abs(pos[j] - pos[i]);
            if (dist == 0) continue;

            /* r_local: 常数或局部平均 */
            double r_local = has_vec ? 0.5 * (rvec[i] + rvec[j]) : r_const;

            /* 计算 c */
            double c_ij = 0.5 * (1.0 - exp(-2.0 * r_local * dist));
            if (c_ij < c_lb[0]) continue;        /* 太小，无需入 bin */

            /* 找 bin */
            int k = 0;
            while (k < bins && c_ij >= c_lb[k]) k++;
            if (k == 0 || k > bins) continue;
            if (c_ij >= c_ub[k - 1]) continue;

            /* Burrows r² */
            double r2 = burrows(&g[i * s], &g[j * s], s);
            if (isnan(r2)) continue;

            #pragma omp atomic
            sum[k - 1] += r2;
            #pragma omp atomic
            cnt[k - 1] += 1.0;
        }
    }

    /* 取均值 */
    for (int i = 0; i < bins; i++)
        sum[i] = cnt[i] ? sum[i] / cnt[i] : NA_REAL;

    /* 返回 list(mean_r2, count) */
    SEXP OUT = PROTECT(allocVector(VECSXP, 2));
    SET_VECTOR_ELT(OUT, 0, R2);
    SET_VECTOR_ELT(OUT, 1, N);
    UNPROTECT(3);
    return OUT;
}
