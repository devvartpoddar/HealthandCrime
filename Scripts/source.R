# Source file for cleaning and merging data

# Setting working directory
try(setwd("/home/devvart/Dropbox/Hertie/HealthandCrime"))

source('packages.R')

# Cleaning and exporting crime dataset
# source('Scripts/Data Cleaning/Crime.R')

# Cleaning and exporting health dataset
source('Scripts/Data Cleaning/SAHIE.R')

# Cleaning and exporting income dataset
source('Scripts/Data Cleaning/SAPIE.R')

# Cleaning and exporting employment dataset
source('Scripts/Data Cleaning/unemplyoment.R')

# Merging datasetst
source('Scripts/Data Cleaning/merging.R')
