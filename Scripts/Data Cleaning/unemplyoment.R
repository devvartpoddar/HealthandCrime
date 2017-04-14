# Rscript for cleaning and getting unemployment data

# List of files
labour.path <- 'Raw Data/Labour Force/'

labour.xlsx <- list.files(labour.path)

final.data <- NULL
for (x in 1:length(labour.xlsx)) {
  # Importing the dataset
  temp.data <- import(paste(labour.path, labour.xlsx[x], sep = "/"), skip = 3)

  colnames(temp.data) <- c("remove", "statefips", "countyfips", "county_name", "year",
    "blank", "labour_force", "employed", "unemployed", "unemployed_pct")

  final.data  <- temp.data %>%
    select(-remove, -blank) %>%
    filter(!is.na(year)) %>%
    mutate_at(vars(-matches("name")), funs(as.numeric)) %>%
    mutate(year = as.numeric(year)) %>%
    rbind(final.data)
}

export(final.data, "Data/unemployment.json")
