# 05d_model_improvement_xgboost.R
# Train & evaluate XGBoost model on SMOTE-balanced dataset

# Load the SMOTE-balanced training and test data
load(here("smote_data.RData"))  # loads train_data_smote and test_data

# Ensure the target variable is in numeric 0/1 format
train_data_smote$Class <- as.numeric(as.character(train_data_smote$Class))
test_data$Class <- as.numeric(as.character(test_data$Class))

# Convert data to xgb.DMatrix format
x_train <- as.matrix(train_data_smote %>% select(-Class))
y_train <- train_data_smote$Class

x_test <- as.matrix(test_data %>% select(-Class))
y_test <- test_data$Class

dtrain <- xgb.DMatrix(data = x_train, label = y_train)
dtest <- xgb.DMatrix(data = x_test, label = y_test)

# Train XGBoost model
params <- list(
  objective = "binary:logistic",
  eval_metric = "auc",
  max_depth = 6,
  eta = 0.1,
  subsample = 0.8,
  colsample_bytree = 0.8
)

xgb_model <- xgb.train(
  params = params,
  data = dtrain,
  nrounds = 100,
  watchlist = list(train = dtrain, eval = dtest),
  verbose = 1
)

# Predictions
pred_probs <- predict(xgb_model, x_test)
pred_labels <- ifelse(pred_probs > 0.5, 1, 0)

# Confusion Matrix
cm <- confusionMatrix(
  factor(pred_labels),
  factor(y_test),
  positive = "1"
)
print(cm)

# ROC Curve
roc_obj <- roc(y_test, pred_probs)
plot(roc_obj, main = "XGBoost ROC Curve", col = "blue", lwd = 2)

# Precision-Recall Curve
pr_obj <- pr.curve(
  scores.class0 = pred_probs[y_test == 1],
  scores.class1 = pred_probs[y_test == 0],
  curve = TRUE
)
plot(pr_obj, main = "XGBoost Precision-Recall Curve")

# Feature importance
importance_matrix <- xgb.importance(model = xgb_model)
xgb.plot.importance(importance_matrix)

# Save model
saveRDS(xgb_model, here("outputs", "models", "xgboost_model.rds"))

# Save evaluation report
sink(here("outputs", "reports", "xgboost_report.txt"))
cat("Confusion Matrix:\n")
print(cm)
cat("\nAUC:", auc(roc_obj), "\n")
sink()

# Save ROC curve
png(here("outputs", "plots", "xgboost_roc_curve.png"))
plot(roc_obj, main = "XGBoost ROC Curve", col = "blue", lwd = 2)
dev.off()

# Save Precision-Recall curve
png(here("outputs", "plots", "xgboost_pr_curve.png"))
plot(pr_obj, main = "XGBoost Precision-Recall Curve")
dev.off()

# Save Feature Importance plot
png(here("outputs", "plots", "xgboost_feature_importance.png"))
xgb.plot.importance(importance_matrix)
dev.off()
