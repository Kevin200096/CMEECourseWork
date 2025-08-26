#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
if (length(args) < 1) stop("usage: Rscript vcf2stats.R <vcf>")

vcf <- args[1]

dyn.load(file.path(getwd(), "r2_bin.so"))
source(file.path(getwd(), "read_vcf_recode.R"))

## ---- read VCF ----
dat  <- read_vcf(vcf, maf_cutoff = 0.05)
pos  <- as.integer(dat$pos)
geno <- dat$geno; storage.mode(geno) <- "integer"

## ---- c‑bin 0.005–0.305（30 bins）----
r_bp   <- 1e-8
edge_c <- seq(0.005, 0.305, by = 0.01)   # 31 edges and 30 bins
c_lb   <- edge_c[-length(edge_c)]
c_ub   <- edge_c[-1]

## ---- Calculate r²（C layer on c-scale bining）----
out <- .Call("cal_r2_bins",
             geno, pos,
             c_lb, c_ub,
             r_bp,
             NULL)

mean_r2 <- out[[1]]
stopifnot(length(mean_r2) == 30)

## ---- Calls from document meta（rep, Ne）----
rep_id <- as.integer(sub(".*_rep([0-9]+)\\.vcf$", "\\1", vcf))
Ne_val <- as.integer(sub("sim_Ne([0-9]+)_rep.*", "\\1", vcf))

## ---- Write CSV：as 1×32（rep, Ne, 30bin）----
out_csv <- sub("\\.vcf$", ".csv", vcf)
write.table(cbind(rep_id, Ne_val, t(mean_r2)),
            file = out_csv, sep = ",",
            row.names = FALSE, col.names = FALSE, quote = FALSE)

cat("✓", vcf, "→", out_csv, "\n")
