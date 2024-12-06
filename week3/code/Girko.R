# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: Girko.R
# Description: Generates a Girko circular law plot showing eigenvalues of a random matrix.
# Outputs: A PDF file named "Girko.pdf" in the results directory.
# Date: Dec 2024

# Ensure ggplot2 is installed and loaded
# This block checks if the ggplot2 package is available and installs it if not.
if (!requireNamespace("ggplot2", quietly = TRUE)) {
    install.packages("ggplot2")
}
library(ggplot2)  # Load ggplot2 for data visualization

# Function to build an ellipse
# Inputs:
#   hradius - Horizontal radius of the ellipse
#   vradius - Vertical radius of the ellipse
# Output:
#   A data frame containing x and y coordinates of the ellipse points
build_ellipse <- function(hradius, vradius) {
  npoints <- 250  # Number of points used to approximate the ellipse
  a <- seq(0, 2 * pi, length = npoints + 1)  # Angles from 0 to 2π
  x <- hradius * cos(a)  # x-coordinates
  y <- vradius * sin(a)  # y-coordinates
  return(data.frame(x = x, y = y))  # Return a data frame of points
}

# Define matrix size and compute eigenvalues
N <- 250  # Size of the random matrix
M <- matrix(rnorm(N * N), N, N)  # Create an NxN matrix of random normal values
eigvals <- eigen(M)$values  # Compute eigenvalues of the matrix

# Create data frames for plotting
eigDF <- data.frame("Real" = Re(eigvals), "Imaginary" = Im(eigvals))  # Data frame of real and imaginary parts of eigenvalues
my_radius <- sqrt(N)  # Radius of the circle based on matrix size
ellDF <- build_ellipse(my_radius, my_radius)  # Data frame for ellipse points
names(ellDF) <- c("Real", "Imaginary")  # Rename columns for compatibility with ggplot aesthetics

# Plot eigenvalues and ellipse
p <- ggplot(eigDF, aes(x = Real, y = Imaginary)) +  # Base plot with eigenvalues
  geom_point(shape = I(3)) +  # Scatter plot for eigenvalues
  geom_hline(aes(yintercept = 0), linetype = "dashed") +  # Horizontal line at y=0
  geom_vline(aes(xintercept = 0), linetype = "dashed") +  # Vertical line at x=0
  geom_polygon(data = ellDF, aes(x = Real, y = Imaginary, alpha = 1/20, fill = "red")) +  # Add ellipse
  theme_minimal() +  # Use a clean, minimal theme
  theme(legend.position = "none")  # Remove the legend

# Save the plot
# Outputs the plot as a PDF file in the results directory
ggsave("../results/Girko.pdf", plot = p, height = 6, width = 6)
