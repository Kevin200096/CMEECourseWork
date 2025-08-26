#!/usr/bin/env Rscript
## ---------------------------------------------------------------
##  run_ld.R —— 读取 VCF → Burrows r² → c-bin 曲线 (0.01–0.30)
##              逐对计算 c, 支持位置依赖重组率
## ---------------------------------------------------------------
cat("MD5:", tools::md5sum("r2_bin.so"), "\n")
dyn.load("r2_bin.so")
source("read_vcf_recode.R")

## ---- 读取 VCF & 过滤 ----
dat  <- read_vcf("ana_sim.vcf", maf_cutoff = 0.05)
pos  <- as.integer(dat$pos)
geno <- dat$geno; storage.mode(geno) <- "integer"
cat("num SNP :", ncol(geno), "\n")
cat("num indiv:", nrow(geno), "\n")

## ---- 重组率设置 ----
r_bp  <- 1e-8                  # 常数 r (per bp)
r_vec <- NULL                  # 若有 per‑locus r, 设为 numeric 向量

## ---- c-bin 定义：30 个等宽 bins (midpoints 0.01–0.30) ----
edge_c <- seq(0.005, 0.305, by = 0.01)  # 31 边界, 30 bins
c_lb   <- head(edge_c, -1)              # lower  bounds
c_ub   <- tail(edge_c, -1)              # upper  bounds
c_mid  <- (c_lb + c_ub) / 2             # bin 中点, 用于绘图

## ---- 计算 r² ----
out <- .Call("cal_r2_bins",
             geno, pos,
             c_lb, c_ub,
             r_bp,
             if (is.null(r_vec)) NULL else r_vec)

mean_r2 <- out[[1]]
cnt     <- out[[2]]
cat("cnt >0 bins:", sum(cnt > 0), "/", length(cnt), "\n")

## ---- 过滤与 log 轴 0 处理 ----
valid  <- (cnt > 0) & is.finite(mean_r2)
stopifnot(sum(valid) > 0L)
r2_plot <- mean_r2[valid];   r2_plot[r2_plot == 0] <- 1e-6

## ---- 输出 ----
write.csv(data.frame(c_lower = c_lb[valid],
                     c_upper = c_ub[valid],
                     c_mid   = c_mid[valid],
                     r2      = mean_r2[valid],
                     pairs   = cnt[valid]),
          "ld_curve_c.csv", row.names = FALSE)

png("ld_curve.png", 800, 600)
plot(c_mid[valid], r2_plot,
     log = "y", type = "b", pch = 1,
     xlab = "Recombination fraction (c)",
     ylab = "Mean Burrows’ r²",
     main = "LD decay (30 equal‑c bins)")
dev.off()
cat("✔  ld_curve.png & ld_curve_c.csv generated\n")
