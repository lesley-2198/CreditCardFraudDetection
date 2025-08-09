# 💳 Credit Card Fraud Detection Using R & Power BI

An end-to-end machine learning project to detect fraudulent credit card transactions using an imbalanced dataset. This project demonstrates how predictive modeling in R and interactive dashboards in Power BI can work together to support financial risk management in real-world settings.

---

## 🔍 Problem Statement

Credit card fraud is a growing threat in the digital economy. The challenge lies in identifying rare fraudulent transactions hidden among thousands of legitimate ones. This project uses predictive modeling and business intelligence to:

- Classify transactions as fraudulent or legitimate
- Deal with class imbalance (only ~0.17% are fraud)
- Uncover patterns and high-risk signals in transactional behavior
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
| BI Dashboard    | Power BI           |
| Visualization   | ggplot2, Power BI |
| Reporting       | RMarkdown, CSV summaries |
| Documentation   | MS Word  |

---

## 📊 Key Steps

### 1. Data Exploration
- Visualized amount distributions and transaction times
- Compared fraudulent vs. legitimate transaction characteristics
- Inspected PCA features and correlation structure

### 2. Preprocessing & Modeling
- Standardized `Amount`, handled imbalance using SMOTE and undersampling
- Built classification models with cross-validation
- Evaluated using precision, recall, F1-score, ROC, PR curves

### 3. Business Intelligence Dashboard (Power BI)
- Created KPIs and charts summarizing fraud distribution, transaction value trends, and model predictions
- Designed an intuitive interface for fraud analysts and stakeholders

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
│       ├── train_data.csv
│       └── test_data.csv
├── outputs/
│   ├── models/
│   │   └── logistic_model.rds
│   ├── plots/
│   └── reports/
│       └── logistic_confusion_matrix.txt
├── scripts/
│   ├── 00_master_script.R
│   ├── 01_data_load.R
│   ├── 02a_eda.R
│   ├── 02b_eda_features.R
│   ├── 03a_feature_selection_scaling.R
│   ├── 03b_preprocessing.R
│   ├── 04_model_data_walkthrough.R
│   ├── 05a_modeling_data_split.R
│   └── 05b_model_baseline.R
```

---

## 🚀 Usage

To run the entire project workflow from data loading to model training and output generation, execute the **master orchestrator script**:

```r
# From the project root directory
source("scripts/00_master_script.R")
```

### 📝 Notes

> - Ensure all required packages are installed. The master script will automatically install any missing ones.
> - By default, the script expects the Kaggle dataset (`creditcard.csv`) to be located in:

```bash
data/raw/
```
>- All processed datasets, trained models, evaluation reports, and plots will be saved into their respective folders under:

```bash
data/processed/
outputs/
```

---

## 📈 Results & Findings

- Fraudulent transactions often have smaller or atypical amounts
- Certain PCA features show strong separation by class
- Precision-recall trade-off is critical in low-fraud environments
- The Power BI dashboard enables real-time fraud monitoring

---

## 📌 Next Steps

- Deploy as a real-time scoring pipeline
- Test advanced models like XGBoost or Isolation Forest
- Add geolocation or merchant metadata (if available)

---

## 👨‍💻 Author

**Lesley Ngcobo**  
Data Analyst | R Enthusiast | Business Intelligence Learner  
📧 [Email | Lesley Ngcobo](s225171406@mandela.ac.za) | 🌐 [LinkedIn | Lesley Ngcobo](https://www.linkedin.com/in/lesley-ngcobo-449b88240/)
