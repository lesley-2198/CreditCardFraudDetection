# 06_model_comparison.R
# Compare Logistic Regression (baseline), SMOTE, and XGBoost models

library(here)
library(tidyverse)
library(stringr)

# ---------------------------
# 1. Define helper to extract metrics from confusion matrix format
# ---------------------------
extract_metrics <- function(file, model_name) {
  if (!file.exists(file)) {
    warning(paste("File not found:", file))
    return(tibble(
      Model = model_name,
      AUC = NA,
      Precision = NA,
      Recall = NA,
      F1 = NA,
      Specificity = NA,
      Accuracy = NA,
      Kappa = NA
    ))
  }
  
  lines <- readLines(file)
  
  # Extract AUC (only for XGBoost)
  auc <- NA
  if (any(grepl("AUC:", lines))) {
    auc_line <- grep("AUC:", lines, value = TRUE)
    auc <- as.numeric(str_extract(auc_line, "[0-9.]+"))
  }
  
  # Extract metrics from confusion matrix
  accuracy_line <- grep("Accuracy :", lines, value = TRUE)
  accuracy <- as.numeric(str_extract(accuracy_line, "[0-9.]+"))
  
  kappa_line <- grep("Kappa :", lines, value = TRUE)
  kappa <- as.numeric(str_extract(kappa_line, "[0-9.]+"))
  
  sensitivity_line <- grep("Sensitivity :", lines, value = TRUE)
  recall <- as.numeric(str_extract(sensitivity_line, "[0-9.]+"))  # Sensitivity = Recall
  
  specificity_line <- grep("Specificity :", lines, value = TRUE)
  specificity <- as.numeric(str_extract(specificity_line, "[0-9.]+"))
  
  ppv_line <- grep("Pos Pred Value :", lines, value = TRUE)
  precision <- as.numeric(str_extract(ppv_line, "[0-9.]+"))  # Pos Pred Value = Precision
  
  # Calculate F1 score
  f1 <- if (!is.na(precision) && !is.na(recall) && (precision + recall) > 0) {
    2 * (precision * recall) / (precision + recall)
  } else NA
  
  tibble(
    Model = model_name,
    AUC = auc,
    Precision = precision,
    Recall = recall,
    F1 = f1,
    Specificity = specificity,
    Accuracy = accuracy,
    Kappa = kappa
  )
}

# ---------------------------
# 2. Load reports & extract metrics
# ---------------------------
baseline <- extract_metrics(here("outputs", "reports", "logistic_confusion_matrix.txt"), "LogReg (Baseline)")
smote <- extract_metrics(here("outputs", "reports", "logistic_smote_confusion_matrix.txt"), "LogReg (SMOTE)")
xgb <- extract_metrics(here("outputs", "reports", "xgboost_report.txt"), "XGBoost")

results <- bind_rows(baseline, smote, xgb)

# ---------------------------
# 3. Save comparison table
# ---------------------------
write_csv(results, here("outputs", "reports", "model_comparison.csv"))

# ---------------------------
# 4. Plot comparison for key metrics
# ---------------------------
results_long <- results %>%
  select(Model, AUC, Precision, Recall, F1, Accuracy) %>%
  pivot_longer(cols = -Model, names_to = "Metric", values_to = "Value") %>%
  filter(!is.na(Value))

p <- ggplot(results_long, aes(x = Model, y = Value, fill = Model)) +
  geom_bar(stat = "identity", position = "dodge") +
  facet_wrap(~ Metric, scales = "free_y") +
  theme_minimal(base_size = 14) +
  labs(title = "Model Performance Comparison", y = "Score", x = "Model") +
  theme(legend.position = "none") +
  scale_fill_brewer(palette = "Set2") +
  geom_text(aes(label = round(Value, 3)), vjust = -0.5, size = 3)

ggsave(here("outputs", "plots", "model_comparison.png"), plot = p, width = 10, height = 8, dpi = 300)

# ---------------------------
# 5. Create a detailed summary table
# ---------------------------
detailed_results <- results %>%
  select(Model, Accuracy, Precision, Recall, F1, Specificity, Kappa, AUC) %>%
  mutate(across(where(is.numeric), ~ round(., 4)))

write_csv(detailed_results, here("outputs", "reports", "model_comparison_detailed.csv"))

# Print results
cat("Model Comparison Results:\n")
print(results)

cat("\nDetailed Results:\n")
print(detailed_results)