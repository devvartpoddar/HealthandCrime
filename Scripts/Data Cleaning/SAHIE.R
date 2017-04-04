# Cleaning SAHIE dataset

# Setting SAHIE data path
health.path <- 'Raw Data/SAHIE'

health.csv <- list.files(health.path)

final.data <- NULL
for (x in 1:length(health.csv)) {
  # Reading the data and keeping only county level data
  temp.data <- read.csv(paste(health.path, health.csv[x], sep = '/'),
    row.names = NULL, skip = 79) %>%
    filter(geocat == 50) %>%
    # Keeping only for all age + race + sex etc for nows
    mutate(total = agecat + racecat + sexcat + iprcat) %>%
    filter(total == 0) %>%
    select(-total)

  final.data %<>% plyr::rbind.fill(temp.data)
  rm(temp.data)
}

# Exporting the dataset
export(final.data, "Data/SAHIE-data.json")
