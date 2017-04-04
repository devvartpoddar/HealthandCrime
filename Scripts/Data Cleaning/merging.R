# Merging Files
rm(list = ls())

# Loading datasets
crime.data <- import('Data/Crime-data.json')

health.data <- import('Data/SAHIE-data.json') %>%
  select(-state_name, -county_name, -version) %>%
  mutate_all(funs(as.numeric))

# Merging dataset
final.data <- merge(crime.data, health.data,
    by.x = c('year', 'FIPS_ST', 'FIPS_CTY'),
    by.y = c('year', 'statefips', 'countyfips')) %>%
  mutate(UID = 1000 * FIPS_ST + FIPS_CTY) %>%
  # Creating unique State County ID
  select(UID, year, everything()) %>%
  arrange(UID)

export(final.data, 'Data/merged-data.json')
