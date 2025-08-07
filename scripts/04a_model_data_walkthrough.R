# 04a_model_data_walkthrough.R

# Load required libraries
library(tidyverse)
library(janitor)
library(skimr)
library(corrplot)

# Load the model-ready data
data_model_ready <- read_csv("data/processed/creditcard_model_ready.csv")

# 1. Basic Overview
cat("🔍 Dataset Dimensions:\n")
dim(data_model_ready)

cat("\n📋 Column Names:\n")
names(data_model_ready)

# 2. Structure of the data
cat("\n📦 Data Types:\n")
glimpse(data_model_ready)

# 3. Summary statistics
cat("\n📊 Summary Statistics:\n")
summary(data_model_ready)

# 4. Missing values
cat("\n❓ Missing Values:\n")
colSums(is.na(data_model_ready))

# 5. Class distribution
cat("\n📈 Class Distribution:\n")
data_model_ready %>%
  count(Class) %>%
  mutate(percent = n / sum(n) * 100)

# 6. Feature ranges and scaling sanity check (only numeric features)
data_model_ready %>%
  select(-Class) %>%
  summarise(across(everything(), list(min = min, max = max, mean = mean, sd = sd)))

# 7. Correlation matrix for numeric features
corr_matrix <- data_model_ready %>%
  select(where(is.numeric), -Class) %>%
  cor()

corrplot(corr_matrix, method = "color", tl.cex = 0.7, number.cex = 0.7, type = "upper", title = "Feature Correlation", mar = c(0,0,1,0))
