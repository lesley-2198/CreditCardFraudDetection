# 03_preprocessing.R
# Prepares the Credit Card Fraud dataset for modeling

library(tidyverse)
library(scales)

# Load the raw data
source("scripts/01_data_load.R")

# 1. Check for missing values
missing_summary <- colSums(is.na(data_raw))
print(missing_summary)

# 2. Drop irrelevant columns
# Note: We’re keeping all columns for now since V1-V28 are PCA components

# 3. Scale 'Amount' and 'Time'
data_clean <- data_raw %>%
  mutate(
    Amount_Scaled = scale(Amount),
    Time_Scaled = scale(Time)
  ) %>%
  select(-Amount, -Time)  # Drop original unscaled versions

# 4. Optional: Create new features (not strictly necessary for this PCA dataset)
# For illustration: Create a feature for night vs day transactions
data_clean <- data_clean %>%
  mutate(
    Is_Night = ifelse(Time_Scaled < -0.5, 1, 0)  # Crude logic: low time = early in dataset
  )

#Flatten matrix/list columns into numeric columns
data_clean[[30]] <- as.vector(data_clean[[30]])
data_clean[[31]] <- as.vector(data_clean[[31]])
data_clean[[32]] <- as.vector(data_clean[[32]])

# 5. Save the cleaned dataset
write_csv(data_clean, "data/processed/creditcard_clean.csv")

# 6. Basic checks
glimpse(data_clean)
summary(data_clean$Class)
