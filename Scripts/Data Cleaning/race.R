# Script to clean data for racial composition of counties

## NOTE: This is a standalone script. Need to import the race datasets
## Add in race.path as input, and output path.

# Intialisation
rm(list = ls())
pkgs <- c('dplyr', 'magrittr', 'methods', 'rvest', 'stringi', 'rio', 'gmailr', 'tidyr')

for (p in pkgs) {
  load <- require(p, character.only = T, quietly = T)

  if (!load) {
    install.packages(p)
    require(p, character.only = T, quietly = T)
  }
}
rm(pkgs)
# Setting working directory
try(setwd("/home/devvart"))

# Setting up mail capabilities
## Copy mail settings
file.copy('~/Dropbox/.httr-oauth', '.', overwrite = TRUE)

## Force authentication
use_secret_file('~/Dropbox/gmail_outh.json')
gmail_auth()

# Setting paths
race.path <- "us.1990_2015.19ages.adjusted.txt"

output.path <- "~/Dropbox/Hertie/HealthandCrime/Data/race_all_ages.json"
output.xlsx <- "~/Dropbox/race_voters.xlsx"

# Importing race data with widths
race.data <- read.fwf(race.path, widths = c(4, 2, 2, 3, 2, 1, 1, 1, 2, 8),
  colClasses = "character")

colnames(race.data) <- c('year', 'state', 'statefips', 'countyfips', 'registry', 'race',
  'origin', 'sex', 'age', 'population')

race.cat <- data.frame(
  race = c(1:3),
  race.cat = c("white", "black", "other")
  )

# For all ages
clean.data <- race.data %>%
  filter(origin != '9') %>%
  select(-registry, -origin) %>%
  mutate_at(vars(matches("fips|year|race|sex|age|pop")),
    funs(as.numeric)) %>%
  mutate(race = ifelse(race >= 3, 3, race)) %>%
  group_by(statefips, countyfips, year, race) %>%
  summarise(population = sum(population)) %>%
  merge(race.cat) %>%
  select(-race) %>%
  mutate(FIPS = 1000 * statefips + countyfips) %>%
  arrange(FIPS, year) %>%
  spread(race.cat, population)

export(clean.data, output.path)

# Only voters
clean.data <- race.data %>%
  filter(origin != '9') %>%
  select(-registry, -origin) %>%
  mutate_at(vars(matches("fips|year|race|sex|age|pop")),
    funs(as.numeric)) %>%
  filter(age >= 5) %>%
  mutate(race = ifelse(race >= 3, 3, race)) %>%
  group_by(statefips, countyfips, year, race) %>%
  summarise(population = sum(population)) %>%
  merge(race.cat) %>%
  select(-race) %>%
  mutate(FIPS = 1000 * statefips + countyfips) %>%
  arrange(FIPS, year) %>%
  spread(race.cat, population)

export(clean.data, output.xlsx)

# Writing mail
mime() %>%
  to('devvart123@gmail.com') %>%
  from('devvart.server@gmail.com') %>%
  cc('') %>%
  subject('[R:Server]: Race Data completed') %>%
  text_body('Race Data is done! Check your dropbox') %>%
  send_message()