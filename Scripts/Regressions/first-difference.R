# File to explore regressions

# Load data
sum.data <- data.frame(
  year = 2011:2014,
  fd = c(0, 0, 1, 1)
)

fd.data <- import('Data/merged-data.json')  %>%
  arrange(UID, year) %>%
  select(-iprcat) %>%
  filter(year >= 2011, year < 2015) %>%
  merge(sum.data, all = T) %>%
  group_by(UID, fd) %>%
  summarise_all(funs(mean)) %>%
  mutate(year = floor(year)) %>%
  arrange(UID, year) %>%
  mutate_at(vars(matches("TOT|NUI|CPOPARST|Median|black|unemployed|P1")),
            funs(log)) %>%
  select(-fd) %>%
  mutate(urban = factor(urban, levels = 1:6))

# Cleaning up infinity values
is.na(fd.data) <- do.call(cbind,lapply(fd.data, is.infinite))

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

# Regressions
fd_base <- plm(GRNDTOT ~ -1 + NUI + CPOPARST,
               data = fd.data, model = "fd")

fd_social <- plm(GRNDTOT ~ -1 +  NUI + CPOPARST + blacks_and_hispanics,
                 data = fd.data, model = "fd")

fd_econ <- plm(GRNDTOT ~ -1 + NUI + CPOPARST + MedianIncome +
                 unemployed,
               data = fd.data, model = "fd")

fd_control <- plm(GRNDTOT ~ -1 + NUI + CPOPARST + blacks_and_hispanics + 
                    MedianIncome + unemployed,
                  data = fd.data, model = "fd")

fd_models <- list(fd_base, fd_social, fd_econ, fd_control)
fd_numbers <- give.number(fd_models)
# fd_models <- lapply(fd_models, se.correct)

rm(fd_base, fd_control, fd_year, fd.data)

fd_control <- plm(P1PRPTY ~ -1 + NUI + CPOPARST + blacks_and_hispanics + 
                    MedianIncome + unemployed,
                  data = fd.data, model = "fd")
