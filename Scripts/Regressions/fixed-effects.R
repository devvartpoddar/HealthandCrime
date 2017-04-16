# File to explore regressions

# Load data
final.data <- import('Data/merged-data.json') %>%
  arrange(UID, year) %>%
  mutate(lag.crime = dplyr::lag(GRNDTOT)) %>%
  mutate(obamacare = ifelse(year >= 2013, 1, 0))

reg <- plm(P1TOT ~ NUI + as.factor(obamacare) + MedianIncome +
  unemployed_pct + lag.crime + CPOPARST + as.factor(year) + minority_pct,
  data = final.data)
summary(reg)

str(final.data)
