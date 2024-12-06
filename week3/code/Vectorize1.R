# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: Vectorize1.R
# Description: Demonstrates the performance difference between using loops and a vectorized function for summing matrix elements.
# Arguments: None
# Date: Dec 2024

############# Generate a Large Random Matrix ###############
# Create a 1000x1000 matrix with random uniform values between 0 and 1
M <- matrix(runif(1000000), 1000, 1000)

############# Define the Loop-based Function ###############
# This function sums all elements of the matrix using nested loops
SumAllElements <- function(M) {
    Dimensions <- dim(M)  # Get the dimensions of the matrix
    Tot <- 0  # Initialize the sum variable
    # Loop through each row
    for (i in 1:Dimensions[1]) {
        # Loop through each column
        for (j in 1:Dimensions[2]) {
            Tot <- Tot + M[i,j]  # Add the element to the total sum
        }
    }
    return(Tot)  # Return the total sum
}

############# Performance Comparison ###############

# Measure the time taken to sum the elements using loops
print("Using loops, the time taken is:")
print(system.time(SumAllElements(M)))  # Time taken by the loop-based approach

# Measure the time taken to sum the elements using the built-in vectorized function
print("Using the in-built vectorized function, the time taken is:")
print(system.time(sum(M)))  # Time taken by the vectorized sum function
