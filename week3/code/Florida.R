#!/usr/bin/env Rscript
# Author: Kevin Zhao
# Script: Florida.R
# Description: Analyze temperature data in Key West, Florida, to determine trends over time using Spearman's rank correlation and randomization.
# Outputs: Histogram plot and summary statistics.
# Date: Dec 2024

# Load required package
require(tidyverse)

# Clear environment
rm(list = ls())  # Remove all objects from the current environment to avoid conflicts

# Load the dataset
load("../data/KeyWestAnnualMeanTemperature.RData")  # Load temperature data

# Inspect dataset
cat("Loaded dataset:\n")
ls()  # List loaded objects in the environment
head(ats)  # Display the first few rows of the dataset
# Scatter plot to visualize temperature trends over time
plot(ats, main = "Key West Annual Mean Temperature (1901-2000)",
     xlab = "Year", ylab = "Temperature (°C)", pch = 19, col = "blue")

##############################################
# Function: Generate randomized correlations
# Input: repeats -> Number of randomizations
# Output: A vector of Spearman's rho values for each randomization
Sample_Random <- function(repeats) {
    correlations <- numeric(repeats)  # Preallocate vector for correlations

    # Loop to generate randomized correlations
    for (i in 1:repeats) {
        shuffled_temp <- sample(ats$Temp, length(ats$Temp), replace = TRUE) 
        # Randomize temperature data
        spearman_res <- cor.test(ats$Year, shuffled_temp, method = "spearman")
        # Calculate Spearman's rank correlation
        correlations[i] <- as.numeric(spearman_res$estimate)  # Store the rho value
    }

    return(correlations)  # Return all generated correlations
}

# Calculate actual correlation
actual_cor <- cor.test(ats$Year, ats$Temp, method = "spearman")
cat("Observed Spearman's rho:", actual_cor$estimate, "\n")  # Print the actual rho value

# Generate random correlations
set.seed(123)  # For reproducibility of results
Random_corrs <- Sample_Random(10000)  # Generate 10,000 random correlations

# Convert results to a data frame for visualization
Random_corrs_df <- data.frame(Random_corrs = Random_corrs)

# Calculate confidence intervals
percentile_2.5 <- quantile(Random_corrs_df$Random_corrs, 0.025)  # 2.5th percentile
percentile_97.5 <- quantile(Random_corrs_df$Random_corrs, 0.975)  # 97.5th percentile
cat("95% Confidence Interval:", percentile_2.5, "-", percentile_97.5, "\n")  # Print confidence intervals

# Plot histogram of randomized correlations
histogram_plot <- ggplot(Random_corrs_df, aes(x = Random_corrs)) + 
  geom_histogram(colour = "black", fill = "#f58742", bins = 50) +  # Add histogram
  geom_vline(xintercept = percentile_2.5, color = "blue", size = 1, linetype = "dashed") +  # 2.5th percentile
  geom_vline(xintercept = percentile_97.5, color = "blue", size = 1, linetype = "dashed") +  # 97.5th percentile
  geom_vline(xintercept = as.numeric(actual_cor$estimate), color = "red", size = 1.5) +  # Observed rho
  xlab("Correlation estimate (rho)") +
  ylab("Frequency") +
  ggtitle("Randomized Spearman's Correlation Distribution") +
  theme_classic()  # Classic theme for better readability

# Save histogram plot as a PNG file
ggsave("../results/Florida_Histogram.png", plot = histogram_plot, width = 8, height = 6)

# Count how many random correlations exceed the actual correlation
num_above_actual <- sum(Random_corrs > as.numeric(actual_cor$estimate))  # Calculate how many exceed observed rho
cat("Number of random correlations greater than observed rho:", num_above_actual, "\n")  # Print the count
