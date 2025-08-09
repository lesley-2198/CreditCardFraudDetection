# 03_feature_selection_scaling.R
# Purpose: Perform feature selection and feature scaling
# Load preprocessed data
data_clean <- read_csv("data/processed/creditcard_clean.csv")

#-------------------------------#
# Step 1: Feature Selection
#-------------------------------#

# Drop the "Time" column (not useful for modeling in this form)
data_selected <- data_clean %>% select(-Time_Scaled)

# Optional: Drop highly correlated features (already PCA'd, so not needed)
# You can uncomment this section if you decide to drop highly correlated V-features
# corr_matrix <- cor(data_selected %>% select(-Class))
# high_corr <- findCorrelation(corr_matrix, cutoff = 0.95)
# data_selected <- data_selected[, -high_corr]

#-------------------------------#
# Step 2: Feature Scaling
#-------------------------------#

# Scale all features except the Class label
scaled_features <- data_selected %>%
  select(-Class) %>%
  mutate(across(everything(), scale))

# Combine scaled features with target
data_model_ready <- bind_cols(scaled_features, Class = data_selected$Class)

# Convert all matrix columns to vectors
data_model_ready <- data_model_ready %>%
  mutate(across(where(~ is.matrix(.x)), ~ as.vector(.x)))

#-------------------------------#
# Step 3: Save Output
#-------------------------------#

write_csv(data_model_ready, "data/processed/creditcard_model_ready.csv")

message("Feature selection and scaling complete. Saved to 'data/processed/creditcard_model_ready.csv'")
