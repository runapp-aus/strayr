library(ckanr)
library(tidyverse)
library(stringr)
library(lubridate)

ckanr_setup(url = "https://data.gov.au")

package <- package_show("australian-holidays-machine-readable-dataset")

raw_data <- package$resources %>%
  map(function(x) {
    x[["url"]]
  }) %>%
  unlist() %>%
  map_dfr(read_csv)

auholidays <- raw_data %>%
  transmute(
    Date = ymd(Date),
    Name = coalesce(`Holiday Name`),
    Jurisdiction = coalesce(`Applicable To`, Jurisdiction),
    Jurisdiction = str_to_upper(Jurisdiction)
  )


usethis::use_data(auholidays, internal = FALSE, overwrite = TRUE)
