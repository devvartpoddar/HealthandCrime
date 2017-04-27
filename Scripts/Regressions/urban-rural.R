# File to explore regressions

# Load data
final.data <- import('Data/merged-data.json')  %>%
  arrange(UID, year) %>%
  select(-iprcat) %>%
  mutate_at(vars(matches("TOT|NUI|CPOPARST|Median|black|unemployed|P1")),
            funs(log))  %>%
  mutate(urban = factor(urban, levels = 1:6))

# Cleaning up infinity values
is.na(final.data) <- do.call(cbind,lapply(final.data, is.infinite))

# Custom Functions
give.number <- function(list.reg) {
  # Number of regressions
  no <- length(list.reg)
  final.list <- list(N = rep(NA, no),
                     panel = rep(NA, no))
  
  for (x in 1:no) {
    temp.model <- list.reg[[x]]
    
    N <- temp.model$residuals %>% length()
    panel <- temp.model$model
    y <- attr(panel, "index")$UID %>% levels() %>% length()
    
    if (y > N) y <- N
    
    final.list[[1]][x] <- N
    final.list[[2]][x] <- y
  }
  
  return(final.list)
}

se.correct <- function(x) {
  coeftest(x, vcov.= function(x) vcovHC(x))
}

# Running the different models
# Regressions

fe_base <- plm(GRNDTOT ~ NUI + NUI*urban + CPOPARST,
               data = final.data)

fe_social <- plm(GRNDTOT ~ NUI + NUI*urban + CPOPARST + blacks_and_hispanics,
                 data = final.data)

fe_econ <- plm(GRNDTOT ~ NUI + NUI*urban + CPOPARST + MedianIncome +
                 unemployed,
               data = final.data)

fe_control <- plm(GRNDTOT ~ NUI + NUI*urban + CPOPARST + blacks_and_hispanics + 
                    MedianIncome + unemployed,
                  data = final.data)

fe_year <- plm(GRNDTOT ~ NUI + NUI*urban + CPOPARST + blacks_and_hispanics +
                 MedianIncome + unemployed + year,
               data = final.data)

ub_models <- list(fe_base, fe_social, fe_econ, fe_control, fe_year)
ub_numbers <- give.number(ub_models)
ub_models <- lapply(ub_models, se.correct)

rm(fe_violent, fe_property, fe_drugposs, fe_total, final.data)
