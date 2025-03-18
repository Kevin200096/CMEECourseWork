#!/usr/bin/env Rscript
# kz1724_HPC_2024_neutral_cluster.R
# HPC array job script for the individual-based neutral model with speciation.

#####################################
# 1) Housekeeping
#####################################
rm(list=ls())
graphics.off()

#####################################
# 2) Load required files
#####################################
# This should contain 'neutral_cluster_run()' or neutral model functions.
source("kz1724_HPC_2024_main.R")

#####################################
# 3) Read array index from environment
#####################################
iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))
# For local testing (uncomment next line if needed):
# if (is.na(iter)) iter <- 1

#####################################
# 4) Unique random seed
#####################################
set.seed(iter)

#####################################
# 5) Decide community size based on iter
#####################################
# We split 1..100 into four blocks of 25:
#   1..25   => size=500
#   26..50  => size=1000
#   51..75  => size=2500
#   76..100 => size=5000

size <- 0
if (iter <= 25) {
  size <- 500
} else if (iter <= 50) {
  size <- 1000
} else if (iter <= 75) {
  size <- 2500
} else {
  size <- 5000
}

#####################################
# 6) Prepare output file name
#####################################
# We'll store results in current directory, e.g. "neutral_cluster_output_1.rda"
output_file_name <- paste0("neutral_cluster_output_", iter, ".rda")

#####################################
# 7) Set other parameters for your run
#####################################
# You can adjust speciation_rate, wall_time, intervals, etc.
speciation_rate <- 0.004247
wall_time <- 690               # e.g. 11.5 hours -> 690 minutes
interval_rich <- 1            # record richness every generation
interval_oct  <- size / 10     # record octaves every size/10 steps
burn_in_generations <- 8 * size

#####################################
# 8) Call the main function
#####################################
# This function must be defined in kz1724_HPC_2024_main.R or elsewhere.
neutral_cluster_run(
  speciation_rate     = speciation_rate,
  size                = size,
  wall_time           = wall_time,
  interval_rich       = interval_rich,
  interval_oct        = interval_oct,
  burn_in_generations = burn_in_generations,
  output_file_name    = output_file_name
)

cat("Neutral cluster job", iter, "done. Community size =", size,
    "Output file:", output_file_name, "\n")
