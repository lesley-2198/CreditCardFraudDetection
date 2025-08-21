# 04a_model_data_walkthrough.R
# Load the model-ready data
data_model_ready <- read_csv(here("data", "processed", "creditcard_model_ready.csv"))

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

png(here("outputs", "plots", "feature_correlation.png"), width = 800, height = 800)
corrplot(corr_matrix, method = "color", tl.cex = 0.7, number.cex = 0.7, type = "upper", title = "Feature Correlation", mar = c(0,0,1,0))
dev.off()