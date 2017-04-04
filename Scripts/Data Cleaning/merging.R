# Merging Files
rm(list = ls())

# Loading datasets
crime.data <- import('Data/Crime-data.json') %>%
  filter(year >= 2006)

health.data <- import('Data/SAHIE-data.json') %>%
  select(-version) %>%
  mutate_at(vars(-matches("name")),  funs(as.numeric)) %>%
  mutate_at(vars(matches("name")), funs(tolower)) %>%
  mutate_at(vars(matches("name")), funs(trimws))

income.data <- import('Data/SAPIE-data.json')

# Merging dataset
final.data <- merge(crime.data, health.data,
    by.x = c('year', 'FIPS_ST', 'FIPS_CTY'),
    by.y = c('year', 'statefips', 'countyfips'),
    all = T) %>%
  merge(income.data, by = c('year', 'FIPS_ST', 'FIPS_CTY'),
    all = T) %>%
  mutate(UID = 1000 * FIPS_ST + FIPS_CTY) %>%
  # Creating unique State County ID
  select(UID, year, everything()) %>%
  select(-STUDYNO, -EDITION, -PART) %>%
  select(-matches("_moe")) %>%
  arrange(UID) %>%
  select(-state_name.x, - county_name.x) %>%
  rename(state_name = state_name.y, county_name = county_name.y)

export(final.data, 'Data/merged-data.json')
