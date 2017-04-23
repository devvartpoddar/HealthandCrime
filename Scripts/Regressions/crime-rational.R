# File to explore regressions

# Load data
final.data <- import('Data/merged-data.json')  %>%
  arrange(UID, year) %>%
  select(-iprcat) %>%
  mutate_at(vars(matches("TOT|NUI|CPOPARST|Median|black|unemployed|P1")),
            funs(log))

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
  coeftest(x, vcovHC)
}

# Running the different models
# Regressions
fe_violent <- plm(P1VLNT ~ NUI + CPOPARST + blacks_and_hispanics + 
                    MedianIncome + unemployed + year,
                  data = final.data)

fe_property <- plm(P1PRPTY ~ NUI + CPOPARST + blacks_and_hispanics + 
                     MedianIncome + unemployed,
                   data = final.data)

fe_drugposs <- plm(GRNDTOT ~ NUI + CPOPARST + blacks_and_hispanics + 
                     MedianIncome + unemployed,
                   data = final.data)

fe_total <- plm(DRUGTOT ~ NUI + CPOPARST + blacks_and_hispanics + 
                     MedianIncome + unemployed,
                   data = final.data)

rc_models <- list(fe_violent, fe_property, fe_drugposs, fe_total)
rc_numbers <- give.number(rc_models)
rc_models <- lapply(rc_models, se.correct)

rm(fe_violent, fe_property, fe_drugposs, fe_total, final.data)
