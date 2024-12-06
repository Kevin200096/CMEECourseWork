# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: next.R
# Description: Demonstrates the use of the next statement in R to skip specific iterations in a loop.
# Arguments: None
# Date: Dec 2024

# Loop through numbers 1 to 10
for (i in 1:10) {
    # Check if the number is even (divisible by 2)
    if ((i %% 2) == 0) {
        next  # Skip the rest of the loop for this iteration
    }
    # Print the number if it is odd
    print(i)
}

# End of script
