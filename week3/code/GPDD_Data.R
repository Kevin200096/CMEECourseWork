#!/usr/bin/env Rscript
# Author: Kevin Zhao
# Script: GPDD_Data.R
# Description: Visualize GPDD data locations on a world map.
# Outputs: PDF file with mapped GPDD data points.
# Date: Dec 2024

# Set CRAN mirror for package installation
options(repos = c(CRAN = "https://cran.r-project.org"))

# Load required library
if (!requireNamespace("maps", quietly = TRUE)) {
  install.packages("maps") # Install maps package if not already installed
}
library(maps) # Load maps library for geographical visualization

# Load GPDD data
load("../data/GPDDFiltered.RData") # Load filtered GPDD dataset

# Inspect GPDD data structure
cat("Loaded GPDD data:\n")
str(gpdd) # Display structure of the GPDD data

# Filter valid records (remove rows with missing coordinates)
gpdd_clean <- gpdd[!is.na(gpdd$lat) & !is.na(gpdd$long), ]
cat("Number of valid records with coordinates:", nrow(gpdd_clean), "\n") # Output number of valid records

# Create a world map with GPDD points overlay
pdf("../results/GPDD_Map.pdf", width = 10, height = 6) # Set output to PDF

map("world", fill = TRUE, col = "lightgray", bg = "white", mar = c(0, 0, 0, 0)) # Draw world map
if (nrow(gpdd_clean) > 0) {
  points(gpdd_clean$long, gpdd_clean$lat, col = "red", pch = 16, cex = 0.7) # Overlay data points
} else {
  cat("No valid points to plot on the map.\n") # Notify if no valid points
}
title("Global Population Dynamics Database (GPDD) Locations") # Add a title to the map

dev.off() # Close the PDF device

# Add comments for bias analysis
# -----------------------------------------------------------------------------
# Biases:
# - Data may be geographically biased, with higher density in regions like North America and Europe.
# - Underrepresentation of certain ecosystems such as tropical rainforests, deserts, and polar areas.
# - Potential taxonomic bias due to overrepresentation of some species groups.
# - These biases could skew biodiversity analyses and reduce generalizability.
# -----------------------------------------------------------------------------

cat("Script GPDD_Data.R completed successfully. Map saved in ../results/GPDD_Map.pdf.\n") # Final success message
