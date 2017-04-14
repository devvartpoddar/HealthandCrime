# Source file for cleaning and merging data

# Intialisation
rm(list = ls())
pkgs <- c('dplyr', 'magrittr', 'methods', 'rvest', 'stringi', 'rio', 'gmailr', 'plm')

for (p in pkgs) {
  load <- require(p, character.only = T, quietly = T)

  if (!load) {
    install.packages(p)
    require(p, character.only = T, quietly = T)
  }
}
rm(pkgs)
# Setting working directory
try(setwd("/home/devvart/Dropbox/Hertie/HealthandCrime"))

# Cleaning and exporting crime dataset
# source('Scripts/Data Cleaning/Crime.R')

# Cleaning and exporting health dataset
source('Scripts/Data Cleaning/SAHIE.R')

# Cleaning and exporting income dataset
source('Scripts/Data Cleaning/SAPIE.R')

# Merging datasetst
source('Scripts/Data Cleaning/merging.R')
