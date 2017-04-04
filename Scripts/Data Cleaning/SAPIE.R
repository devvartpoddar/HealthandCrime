# Cleaning SAPIE dataset

# Setting SAHIE data path
income.path <- 'Raw Data/SAPIE'

income.csv <- list.files(income.path)

final.data <- NULL
for (x in 1:length(income.csv)) {
  # Identifying the year
  temp.year <- stri_split_regex(income.csv[x], "est|ALL.xls") %>%
    unlist() %>% as.numeric() %>% {.[!is.na(.)]} %>%
    {2000 + .}

  if (temp.year >= 2013) {
    temp.skip = 3
  } else {
    temp.skip = 2
  }

  # Importing dataset
  temp.data <- import(paste(income.path, income.csv[x], sep = '/'),
    skip = temp.skip)
  # Removing duplicaed columns
  # NOTE: Ideally should be more careful,
  # But in this case it does not matter
  rm(temp.skip)
  # Removing code from all the col names
  temp.names <- colnames(temp.data) %>%
    stri_replace_all_regex("Code|in Families", "") %>%
    stri_replace_all_fixed(",", "") %>%
    stri_replace_all_fixed("Under Age 18", "Age 0-17") %>%
    stri_replace_all_fixed("Ages", "Age") %>%
    trimws()

  colnames(temp.data) <- temp.names

  temp.data <- temp.data[, !duplicated(temp.names)] %>%
    select(-matches("%")) %>% # Removing all the CIs
    select(-matches("0-4")) %>%
    filter(!is.na(Name)) %>%
    rename(FIPS_ST = `State FIPS`, FIPS_CTY = `County FIPS`,
      state_name = Postal, county_name = Name,
      MedianIncome = `Median Household Income`) %>%
    mutate(FIPS_ST = as.numeric(FIPS_ST),
      FIPS_CTY = as.numeric(FIPS_CTY),
      year = temp.year) %>%
    filter(FIPS_CTY != 0) %>%
    mutate_at(vars(matches("name")), funs(tolower))

  final.data %<>% plyr::rbind.fill(temp.data)
}

export(final.data, "Data/SAPIE-data.json")
