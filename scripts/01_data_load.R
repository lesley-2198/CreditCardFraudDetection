# 01_data_load.R
# Load dataset
data_raw <- fread("data/raw/creditcard.csv")

# Quick overview
glimpse(data_raw)
summary(data_raw)
table(data_raw$Class)
