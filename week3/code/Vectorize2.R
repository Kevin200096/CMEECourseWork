#!/usr/bin/env Rscript
# Runs the stochastic Ricker equation with gaussian fluctuations

rm(list = ls())  # Clear the global environment to avoid conflicts

# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: Vectorize2.R
# Description: Implements a stochastic Ricker model and compares loop-based and vectorized performance.
# Date: Dec 2024

############# Stochastic Ricker Model (Loop-Based) ###############
# This function calculates the population dynamics using loops
# Arguments:
#   p0: Initial population sizes (vector)
#   r: Growth rate
#   K: Carrying capacity
#   sigma: Standard deviation of random fluctuations
#   numyears: Number of simulation years
stochrick <- function(p0 = runif(1000, 0.5, 1.5), r = 1.2, K = 1, sigma = 0.2, numyears = 100) {
    N <- matrix(NA, numyears, length(p0))  # Initialize a matrix to store population sizes
    N[1, ] <- p0  # Set the first row as initial population sizes

    # Iterate over each population and each year
    for (pop in 1:length(p0)) {  # Loop through populations
        for (yr in 2:numyears) {  # Loop through years
            # Calculate the next year's population using the Ricker model with a random fluctuation
            N[yr, pop] <- N[yr - 1, pop] * exp(r * (1 - N[yr - 1, pop] / K) + rnorm(1, 0, sigma))
        }
    }
    return(N)  # Return the population matrix
}

############# Vectorized Stochastic Ricker Model ###############
# This function calculates the population dynamics using vectorized operations
# Arguments:
#   p0: Initial population sizes (vector)
#   r: Growth rate
#   K: Carrying capacity
#   sigma: Standard deviation of random fluctuations
#   numyears: Number of simulation years
stochrickvect <- function(p0 = runif(1000, 0.5, 1.5), r = 1.2, K = 1, sigma = 0.2, numyears = 100) {
    N <- matrix(NA, numyears, length(p0))  # Initialize a matrix to store population sizes
    N[1, ] <- p0  # Set the first row as initial population sizes

    # Pre-generate random fluctuations for all populations and years
    Random.Nums <- matrix(rnorm((numyears - 1) * length(p0), 0, sigma), nrow = numyears - 1, ncol = length(p0))

    # Iterate over years (vectorized for all populations)
    for (yr in 2:numyears) {
        # Calculate the next year's population for all populations simultaneously
        N[yr, ] <- N[yr - 1, ] * exp(r * (1 - N[yr - 1, ] / K) + Random.Nums[yr - 1, ])
    }
    return(N)  # Return the population matrix
}

############# Performance Comparison ###############
cat("Normal Stochastic Ricker takes:\n")
# Measure execution time for the loop-based model
print(system.time({
    set.seed(123)  # Ensure reproducibility for loop-based method
    res1 <- stochrick()
}))

cat("Vectorized Stochastic Ricker takes:\n")
# Measure execution time for the vectorized model
print(system.time({
    set.seed(123)  # Ensure reproducibility for vectorized method
    res2 <- stochrickvect()
}))

############# Results Verification ###############
# Verify that the results of the two methods are consistent
if (all.equal(res1, res2, tolerance = 1e-8)) {
    cat("The results of both methods are consistent.\n")
} else {
    cat("The results differ! Check the implementation.\n")
}
