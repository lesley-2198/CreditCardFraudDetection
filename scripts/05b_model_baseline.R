# 05_model_baseline.R
# Step 5: Baseline Modeling with Logistic Regression
# 📁 Load Data
train_data <- read_csv(here("data", "processed", "train_data.csv"))
test_data  <- read_csv(here("data", "processed", "test_data.csv"))

# 🧹 Convert Class to factor for classification
train_data <- train_data %>% mutate(Class = factor(Class, levels = c(0, 1)))
test_data  <- test_data  %>% mutate(Class = factor(Class, levels = c(0, 1)))

# 🎯 Define the formula for logistic regression
model_formula <- Class ~ .

# 🏋️ Train Logistic Regression Model
set.seed(123)
log_model <- glm(model_formula, data = train_data, family = "binomial")

# 🔮 Make Predictions
pred_probs <- predict(log_model, newdata = test_data, type = "response")
pred_class <- ifelse(pred_probs > 0.5, 1, 0) %>% factor(levels = c(0, 1))

pred_class <- factor(pred_class, levels = c("0", "1"))
true_class <- factor(test_data$Class, levels = c("0", "1"))

# ✅ Evaluate Model
conf_matrix <- confusionMatrix(pred_class, test_data$Class, positive = "1")
metrics <- yardstick::metrics(data.frame(truth = test_data$Class, estimate = pred_class), truth, estimate)

# 💾 Save predictions for Power BI or future analysis
output_df <- test_data %>%
  select(Class) %>%
  mutate(predicted = pred_class, probability = pred_probs)

write_csv(output_df, here("data", "processed", "logistic_predictions.csv"))

# 🖨️ Print Results
print("Confusion Matrix:")
print(conf_matrix)
print("Metrics:")
print(metrics)
 
saveRDS(log_model, here("outputs", "models", "logistic_model.rds"))
sink(here("outputs", "reports", "logistic_confusion_matrix.txt"))
print(conf_matrix)
sink()

# Save yardstick metrics
write.csv(metrics, here("data", "processed", "logistic_metrics.csv"), row.names = FALSE)