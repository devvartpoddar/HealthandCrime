# Rscript for cleaning and getting crime data

# List of files
crime.path <- 'Raw Data/Crime Data/'

crime.zip <- list.files(crime.path, pattern = ".zip")

# fwf widths
fwf <- import('Raw Data/fwf_widths.xlsx')

# Unzipping files and rbinding
final.data <- NULL
for (x in 1:length(crime.zip)) {
  # Extracting the year
  temp.year <- crime.zip[x] %>% stri_split_fixed('.zip') %>%
    unlist() %>% .[1] %>% as.numeric()
  
  cat("starting year ---------- ", temp.year, "\n")

  # Creating temporary dir to extract the data
  temp.dir <- paste0(crime.path, 'tmp')
  unzip(paste0(crime.path, crime.zip[x]), exdir = temp.dir)

  # Listing dirs to get the innermost dir
  dirs <- list.dirs(temp.dir)

  # Need to list the file in the final dir
  data.path <- list.files(dirs[3])

  temp.data <- import(paste(dirs[3], data.path, sep = "/"))

  if (ncol(temp.data) < 30) {
    temp.data <- read.fwf(paste(dirs[3], data.path, sep = "/"),
      fwf$width)

    colnames(temp.data) <- fwf$var
  }

  temp.data %<>%
    mutate(year = temp.year) %>%
    select(year, everything())

  final.data %<>% plyr::rbind.fill(temp.data)

  # Removing tmp dir
  unlink(paste0(crime.path, '/tmp'), recursive = T)
  rm(temp.dir, temp.year, dirs, data.path, temp.data)
}

# Exporting the dataset
export(final.data, "Data/Crime-data.json")
