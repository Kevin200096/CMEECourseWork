# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: MyBars.R
# Description: Generates a multi-line range plot from input data and saves it as a PDF.
# Inputs: "../data/Results.txt" (tabular data with columns: x, y1, y2, y3, Label)
# Outputs: "../results/MyBars.pdf" (line range plot)
# Date: Dec 2024

# Ensure ggplot2 is installed and loaded
if (!requireNamespace("ggplot2", quietly = TRUE)) {
    install.packages("ggplot2")
}
library(ggplot2)  # Load ggplot2 for data visualization

# Read the input data file
# Input file should have columns: x, y1, y2, y3, Label
# x: X-axis positions, y1/y2/y3: Heights of line ranges, Label: Annotations
a <- read.table("../data/Results.txt", header = TRUE)

# Display the first few rows of the data for verification
head(a)

# Add a new column of zeros for ymin values
a$ymin <- rep(0, dim(a)[1])

# Initialize the ggplot object with the data
p <- ggplot(a)

# Add the first linerange (y1)
p <- p + geom_linerange(data = a, aes(
                          x = x,
                          ymin = ymin,
                          ymax = y1,
                          size = 0.5  # Line thickness
                          ),
                        colour = "#E69F00",  # Color of the lines
                        alpha = 1/2,  # Transparency
                        show.legend = FALSE)  # Hide the legend

# Add the second linerange (y2)
p <- p + geom_linerange(data = a, aes(
                          x = x,
                          ymin = ymin,
                          ymax = y2,
                          size = 0.5
                          ),
                        colour = "#56B4E9",
                        alpha = 1/2,
                        show.legend = FALSE)

# Add the third linerange (y3)
p <- p + geom_linerange(data = a, aes(
                          x = x,
                          ymin = ymin,
                          ymax = y3,
                          size = 0.5
                          ),
                        colour = "#D55E00",
                        alpha = 1/2,
                        show.legend = FALSE)

# Annotate the plot with labels at a fixed y position (-500)
p <- p + geom_text(data = a, aes(x = x, y = -500, label = Label))

# Customize axis labels, breaks, and theme
p <- p + scale_x_continuous("My x axis",  # Label for the x-axis
                            breaks = seq(3, 5, by = 0.05)) +  # X-axis tick marks
                            scale_y_continuous("My y axis") +  # Label for the y-axis
                            theme_bw() +  # Use a black-and-white theme
                            theme(legend.position = "none")  # Remove legend

# Display the plot (optional for RStudio)
print(p)

# Save the plot as a PDF file in the results directory
ggsave("../results/MyBars.pdf", plot = p, width = 7.5, height = 5)
