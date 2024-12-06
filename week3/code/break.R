# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: break.R
# Description: Demonstrates the use of a while loop and break statement in R.
# Arguments: None
# Date: Dec 2024

# Initialize a counter variable
i <- 0

# Start a while loop that runs indefinitely (while condition is TRUE)
while (i < Inf) {
    # Check if the counter has reached 10
    if (i == 10) {
        break  # Exit the loop if i equals 10
    } else {
        # Print the current value of i
        cat("i equals", i, "\n")
        i <- i + 1  # Increment i by 1
    }
}

# End of script
