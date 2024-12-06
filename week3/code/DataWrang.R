################################################################
################## Wrangling the Pound Hill Dataset ############
################################################################
# Author: Kevin Zhao zhetao.zhao24@imperial.ac.uk
# Script: DataWrang.R
# Description: Cleans and transforms the Pound Hill dataset for analysis.
# Inputs: "../data/PoundHillData.csv" (raw dataset),
#         "../data/PoundHillMetaData.csv" (metadata)
# Outputs: None
# Date: Dec 2024

############# Load Required Packages ###############
# Load reshape2 package
require(reshape2)  # Ensure reshape2 is available

############# Load the Dataset ###############
# Load raw dataset without headers
# Assumes the file "../data/PoundHillData.csv" exists
MyData <- as.matrix(read.csv("../data/PoundHillData.csv", header = FALSE))

# Load metadata with headers
# Assumes the file "../data/PoundHillMetaData.csv" exists
MyMetaData <- read.csv("../data/PoundHillMetaData.csv", header = TRUE, sep = ";")

############# Inspect the Dataset ###############
# Display raw data for debugging
head(MyData)  # First few rows
dim(MyData)   # Dimensions of the matrix
str(MyData)   # Structure of the data

############# Transpose the Dataset ###############
# Transpose the matrix to make species columns and treatments rows
MyData <- t(MyData)

############# Replace Missing Values with Zeros ###############
# Replace empty strings in the matrix with zeros
MyData[MyData == ""] <- 0

############# Convert Matrix to Data Frame ###############
# Convert the transposed matrix to a data frame
TempData <- as.data.frame(MyData[-1,], stringsAsFactors = FALSE)  # Exclude the header row
colnames(TempData) <- MyData[1,]  # Assign column names from the first row of the original matrix

############# Convert from Wide to Long Format ###############
# Use melt to reshape data into long format
MyWrangledData <- melt(
  TempData, 
  id = c("Cultivation", "Block", "Plot", "Quadrat"), 
  variable.name = "Species", 
  value.name = "Count"
)

# Convert categorical variables to factors
MyWrangledData[, "Cultivation"] <- as.factor(MyWrangledData[, "Cultivation"])
MyWrangledData[, "Block"] <- as.factor(MyWrangledData[, "Block"])
MyWrangledData[, "Plot"] <- as.factor(MyWrangledData[, "Plot"])
MyWrangledData[, "Quadrat"] <- as.factor(MyWrangledData[, "Quadrat"])
MyWrangledData[, "Count"] <- as.integer(MyWrangledData[, "Count"])  # Convert counts to integers

############# Inspect the Wrangled Data ###############
# Display the wrangled data for debugging
str(MyWrangledData)  # Structure of the wrangled data
head(MyWrangledData)  # First few rows
dim(MyWrangledData)   # Dimensions of the wrangled data
