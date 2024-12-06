# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: try.R
# Description: Demonstrates error handling in R using try() and improved version using tryCatch().
# Inputs: A random normal population with 50 elements.
# Outputs: Mean calculation results and error messages.
# Date: Dec 2024

############# Function Definition ###############
# A function to calculate the mean of a sample if it has sufficient unique values
doit <- function(x) {
    # Resample the input with replacement
    temp_x <- sample(x, replace = TRUE)
    
    # Check if the sample has more than 30 unique values
    if(length(unique(temp_x)) > 30) {
        print(paste("Mean of this sample was:", as.character(mean(temp_x))))
    } else {
        stop("Couldn't calculate mean: too few unique values!")  # Stop with an error message
    }
}

############# Generate Population ###############
set.seed(1345)  # Set seed for reproducibility
popn <- rnorm(50)  # Generate a random normal population with 50 elements
hist(popn)  # Visualize the population distribution

############# Error Handling with try() ###############
# Using lapply and try() to handle errors
result <- lapply(1:15, function(i) try(doit(popn), silent = TRUE))  # silent = TRUE suppresses error output

# Check the class and structure of the result
cat("Class of result:", class(result), "\n")
print(result)

############# Improved Error Handling with tryCatch() ###############
# Preallocate a list to store results
result_tryCatch <- vector("list", 15)

# Loop with detailed error handling using tryCatch()
for (i in 1:15) {
    result_tryCatch[[i]] <- tryCatch(
        {
            # Attempt to calculate the mean
            doit(popn)
        },
        error = function(e) {
            # Capture and return the error message
            paste("Error occurred:", e$message)
        }
    )
}

# Print the result with tryCatch()
cat("Results with tryCatch():\n")
print(result_tryCatch)
