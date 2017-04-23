# Merging Files
rm(list = ls())

# Loading datasets
crime.data <- import('Data/Crime-data.json') %>%
  filter(year >= 2005) %>%
  select(year, FIPS_ST, FIPS_CTY, CPOPARST,
      GRNDTOT:BURGLRY, VANDLSM, DRUGTOT,
      VAGRANT, RUNAWAY) 

health.data <- import('Data/SAHIE-data.json') %>%
  select(-version, -agecat, -racecat, -sexcat, -geocat) %>%
  mutate_at(vars(-matches("name")),  funs(as.numeric)) %>%
  mutate_at(vars(matches("name")), funs(tolower)) %>%
  mutate_at(vars(matches("name")), funs(trimws))

income.data <- import('Data/SAPIE-data.json')

unemployment.data <- import("Data/unemployment.json") %>%
  filter(year >= 2005)

# Data to recode urbanisation
recode.data <- import('Raw Data/Others/urban.xls', sheet = 3)

urban.data <- import('Raw Data/Others/urban.xls')  %>%
  select(FIPS, RUCC_2013) %>%
  mutate(FIPS = as.numeric(FIPS)) %>%
  merge(recode.data) %>%
  select(-RUCC_2013, - Description) %>%
  rename(urban = `Urban / Rural`)

race.data <- import('Data/race_all_ages.json') %>%
  filter(year >= 2005) %>%
  select(-statefips, -countyfips)

# Merging dataset
final.data <- merge(crime.data, health.data,
    by.x = c('year', 'FIPS_ST', 'FIPS_CTY'),
    by.y = c('year', 'statefips', 'countyfips'),
    all = T) %>%
  merge(income.data, by = c('year', 'FIPS_ST', 'FIPS_CTY'),
    all = T) %>%
  merge(unemployment.data,
    by.x = c('year', 'FIPS_ST', 'FIPS_CTY'),
    by.y = c('year', 'statefips', 'countyfips'),
    all = T) %>%
  mutate(UID = 1000 * FIPS_ST + FIPS_CTY) %>%
  # Creating unique State County ID
  select(UID, year, everything()) %>%
  select(-matches("_moe")) %>%
  arrange(UID, year) %>%
  select(-state_name.x, - county_name.x, -state_name.y,
      - county_name.y) %>%
  merge(urban.data, by.x = "UID", by.y = "FIPS", all = T) %>%
  merge(race.data, by.x = c("UID", 'year'),
    by.y = c("FIPS", 'year'), all.x = T) %>%
  mutate(blacks_and_hispanics = black + other) %>%
      select(-black, -white, -other)

export(final.data, 'Data/merged-data.json')

# Trial run
rm(list = ls())
