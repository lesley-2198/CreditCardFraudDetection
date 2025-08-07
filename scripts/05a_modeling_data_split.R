# ─────────────────────────────────────────────────────────
# Purpose: Split the model-ready data into training and test sets
# ─────────────────────────────────────────────────────────

# Load necessary package
library(caret)     # For stratified data partitioning
library(readr)     # For saving the datasets

# Load the model-ready data
data_model_ready <- read_csv("data/processed/creditcard_model_ready.csv")

# Set a seed to ensure reproducibility
set.seed(123)

# Stratified train/test split: 80% training, 20% test
# Ensures that both sets have a similar proportion of fraud vs non-fraud cases
train_index <- createDataPartition(data_model_ready$Class, p = 0.8, list = FALSE)

# Split the data
train_data <- data_model_ready[train_index, ]
test_data  <- data_model_ready[-train_index, ]

# Confirm dimensions of each set
cat("Training Set:", nrow(train_data), "rows\n")
cat("Test Set:    ", nrow(test_data), "rows\n")

# Optionally check the fraud rate in both sets
cat("\nFraud Rate in Training Set:\n")
print(prop.table(table(train_data$Class)))

cat("\nFraud Rate in Test Set:\n")
print(prop.table(table(test_data$Class)))

# Save the split data
write_csv(train_data, "data/processed/train_data.csv")
write_csv(test_data, "data/processed/test_data.csv")
