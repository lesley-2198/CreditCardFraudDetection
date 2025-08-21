# 00_master_script.R
# Master Orchestrator Script for Credit Card Fraud Detection Project

# Clear workspace
rm(list = ls())

# Start overall timer
overall_start <- Sys.time()

# Load required libraries
required_packages <- c(
  "here", "tidyverse", "caret", "yardstick", "data.table", 
  "corrplot", "smotefamily", "pROC", "PRROC", "xgboost"
)

# Install missing packages
installed_packages <- rownames(installed.packages())
for (pkg in required_packages) {
  if (!(pkg %in% installed_packages)) {
    install.packages(pkg)
  }
}

# Load packages
invisible(lapply(required_packages, library, character.only = TRUE))

# Create logs directory if it doesn't exist
if (!dir.exists(here("outputs", "logs"))) {
  dir.create(here("outputs", "logs"), recursive = TRUE)
}

# Start logging
sink(here("outputs", "logs", "master_script_log.txt"), append = FALSE, split = TRUE)

cat("🚀 Starting Credit Card Fraud Detection Pipeline\n")
cat("Timestamp:", as.character(Sys.time()), "\n\n")

# Execute scripts in order
scripts <- c(
  "01_data_load.R",
  "02a_eda.R",
  "02b_eda_features.R",
  "03b_preprocessing.R",  # Fixed order
  "03a_feature_selection_scaling.R",
  "04_model_data_walkthrough.R",
  "05a_modeling_data_split.R",
  "05b_model_baseline.R",
  "05c_model_improvement_smote.R",
  "05d_model_improvement_xgboost.R",
  "06_model_comparison.R"
)

for (script in scripts) {
  cat("\n[Running]", script, "\n")
  start_time <- Sys.time()
  
  tryCatch({
    source(here("scripts", script))
    cat("✅ Completed successfully\n")
  }, error = function(e) {
    cat("❌ Error:", e$message, "\n")
  })
  
  cat("Time elapsed:", round(Sys.time() - start_time, 2), "seconds\n")
}

cat("\n🎉 Pipeline execution completed!\n")
cat("Total time:", round(Sys.time() - overall_start, 2), "seconds\n")

# End logging
sink()