# 02_eda.R - General EDA
# Set plot style
theme_set(theme_minimal())

# Load data
source("scripts/01_data_load.R")

# 1. Class Balance Summary
class_summary <- data_raw %>%
  count(Class) %>%
  mutate(perc = n / sum(n))

print(class_summary)

# 2. Raw Amount Distribution

p1 <- ggplot(data_raw, aes(x = Amount)) +
  geom_histogram(bins = 50, fill = "steelblue") +
  labs(title = "Transaction Amount Distribution", x = "Amount", y = "Count")

ggsave("outputs/plots/amount_distribution.png", plot = p1, width = 12, height = 4, dpi = 300)

# 3. Log-Transformed Amount Distribution
p2 <- ggplot(data_raw, aes(x = log1p(Amount))) +
  geom_histogram(bins = 50, fill = "tomato") +
  labs(title = "Log-Transformed Amount Distribution", x = "log(Amount + 1)", y = "Count")

ggsave("outputs/plots/log_amount_distribution.png", plot = p2, width = 12, height = 4, dpi = 300)

# 4. Transaction Time by Fraud Class
p3 <- ggplot(data_raw, aes(x = Time, fill = factor(Class))) +
  geom_histogram(bins = 100, position = "identity", alpha = 0.5) +
  labs(title = "Transaction Time by Fraud Class", x = "Time", y = "Count", fill = "Fraud")

ggsave("outputs/plots/time_distribution_by_class.png", plot = p3, width = 12, height = 4, dpi = 300)
