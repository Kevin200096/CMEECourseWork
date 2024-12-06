#!/usr/bin/env Rscript
# Author: Kevin Zhao
# Script: DataWrangTidy.R
# Description: Wrangle the Pound Hill dataset using tidyverse
# Inputs: PoundHillData.csv, PoundHillMetaData.csv
# Date: Dec 2024

# Load tidyverse package
if (!requireNamespace("tidyverse", quietly = TRUE)) {
  install.packages("tidyverse")
}
library(tidyverse)

# Load datasets
MyData <- as.matrix(read.csv("../data/PoundHillData.csv", header = FALSE)) # Load raw data
MyMetaData <- read.csv("../data/PoundHillMetaData.csv", header = TRUE, sep = ";") # Load metadata

# Inspect datasets
cat("Inspecting raw data...\n")
print(head(MyData))
print(dim(MyData))
print(str(MyData))

# Transpose the dataset: switch rows and columns
MyData <- t(MyData)

# Replace empty cells with zeros
MyData[MyData == ""] <- 0

# Convert the transposed matrix into a data frame
TempData <- as.data.frame(MyData[-1, ], stringsAsFactors = FALSE) # Exclude the first row
colnames(TempData) <- MyData[1, ] # Assign the first row as column names

# Convert from wide format to long format using tidyr::pivot_longer
MyWrangledData <- TempData %>%
  pivot_longer(
    cols = -c(Cultivation, Block, Plot, Quadrat), # Exclude metadata columns
    names_to = "Species", # New column for species names
    values_to = "Count" # New column for species counts
  )

# Convert relevant columns to appropriate data types
MyWrangledData <- MyWrangledData %>%
  mutate(
    across(c(Cultivation, Block, Plot, Quadrat), as.factor), # Convert metadata columns to factors
    Count = as.integer(Count) # Convert counts to integers
  )

# Inspect the wrangled data
cat("Inspecting wrangled data...\n")
print(str(MyWrangledData))
print(head(MyWrangledData))
print(dim(MyWrangledData))
