# 💳 Credit Card Fraud Detection Using R & Power BI

An end-to-end machine learning project to detect fraudulent credit card transactions using an imbalanced dataset. This project demonstrates how predictive modeling in R (including logistic regression, SMOTE, and XGBoost) and interactive dashboards in Power BI can work together to support financial risk management in real-world settings.

---

## 🔍 Problem Statement

Credit card fraud is a growing threat in the digital economy. The challenge lies in identifying rare fraudulent transactions hidden among thousands of legitimate ones. This project uses predictive modeling and business intelligence to:

- Classify transactions as fraudulent or legitimate
- Deal with class imbalance (only ~0.17% are fraud)
- Uncover patterns and high-risk signals in transactional behavior
- Compare multiple modeling approaches for optimal performance
- Communicate findings through an executive-friendly Power BI dashboard

---

## 📦 Dataset

- Source: [Kaggle - Credit Card Fraud Detection](https://www.kaggle.com/datasets/mlg-ulb/creditcardfraud)
- Transactions made by European cardholders over a two-day period in 2013
- 284,807 transactions, with only 492 labeled as fraud
- Features:
  - `V1`–`V28`: PCA-transformed numerical features
  - `Amount`: Transaction value (in Euros)
  - `Time`: Seconds since the first transaction
  - `Class`: Target variable (`1` = Fraud, `0` = Legit)

---

## 🛠️ Tools & Technologies

| Category        | Tools Used         |
|----------------|--------------------|
| Language        | R (tidyverse, caret, corrplot, etc.) |
| Modeling        | Logistic Regression, Random Forests, SMOTE |
| Evaluation      | pROC, PRROC, yardstick, confusionMatrix |
| BI Dashboard    | Power BI           |
| Visualization   | ggplot2, corrplot, Power BI |
| Reporting       | RMarkdown, CSV summaries |
| Documentation   | MS Word  |

---

## 📊 Key Steps

### 1. Data Exploration & Preprocessing
- Visualized amount distributions and transaction times
- Compared fraudulent vs. legitimate transaction characteristics
- Standardized numerical features (`Amount`, `Time`)
- Created additional features (e.g., time-based indicators)
- Handled extreme class imbalance using SMOTE oversampling

### 2. Modeling Approaches
- **Baseline Logistic Regression:** Established performance baseline
- **SMOTE-enhanced Logistic Regression:** Addressed class imbalance
- **XGBoost:** Advanced gradient boosting for improved performance
- Comprehensive model evaluation using precision, recall, F1-score, ROC, and Precision-Recall curves

### 3. Business Intelligence Dashboard (Power BI)
- Created interactive KPIs and charts summarizing fraud distribution
- Visualized transaction value trends and model predictions
- Designed an intuitive interface for fraud analysts and stakeholders  
> ⚡ Note: The dashboard is a **work in progress** — additional fraud trend visualizations and analyst-focused KPIs are being developed.

---

## 📁 Project Structure

```
📦 credit-card-fraud-detection/
├── data/
│   ├── raw/
│   │   └── creditcard.csv
│   └── processed/
│       ├── creditcard_clean.csv
│       ├── creditcard_model_ready.csv
│       ├── fraud_summary_for_powerbi.csv
│       ├── logistic_predictions.csv
│       ├── logistic_smote_predictions.csv
│       ├── logistic_metrics.csv
│       ├── logistic_smote_metrics.csv
│       ├── smote_data.RData
│       ├── train_data.csv
│       └── test_data.csv
├── outputs/
│   ├── models/
│   │   ├── logistic_model.rds
│   │   ├── logistic_model_smote.rds
│   │   └── xgboost_model.rds
│   ├── plots/
│   │   ├── amount_distribution.png
│   │   ├── log_amount_distribution.png
│   │   ├── time_distribution_by_class.png
│   │   ├── amount_boxplot_by_class.png
│   │   ├── density_V1.png ...
│   │   ├── correlation_matrix.png
│   │   ├── feature_correlation.png
│   │   ├── roc_curve.png
│   │   ├── pr_curve.png
│   │   ├── xgboost_roc_curve.png
│   │   ├── xgboost_pr_curve.png
│   │   ├── xgboost_feature_importance.png
│   │   └── model_comparison.png
│   └── reports/
│       ├── logistic_confusion_matrix.txt
│       ├── logistic_smote_confusion_matrix.txt
│       ├── xgboost_report.txt
│       ├── model_comparison.csv
│       └── model_comparison_detailed.csv
├── scripts/
│   ├── 00_master_script.R
│   ├── 01_data_load.R
│   ├── 02a_eda.R
│   ├── 02b_eda_features.R
│   ├── 03b_preprocessing.R
│   ├── 03a_feature_selection_scaling.R
│   ├── 04_model_data_walkthrough.R
│   ├── 05a_modeling_data_split.R
│   ├── 05b_model_baseline.R
│   ├── 05c_model_improvement_smote.R
│   ├── 05d_model_improvement_xgboost.R
│   └── 06_model_comparison.R
└── logs/
    └── master_script_log.txt
```

---

## 🚀 Usage

To run the entire project workflow from data loading to model training and output generation, execute the **master orchestrator script**:

```r
# From the project root directory
source("scripts/00_master_script.R")
```

### 📝 Notes

> - The master script automatically installs required packages and handles all dependencies
> - All file paths are managed using the `here` package for reproducibility across systems
> - Execution progress and timing information is logged to `outputs/logs/master_script_log.txt`
> - The Kaggle dataset (`data.csv`) must be placed in `data/raw/` before execution

---

## 📈 Results & Findings

| **Model**                           | **AUC** | **Precision** | **Recall** | **F1** | **Accuracy** |
|-------------------------------------|---------|---------------|------------|--------|--------------|
| **Logistic Regression (Baseline)**  | -       | 0.873         | 0.579      | 0.696  |  0.999       |
| **Logistic Regression (SMOTE)**     | 0.977   | 0.794         | 0.794      | 0.794  | 0.999        |
| **XGBoost**                         | 0.982   | 0.944         |0.794       | 0.863  | 0.999        |

### Key Insights

- XGBoost achieved the best overall performance with highest AUC (0.982) and F1-score (0.863)
- SMOTE significantly improved recall (from 0.579 to 0.794) while maintaining high precision
- Fraudulent transactions often have smaller or atypical amounts
- Certain PCA features show strong separation by class
- Precision-recall trade-off is critical in low-fraud environments
- The Power BI dashboard enables real-time fraud monitoring and investigation
> 💡 Power BI dashboard development is **ongoing** — the current version includes fraud distribution summaries, with future updates planned for advanced drilldowns and real-time monitoring views.

---

## 📌 Next Steps
- Finalize and expand the Power BI dashboard (advanced drilldowns, fraud KPIs)
- Deploy the best model (XGBoost) as a real-time scoring API
- Implement automated model retraining pipeline
- Integrate additional data sources (geolocation, merchant metadata)
- Develop an alert system for high-risk transactions
- Explore deep learning approaches (autoencoders, LSTM networks)
- Implement model monitoring for concept drift detection

---

## 👨‍💻 The Architect

<div align="center">

### **Lesley Ngcobo**
*Data Scientist | ML Engineer | Business Intelligence Specialist*

![Profile](https://img.shields.io/badge/Profile-Data_Scientist-00B4D8?style=for-the-badge)
![Location](https://img.shields.io/badge/Location-South_Africa-FF6B6B?style=for-the-badge)

**🔗 Connect with me:**
[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=flat&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/lesley-ngcobo-449b88240/)
[![Email](https://img.shields.io/badge/Email-D14836?style=flat&logo=gmail&logoColor=white)](mailto:s225171406@mandela.ac.za)

</div>
