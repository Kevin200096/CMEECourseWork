#!/usr/bin/env Rscript
## vcf2stats_3epoch.R — Read sigle VCF，output single CSV：
##   rep, Ne1, Ne2, Ne3, bin1..bin30

args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1L) stop("usage: Rscript vcf2stats_3epoch.R <VCF>")

vcf  <- args[1]
so   <- file.path(getwd(), "r2_bin.so")
rinc <- file.path(getwd(), "read_vcf_recode.R")

stopifnot(file.exists(so), file.exists(rinc))
cat("MD5 r2_bin.so:", tools::md5sum(so), "\n")

dyn.load(so)
source(rinc)

## ---- Read VCF & Setting ----
dat  <- read_vcf(vcf, maf_cutoff = 0.05)
pos  <- as.integer(dat$pos)
geno <- dat$geno; storage.mode(geno) <- "integer"

## ---- c‑bin：0.005–0.305（equal width-30 bins）----
r_bp   <- 1e-8
edge_c <- seq(0.005, 0.305, by = 0.01)     # 31 edge
c_lb   <- head(edge_c, -1)
c_ub   <- tail(edge_c, -1)

## ---- Call C：In c bin scale with pair ----
out <- .Call("cal_r2_bins",
             geno, pos,
             c_lb, c_ub,
             r_bp,
             NULL)
mean_r2 <- out[[1]]
stopifnot(length(mean_r2) == 30L)

## ---- Analysis via names rep / Three Ne ----
rep_id <- as.integer(sub(".*_rep([0-9]+)\\.vcf$", "\\1", vcf))
Ne1    <- as.integer(sub(".*Ne1([0-9]+).*", "\\1", vcf))
Ne2    <- as.integer(sub(".*Ne2([0-9]+).*", "\\1", vcf))
Ne3    <- as.integer(sub(".*Ne3([0-9]+).*", "\\1", vcf))

## ---- Write CSV：Single-line 34 rows ----
row <- c(rep_id, Ne1, Ne2, Ne3, mean_r2)
outf <- sub("\\.vcf$", ".csv", vcf)
write.table(t(row), file = outf, sep = ",", row.names = FALSE, col.names = FALSE)
cat("✓", vcf, "→", outf, "\n")
