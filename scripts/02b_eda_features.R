# 02b_eda_features.R - PCA Feature Exploration

# Load packages
library(tidyverse)
library(corrplot)

# Plot style
theme_set(theme_minimal())

source("scripts/01_data_load.R")

# 1. Boxplot: Amount by Class
p4 <- ggplot(data_raw, aes(x = factor(Class), y = Amount)) +
  geom_boxplot(fill = "steelblue") +
  scale_y_log10() +
  labs(title = "Transaction Amount by Class", x = "Class (0 = Legit, 1 = Fraud)", y = "Amount (€)")

ggsave("outputs/plots/amount_boxplot_by_class.png", plot = p4, width = 8, height = 6, dpi = 300)

# 2. Density Plots for PCA Features
features <- paste0("V", 1:6)

for (feature in features) {
  p <- ggplot(data_raw, aes_string(x = feature, color = "factor(Class)")) +
    geom_density(alpha = 0.5) +
    labs(title = paste("Density of", feature, "by Class"), color = "Fraud Class") +
    scale_color_manual(values = c("0" = "grey40", "1" = "tomato")) +
    theme(legend.position = "top")
  
  ggsave(paste0("outputs/plots/density_", feature, ".png"),
         plot = p, width = 10, height = 4, dpi = 300)
}

# 3. Correlation Matrix (Upper Triangle)
corr_data <- data_raw %>% select(-Class)
corr_matrix <- cor(corr_data)

# Export corrplot using base plotting device
png("outputs/plots/correlation_matrix.png", width = 1000, height = 1000)
corrplot(corr_matrix, method = "color", type = "upper", tl.cex = 0.6,
         title = "Feature Correlation Matrix (PCA + Amount + Time)",
         mar = c(0,0,2,0))  # adjust top margin for title
dev.off()
