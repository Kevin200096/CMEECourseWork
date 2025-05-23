#!/usr/bin/env Rscript
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: browse.R
# Description: Simulates and visualizes exponential growth using a simple R function.
# Outputs: A plot of exponential growth.
# Date: Oct 2024

Exponential <- function(N0 = 1, r = 1, generations = 10) {
  # Runs a simulation of exponential growth
  # Returns a vector of length generations
  
  N <- rep(NA, generations)    # Creates a vector of NA
  
  N[1] <- N0
  for (t in 2:generations) {
    N[t] <- N[t-1] * exp(r)
    browser()
  }
  return (N)
}

plot(Exponential(), type="l", main="Exponential growth")