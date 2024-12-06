#!/usr/bin/env Rscript
# Author: Kevin Zhao
# Script: PP_Regress.R
# Description: Perform regression analysis on predator-prey data by feeding type and predator lifestage.
# Outputs: Regression plots (PDF) and results (CSV).
# Date: Dec 2024

# Load required libraries
require(tidyverse)
require(scales)

#####################################################
# DATA LOADING AND PROCESSING
# Load the dataset
data <- read.csv("../data/EcolArchives-E089-51-D1.csv")

# Convert relevant columns to factors for categorical grouping
data <- data %>%
  mutate(
    Type.of.feeding.interaction = as.factor(Type.of.feeding.interaction),
    Predator.lifestage = as.factor(Predator.lifestage)
  )

#####################################################
# PLOTTING
# Create a regression plot of log10-transformed prey mass vs predator mass
plot_regression <- ggplot(data, aes(x = log10(Prey.mass), y = log10(Predator.mass))) +
  geom_point(aes(colour = Predator.lifestage), shape = 3) + # Scatter plot with predator lifestage as color
  geom_smooth(aes(colour = Predator.lifestage), method = "lm", fullrange = TRUE, size = 0.5) + # Add regression lines
  facet_grid(Type.of.feeding.interaction ~ .) + # Facet by feeding interaction type
  theme_bw() + # Apply a clean theme
  labs(
    x = "Log10 Prey Mass (g)", # X-axis label
    y = "Log10 Predator Mass (g)", # Y-axis label
    title = "Regression of Predator Mass vs Prey Mass by Feeding Type" # Plot title
  ) +
  theme(
    legend.position = "bottom", # Move legend to the bottom
    legend.title = element_text(face = "bold") # Bold legend title
  ) +
  guides(colour = guide_legend(nrow = 1)) + # Arrange legend in a single row
  coord_fixed(ratio = 0.5) + # Fix aspect ratio for equal scaling
  scale_x_continuous(labels = scientific) + # Scientific notation for X-axis
  scale_y_continuous(labels = scientific)   # Scientific notation for Y-axis

# Save the plot to a PDF file
ggsave("../results/PP_Regress.pdf", plot = plot_regression, width = 8, height = 10)

#####################################################
# REGRESSION ANALYSIS
# Perform linear regression grouped by feeding interaction and predator lifestage
regression_results <- data %>%
  group_by(Type.of.feeding.interaction, Predator.lifestage) %>%
  summarise(
    n = n(),  # Count the number of observations in each group
    Slope = ifelse(n > 2, coef(lm(log10(Predator.mass) ~ log10(Prey.mass)))[2], NA), # Regression slope
    Intercept = ifelse(n > 2, coef(lm(log10(Predator.mass) ~ log10(Prey.mass)))[1], NA), # Regression intercept
    R.squared = ifelse(n > 2, summary(lm(log10(Predator.mass) ~ log10(Prey.mass)))$r.squared, NA), # R-squared value
    F.value = ifelse(n > 2, summary(lm(log10(Predator.mass) ~ log10(Prey.mass)))$fstatistic[1], NA), # F-statistic
    P.value = ifelse(
      n > 2,
      pf(
        summary(lm(log10(Predator.mass) ~ log10(Prey.mass)))$fstatistic[1], # Numerator degrees of freedom
        summary(lm(log10(Predator.mass) ~ log10(Prey.mass)))$fstatistic[2], # Denominator degrees of freedom
        summary(lm(log10(Predator.mass) ~ log10(Prey.mass)))$fstatistic[3], # Total degrees of freedom
        lower.tail = FALSE
      ),
      NA
    ) # P-value
  )

# Save the regression results to a CSV file
write.csv(regression_results, "../results/PP_Regress_Results.csv", row.names = FALSE)
