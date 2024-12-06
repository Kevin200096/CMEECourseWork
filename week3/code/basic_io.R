# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: basic_io.R
# Description: Demonstrates basic input-output operations in R using a simple dataset.
# Inputs: "../data/trees.csv" (input dataset)
# Outputs: "../results/MyData.csv" (output dataset)
# Date: Dec 2024

############# Input: Read Data ###############
# Load the dataset with headers
MyData <- read.csv("../data/trees.csv", header = TRUE)  # Import with headers

############# Output: Write Data ###############
# Write the entire dataset to a CSV file
write.csv(MyData, "../results/MyData.csv", row.names = FALSE)  # Write without row names

# Append the first row of the dataset to the existing file
write.table(MyData[1, ], file = "../results/MyData.csv", append = TRUE, sep = ",", col.names = FALSE, row.names = FALSE)

# Write the entire dataset again with row names
write.csv(MyData, "../results/MyData.csv", row.names = TRUE)  # Overwrites previous file

# Write the entire dataset without column names
write.table(MyData, "../results/MyData.csv", sep = ",", col.names = FALSE, row.names = FALSE)
