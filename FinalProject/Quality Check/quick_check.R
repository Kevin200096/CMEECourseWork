#!/usr/bin/env Rscript
dyn.load("r2_bin.so")
source("read_vcf_recode.R")

dat  <- read_vcf("ana_sim.vcf", maf_cutoff = 0.05)
pos  <- as.integer(dat$pos)
geno <- dat$geno; storage.mode(geno) <- "integer"
s <- nrow(geno); l <- ncol(geno)

r_bp     <- 1e-8
c_edges  <- seq(0.01, 0.30, length.out = 31)
bp_edge  <- as.integer(-0.5/r_bp * log(1 - 2*c_edges))
lb <- bp_edge[-length(bp_edge)]
ub <- bp_edge[-1]

# 统计每 bin 对数
cnt <- integer(length(lb))
for(i in 1:(l-1))
  for(j in (i+1):l){
    d <- pos[j]-pos[i]
    k <- findInterval(d, lb)
    if(k>=1 && k<=length(lb) && d < ub[k]) cnt[k] <- cnt[k]+1
  }
print(cnt)

# 分母符号检查
sourceCpp <- FALSE  # 若想再查分母，设 TRUE 并复用旧代码
