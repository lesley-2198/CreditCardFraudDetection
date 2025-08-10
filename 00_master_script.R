# 00_master_script.R
# Master Orchestrator Script for Credit Card Fraud Detection Project
# ----------------------------------------------------------

# Clear workspace
rm(list = ls())

# Set working directory to project root (adjust if needed)
# setwd("path/to/project-folder")

# Load required libraries
required_packages <- c(
  "smotefamily", "tibble", "skimr", "janitor", "scales", "readr", "tidyverse", "caret", "yardstick", "data.table", "GGally", "corrplot"
)

# Install missing packages
installed_packages <- rownames(installed.packages())
for (pkg in required_packages) {
  if (!(pkg %in% installed_packages)) {
    install.packages(pkg)
  }
}

# Load packages
lapply(required_packages, library, character.only = TRUE)

# ---- 1. Data Load ----
cat("\n[Step 1] Loading data...\n")
source("scripts/01_data_load.R")

# ---- 2. EDA ----
cat("\n[Step 2] Running Exploratory Data Analysis...\n")
source("scripts/02a_eda.R")

# ---- 2b. EDA Features----
cat("\n[Step 2b] Creating Features...\n")
source("scripts/02b_eda_features.R")

# ---- 3a. Feature Selection----
cat("\n[Step 3a] Running Feature Selection & Scaling...\n")
source("scripts/03a_feature_selection_scaling.R")

# ---- 3b. Pre-processing ----
cat("\n[Step 3b] Running Pre-processing...\n")
source("scripts/03b_preprocessing.R")

# ---- 4. Model Data Walkthrough ----
cat("\n[Step 4] Model Data Walkthrough...\n")
source("scripts/04_model_data_walkthrough.R")

# ---- 5a. Modeling Data Split ----
cat("\n[Step 5a] Splitting Data for Modeling...\n")
source("scripts/05a_modeling_data_split.R")

# ---- 5b. Baseline Model ----
cat("\n[Step 5b] Training Baseline Model...\n")
source("scripts/05b_model_baseline.R")

# --- 5c. Model Improvement with SMOTE ----
cat("\n[Step 5C] Improved Baseline Model with SMOTE...\n")
source("scripts/05c_model_improvement_smote.R")

cat("\n✅ All steps completed successfully!\n")
