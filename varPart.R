library(ggplot2)
library(dplyr)
library(tidyr)
vrc <- read.csv("outputs/conjectureData.csv")
pdf("outputs/varPart.pdf", width = 5, height = 3)
vrc |> mutate("within-cohort" = varWithin, "between-cohort" = varBetween) |>
  pivot_longer(cols = c("within-cohort", "between-cohort"), values_to = "Variance", names_to = "source") |>
  ggplot(aes(as.factor(R0), Variance, fill = source))+
  geom_col(position = "stack", width = 0.3)+
  theme_classic() +
  labs(color = "source of variation", x = "R0", y = "Variance in cases per case")
dev.off()
