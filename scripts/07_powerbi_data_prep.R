# 07_powerbi_data_prep.R
# Prepare data for Power BI dashboard

# Load necessary data
test_data <- read_csv(here("data", "processed", "test_data.csv"))
logistic_preds <- read_csv(here("data", "processed", "logistic_predictions.csv"))
model_comparison <- read_csv(here("outputs", "reports", "model_comparison_detailed.csv"))

# Load original data
original_data <- read_csv(here("data", "raw", "creditcard.csv")) %>%
  as.data.frame()

# Since test_data doesn't have Time, we need to reconstruct it
# Get the test indices (assuming the test set is the last 20% of original data)
test_size <- nrow(test_data)
original_test <- original_data %>%
  tail(test_size) %>%
  mutate(TransactionID = row_number())

# Create comprehensive dataset for Power BI
powerbi_data <- test_data %>%
  as.data.frame() %>%
  mutate(
    TransactionID = row_number(),
    # Use the Time from original test data
    TransactionHour = as.integer(original_test$Time / 3600),
    # Use Amount from original test data (more meaningful than scaled version)
    Amount = original_test$Amount,
    AmountBucket = cut(Amount, 
                       breaks = c(0, 10, 50, 100, 500, 1000, Inf),
                       labels = c("0-10", "11-50", "51-100", "101-500", "501-1000", "1000+"),
                       include.lowest = TRUE),
    RiskScore = logistic_preds$probability,
    PredictedClass = logistic_preds$predicted,
    ActualClass = Class,
    # Create time-based features
    HourOfDay = TransactionHour %% 24,
    TimeOfDay = case_when(
      HourOfDay >= 6 & HourOfDay < 12 ~ "Morning",
      HourOfDay >= 12 & HourOfDay < 18 ~ "Afternoon",
      HourOfDay >= 18 & HourOfDay < 24 ~ "Evening",
      TRUE ~ "Night"
    ),
    # Include the original Time column
    Time = original_test$Time
  )

# Select only the columns we need for Power BI
powerbi_data <- powerbi_data %>%
  select(
    TransactionID, Time, Amount, AmountBucket, 
    TransactionHour, HourOfDay, TimeOfDay,
    ActualClass, PredictedClass, RiskScore,
    # Include some of the V features for analysis (first 10 for demonstration)
    V1, V2, V3, V4, V5, V6, V7, V8, V9, V10
  )

# Create model performance data
model_performance <- model_comparison %>%
  pivot_longer(cols = -Model, names_to = "Metric", values_to = "Value") %>%
  mutate(MetricType = case_when(
    Metric %in% c("Accuracy", "Precision", "Recall", "F1", "Specificity") ~ "Classification Metrics",
    Metric %in% c("AUC", "Kappa") ~ "Performance Scores",
    TRUE ~ "Other"
  ))

# Create time-based aggregation
hourly_summary <- powerbi_data %>%
  group_by(TransactionHour, ActualClass) %>%
  summarise(
    TransactionCount = n(),
    TotalAmount = sum(Amount, na.rm = TRUE),
    AvgAmount = mean(Amount, na.rm = TRUE),
    FraudRate = mean(ActualClass == 1),
    .groups = 'drop'
  )

# Create fraud analysis dataset
fraud_analysis <- powerbi_data %>%
  filter(ActualClass == 1) %>%
  mutate(
    FraudType = case_when(
      RiskScore > 0.8 ~ "High Confidence Fraud",
      RiskScore > 0.5 ~ "Medium Confidence Fraud",
      TRUE ~ "Low Confidence Fraud"
    ),
    AmountCategory = case_when(
      Amount <= 100 ~ "Small (<€100)",
      Amount <= 500 ~ "Medium (€100-500)",
      Amount <= 1000 ~ "Large (€500-1000)",
      TRUE ~ "Very Large (>€1000)"
    )
  )

# Create performance metrics by time period
time_performance <- powerbi_data %>%
  group_by(TimeOfDay) %>%
  summarise(
    TotalTransactions = n(),
    FraudTransactions = sum(ActualClass == 1),
    FraudRate = mean(ActualClass == 1),
    AvgRiskScore = mean(RiskScore),
    .groups = 'drop'
  )

# Create model evaluation summary
model_evaluation <- powerbi_data %>%
  summarise(
    TotalTransactions = n(),
    TruePositives = sum(ActualClass == 1 & PredictedClass == 1),
    FalsePositives = sum(ActualClass == 0 & PredictedClass == 1),
    FalseNegatives = sum(ActualClass == 1 & PredictedClass == 0),
    TrueNegatives = sum(ActualClass == 0 & PredictedClass == 0),
    Accuracy = (TruePositives + TrueNegatives) / TotalTransactions,
    Precision = TruePositives / (TruePositives + FalsePositives),
    Recall = TruePositives / (TruePositives + FalseNegatives),
    F1_Score = 2 * (Precision * Recall) / (Precision + Recall)
  )

# Save data for Power BI
write_csv(powerbi_data, here("data", "processed", "powerbi_transaction_data.csv"))
write_csv(model_performance, here("data", "processed", "powerbi_model_performance.csv"))
write_csv(hourly_summary, here("data", "processed", "powerbi_hourly_summary.csv"))
write_csv(fraud_analysis, here("data", "processed", "powerbi_fraud_analysis.csv"))
write_csv(time_performance, here("data", "processed", "powerbi_time_performance.csv"))
write_csv(model_evaluation, here("data", "processed", "powerbi_model_evaluation.csv"))

# Create a sample of data for demonstration
set.seed(123)
powerbi_sample <- powerbi_data %>% 
  sample_n(min(10000, nrow(powerbi_data))) %>%
  as.data.frame()

write_csv(powerbi_sample, here("data", "processed", "powerbi_sample_data.csv"))

cat("✅ Power BI data preparation complete!\n")
cat("📁 Files created in data/processed/:\n")
cat("   - powerbi_transaction_data.csv\n")
cat("   - powerbi_model_performance.csv\n")
cat("   - powerbi_hourly_summary.csv\n")
cat("   - powerbi_fraud_analysis.csv\n")
cat("   - powerbi_time_performance.csv\n")
cat("   - powerbi_model_evaluation.csv\n")
cat("   - powerbi_sample_data.csv\n")
cat("\n🎯 Next steps:\n")
cat("   1. Open Power BI Desktop\n")
cat("   2. Get Data → Text/CSV → Select the CSV files\n")
cat("   3. Start building your dashboard!\n")