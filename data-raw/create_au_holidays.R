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
  map(read_csv) %>%
  list_rbind()

auholidays <- raw_data %>%
  dplyr::filter(!is.na(Date)) %>% # 'Friday before the AFL Grand Final' not given a date in VIC holiday data
  transmute(
    Date = ymd(Date),
    Name = coalesce(`Holiday Name`),
    Jurisdiction = coalesce(`Applicable To`, Jurisdiction),
    Jurisdiction = str_to_upper(Jurisdiction)
  ) |>
  distinct()

usethis::use_data(auholidays, internal = FALSE, overwrite = TRUE)
