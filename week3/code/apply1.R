# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: apply1.R
# Description: Demonstrates the use of the apply() function to calculate row and column statistics for a matrix.
# Arguments: None
# Date: Dec 2024

############# Generate a Random Matrix ###############
# Create a 10x10 matrix with random normal values
M <- matrix(rnorm(100), 10, 10)  # 100 random numbers reshaped into 10 rows and 10 columns

############# Row-wise Calculations ###############
# Calculate the mean of each row
# apply(M, 1, mean):
# - M: The matrix
# - 1: MARGIN = 1 specifies row-wise operation
# - mean: The function to apply
RowMeans <- apply(M, 1, mean)
cat("Row means:\n")
print(RowMeans)

# Calculate the variance of each row
# apply(M, 1, var):
# - M: The matrix
# - 1: MARGIN = 1 specifies row-wise operation
# - var: The function to apply
RowVars <- apply(M, 1, var)
cat("Row variances:\n")
print(RowVars)

############# Column-wise Calculations ###############
# Calculate the mean of each column
# apply(M, 2, mean):
# - MARGIN = 2 specifies column-wise operation
ColMeans <- apply(M, 2, mean)
cat("Column means:\n")
print(ColMeans)

# End of script
