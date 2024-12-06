# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: Ricker.R
# Description: Simulates the Ricker model for population dynamics and plots the results.
# Arguments: None
# Date: Dec 2024

############# Define the Ricker Model Function ###############
# Ricker: Simulates population dynamics based on the Ricker model.
# Parameters:
# - N0: Initial population size (default = 1)
# - r: Intrinsic growth rate (default = 1)
# - K: Carrying capacity of the environment (default = 10)
# - generations: Number of generations to simulate (default = 50)
Ricker <- function(N0 = 1, r = 1, K = 10, generations = 50) {
  # Create a vector to store population sizes for each generation
  N <- rep(NA, generations)  # Initialize with NA values
  
  # Set the initial population size
  N[1] <- N0
  
  # Iterate over generations to calculate population size
  for (t in 2:generations) {
    # Ricker model equation:
    # N[t] = N[t-1] * exp(r * (1 - (N[t-1] / K)))
    N[t] <- N[t-1] * exp(r * (1.0 - (N[t-1] / K)))
  }
  
  return(N)  # Return the population size vector
}

############# Plot the Ricker Model Output ###############
# Simulate the Ricker model for 10 generations
plot(Ricker(generations = 10), 
     type = "l")  # Use lines to connect the points
