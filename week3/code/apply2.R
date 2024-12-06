# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: apply2.R
# Description: Demonstrates the use of apply() with a custom function to perform operations on matrix rows.
# Arguments: None
# Date: Dec 2024

############# Define a Custom Function ###############
# This function performs an operation based on the sum of the input vector:
# - If the sum of the vector is greater than 0, multiply each element by 100.
# - Otherwise, return the original vector.
SomeOperation <- function(v) {
    if (sum(v) > 0) {  # Check if the sum of the vector is positive
        return(v * 100)  # Multiply all elements by 100
    } else {
        return(v)  # Return the original vector
    }
}

############# Generate a Random Matrix ###############
# Create a 10x10 matrix with random normal values
M <- matrix(rnorm(100), 10, 10)  # 100 random numbers reshaped into 10 rows and 10 columns

############# Apply Function Row-wise ###############
# Use apply() to apply the custom function to each row of the matrix
# apply(M, 1, SomeOperation):
# - M: The matrix
# - 1: MARGIN = 1 specifies row-wise operation
# - SomeOperation: The custom function to apply
result <- apply(M, 1, SomeOperation)

############# Print the Result ###############
# Display the modified matrix
cat("Result of applying SomeOperation to each row of the matrix:\n")
print(result)

# End of script
