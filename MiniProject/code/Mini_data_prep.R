##################################### PACKAGES #################################
library(tidyverse)

#################################### DATA WRANGLING ############################
# Reading raw data
data <- read.csv("../data/LogisticGrowthData.csv", stringsAsFactors = FALSE)

# Create unique ID: Combine Species / Temp / Medium / Citation_IDs
# First convert the Citation to a numeric ID to avoid special characters in the Citation
data$Citation_IDs <- as.numeric(factor(data$Citation, levels = unique(data$Citation)))
data$ID <- paste(data$Species, data$Temp, data$Medium, data$Citation_IDs, sep = "_")

# Remove rows where PopBio <= 0 (needed for logarithms)
data_modified <- data %>% filter(PopBio > 0)

# Add logarithmic columns
data_modified$log.PopBio <- log(data_modified$PopBio)

# Sort by ID and Time to ensure the correct timing of subsequent fitting
data_modified <- data_modified %>%
  arrange(ID, Time)

# Write out the cleaned data
write.csv(data_modified, "../data/data_modified.csv", row.names = FALSE)

cat("Data prep complete. Cleaned data saved to ../data/data_modified.csv\n")
