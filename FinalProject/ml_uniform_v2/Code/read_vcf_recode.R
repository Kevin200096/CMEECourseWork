read_vcf <- function(vcf_file, maf_cutoff = 0.05)
{
  txt  <- readLines(vcf_file)
  hdr  <- txt[grepl("^#CHROM", txt)]
  coln <- strsplit(hdr, "\t")[[1]]
  body <- txt[!grepl("^#", txt)]

  df <- read.table(text = body, sep = "\t",
                   col.names = coln, stringsAsFactors = FALSE,
                   check.names = FALSE)

  pos <- as.integer(df$POS)

  gt_chr <- sub(":.*", "", as.matrix(df[ , 10:ncol(df)]))

  recode_vec <- function(v) {
    res <- integer(length(v))
    res[v == "0|0"] <- 0L
    res[v == "1|1"] <- 2L
    res[v == "0|1" | v == "1|0"] <- 1L
    res[!(v %in% c("0|0","1|1","0|1","1|0"))] <- NA_integer_
    res
  }

  geno <- t(apply(gt_chr, 2, recode_vec))   # row = indiv
  storage.mode(geno) <- "integer"

  p <- colSums(geno, na.rm = TRUE) / (2 * nrow(geno))
  keep <- p >= maf_cutoff & p <= 1 - maf_cutoff

  list(pos  = pos[keep],
       geno = geno[ , keep, drop = FALSE])
}
