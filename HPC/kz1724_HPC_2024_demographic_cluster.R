#!/usr/bin/env Rscript
# kz1724_HPC_2024_demographic_cluster.R
# HPC array job script for the stochastic demographic model (Questions 3 and 4).

#####################################
# 1) Housekeeping
#####################################
rm(list=ls())
graphics.off()

#####################################
# 2) Load required R files
#####################################
# kz1724_HPC_2024_main.R contains the custom initialization functions (e.g. state_initialise_adult/spread):
source("kz1724_HPC_2024_main.R")

# Demographic.R contains the official deterministic/stochastic functions:
# Keep this if main file does NOT fully include those functions
source("Demographic.R")

#####################################
# 3) Read array index from environment
#####################################
iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))
# If testing locally
# if(is.na(iter)) iter <- 1

#####################################
# 4) Unique seed
#####################################
set.seed(iter)

#####################################
# 5) Model matrices and parameters
#####################################
growth_matrix <- matrix(c(0.1, 0.0, 0.0, 0.0,
                          0.5, 0.4, 0.0, 0.0,
                          0.0, 0.4, 0.7, 0.0,
                          0.0, 0.0, 0.25, 0.4),
                        nrow=4, ncol=4, byrow=TRUE)

reproduction_matrix <- matrix(c(0.0, 0.0, 0.0, 2.6,
                                0.0, 0.0, 0.0, 0.0,
                                0.0, 0.0, 0.0, 0.0,
                                0.0, 0.0, 0.0, 0.0),
                              nrow=4, ncol=4, byrow=TRUE)

clutch_distribution <- c(0.06,0.08,0.13,0.15,0.16,0.18,0.15,0.06,0.03)

simulation_length <- 120
num_reps         <- 150

#####################################
# 6) Choose initial state based on iter
#####################################
init_condition <- ""
if (iter <= 25) {
  initial_state <- state_initialise_adult(4, 100)
  init_condition <- "large_adult"
} else if (iter <= 50) {
  initial_state <- state_initialise_adult(4, 10)
  init_condition <- "small_adult"
} else if (iter <= 75) {
  initial_state <- state_initialise_spread(4, 100)
  init_condition <- "large_spread"
} else {
  initial_state <- state_initialise_spread(4, 10)
  init_condition <- "small_spread"
}

#####################################
# 7) Preallocate results list
#####################################
results <- vector("list", num_reps)

#####################################
# 8) Run simulations
#####################################
for (i in seq_len(num_reps)) {
  run_output <- stochastic_simulation(
    initial_state,
    growth_matrix,
    reproduction_matrix,
    clutch_distribution,
    simulation_length
  )
  results[[i]] <- run_output
}

#####################################
# 9) Save output
#####################################
out_file <- paste0("demographic_cluster_output_", iter, ".rda")
save(results, init_condition, file = out_file)

cat("Demographic job", iter, "done. Condition:", init_condition, "File:", out_file, "\n")
