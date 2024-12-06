# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: TreeHeight.R
# Description: Calculates tree heights based on distance and angle data, then saves the result.
# Inputs: ../data/trees.csv
# Outputs: ../results/TreeHts.csv
# Date: Dec 2024

############# Define Tree Height Calculation Function ###############
# This function calculates tree heights given distance and angle data
# Arguments:
# - degrees: The angle of elevation of the tree in degrees
# - distance: The distance to the tree base in meters
# Output:
# - height: The calculated tree height in meters
TreeHeight <- function(degrees, distance) {
    radians <- degrees * pi / 180  # Convert degrees to radians
    height <- distance * tan(radians)  # Calculate height using tangent
    return(height)
}

############# Load Data ###############
# Load tree data from CSV
data_file <- "../data/trees.csv"

if (!file.exists(data_file)) {
    stop("Error: Input file '../data/trees.csv' does not exist. Please check the file path.")
}

trees <- read.csv(data_file)

############# Calculate Tree Heights ###############
# Add a new column with calculated tree heights
trees$Tree.Height.m <- TreeHeight(trees$Angle.degrees, trees$Distance.m)

############# Save Results ###############
# Ensure the results directory exists
results_dir <- "../results"
if (!dir.exists(results_dir)) {
    dir.create(results_dir, recursive = TRUE)
}

# Save the updated data to a new CSV file
output_file <- file.path(results_dir, "TreeHts.csv")
write.csv(trees, file = output_file, row.names = FALSE)

############# End of Script ###############
