# 05c_model_improvement_smote.R
# Step 5c: Model Improvement with SMOTE Oversampling
# --------------------------------------------------

# 📁 Load Data
train_data <- read_csv("data/processed/train_data.csv")
test_data  <- read_csv("data/processed/test_data.csv")

# 🧹 Convert Class to factor
train_data <- train_data %>% mutate(Class = factor(Class, levels = c(0, 1)))
test_data  <- test_data %>% mutate(Class = factor(Class, levels = c(0, 1)))

# ⚖️ Apply SMOTE oversampling
set.seed(123)
smote_res <- SMOTE(
  X = train_data %>% select(-Class),
  target = train_data$Class,
  K = 5,
  dup_size = 10
)

# Create balanced dataset
train_data_smote <- smote_res$data
colnames(train_data_smote)[ncol(train_data_smote)] <- "Class"
train_data_smote$Class <- factor(train_data_smote$Class, levels = c(0, 1))

cat("\nClass distribution after SMOTE:\n")
print(table(train_data_smote$Class))

# 🎯 Define model formula
model_formula <- Class ~ .

# 🏋️ Train Logistic Regression on SMOTE data
set.seed(123)
log_model_smote <- glm(model_formula, data = train_data_smote, family = "binomial")

# 🔮 Predictions
pred_probs <- predict(log_model_smote, newdata = test_data, type = "response")
pred_class <- ifelse(pred_probs > 0.5, 1, 0) %>% factor(levels = c(0, 1))

# ✅ Evaluation
conf_matrix <- confusionMatrix(pred_class, test_data$Class, positive = "1")
metrics <- yardstick::metrics(
  tibble(truth = test_data$Class, estimate = pred_class),
  truth, estimate
)

# 💾 Save outputs
output_df <- test_data %>%
  select(Class) %>%
  mutate(predicted = pred_class, probability = pred_probs)

write_csv(output_df, "data/processed/logistic_smote_predictions.csv")
saveRDS(log_model_smote, "outputs/models/logistic_model_smote.rds")

# Save confusion matrix
sink("outputs/reports/logistic_smote_confusion_matrix.txt")
print(conf_matrix)
sink()

# Save yardstick metrics
write.csv(metrics, "data/processed/logistic_smote_metrics.csv", row.names = FALSE)

# 🖨️ Print results
print("Confusion Matrix (SMOTE):")
print(conf_matrix)
print("Metrics (SMOTE):")
print(metrics)
