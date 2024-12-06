#!/usr/bin/env Rscript
# Author: Kevin Zhao
# Script: PP_Dists.R
# Description: Analyze predator-prey body mass distributions by feeding interaction type.
# Outputs: Three PDF files and a CSV file with statistical results.
# Date: Dec 2024

# Load required library
if (!requireNamespace("tidyverse", quietly = TRUE)) {
  install.packages("tidyverse")  # Install tidyverse if not available
}
library(tidyverse)

# Load dataset
data <- read.csv("../data/EcolArchives-E089-51-D1.csv")

# Ensure feeding interactions are treated as factors
data$Type.of.feeding.interaction <- as.factor(data$Type.of.feeding.interaction)

# Add ratio column for size ratio of prey mass to predator mass
data <- data %>%
  mutate(ratio = Prey.mass / Predator.mass)

# Helper function for creating histograms
create_histogram <- function(data_list, xlab_text, output_file, main_title) {
  # Opens a PDF file to save the plots
  pdf(output_file)
  # Set the layout for multiple plots in a single PDF
  par(mfrow = c(3, 2))
  # Loop through the data list to create individual histograms
  for (i in 1:length(data_list)) {
    hist(
      data_list[[i]], 
      xlab = xlab_text,  # Label for the X-axis
      main = names(data_list)[i],  # Title for each plot
      col = "skyblue",  # Fill color for bars
      border = "black"  # Color for the bar borders
    )
  }
  graphics.off()  # Close the PDF file
}

# 1. Predator mass distribution
# Group predator mass by feeding interaction type and take the log10
predator_data <- tapply(log10(data$Predator.mass), data$Type.of.feeding.interaction, c)
# Create histograms for predator mass distribution
create_histogram(predator_data, "Log10(Predator Mass)", "../results/Pred_Subplots.pdf", "Predator Mass Distribution")

# 2. Prey mass distribution
# Group prey mass by feeding interaction type and take the log10
prey_data <- tapply(log10(data$Prey.mass), data$Type.of.feeding.interaction, c)
# Create histograms for prey mass distribution
create_histogram(prey_data, "Log10(Prey Mass)", "../results/Prey_Subplots.pdf", "Prey Mass Distribution")

# 3. Size ratio distribution
# Group size ratio by feeding interaction type and take the log10
ratio_data <- tapply(log10(data$ratio), data$Type.of.feeding.interaction, c)
# Create histograms for size ratio distribution
create_histogram(ratio_data, "Log10(Size Ratio)", "../results/SizeRatio_Subplots.pdf", "Size Ratio Distribution")

# Calculate statistical summaries
# Summarize mean and median for log-transformed predator mass, prey mass, and size ratio
PP_Results <- data %>%
  group_by(Type.of.feeding.interaction) %>%
  summarise(
    MeanLogPredMass = mean(log10(Predator.mass), na.rm = TRUE),  # Mean log10 predator mass
    MedianLogPredMass = median(log10(Predator.mass), na.rm = TRUE),  # Median log10 predator mass
    MeanLogPreyMass = mean(log10(Prey.mass), na.rm = TRUE),  # Mean log10 prey mass
    MedianLogPreyMass = median(log10(Prey.mass), na.rm = TRUE),  # Median log10 prey mass
    MeanLogSizeRatio = mean(log10(ratio), na.rm = TRUE),  # Mean log10 size ratio
    MedianLogSizeRatio = median(log10(ratio), na.rm = TRUE)  # Median log10 size ratio
  )

# Save statistical summaries to a CSV file
write.csv(PP_Results, "../results/PP_Results.csv", row.names = FALSE)

# Inform user about successful completion
cat("Script PP_Dists.R has completed successfully. Results saved in ../results/.\n")
