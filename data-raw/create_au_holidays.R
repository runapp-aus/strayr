library(ckanr)
library(tidyverse)
library(stringr)
library(lubridate)

# --- Historical data from CKAN (up to 2025) ---
ckanr_setup(url = "https://data.gov.au/data")

package <- package_show("australian-holidays-machine-readable-dataset")

ckan_data <- package$resources %>%
  map(function(x) {
    x[["url"]]
  }) %>%
  unlist() %>%
  map(read_csv) %>%
  list_rbind() %>%
  dplyr::filter(!is.na(Date)) %>%
  transmute(
    Date = ymd(Date),
    Name = coalesce(`Holiday Name`),
    Jurisdiction = coalesce(`Applicable To`, Jurisdiction),
    Jurisdiction = str_to_upper(Jurisdiction)
  )

# --- Supplementary data from government sources (2026+) ---
# Compiled from state/territory government websites.
# To update, see data-raw/scrape_au_holidays.R
supplement <- read_csv("data-raw/au_holidays_supplement.csv") %>%
  transmute(
    Date = ymd(Date),
    Name = `Holiday Name`,
    Jurisdiction = str_to_upper(Jurisdiction)
  )

# Combine, keeping only supplement rows for years not in CKAN
ckan_max_year <- max(year(ckan_data$Date), na.rm = TRUE)
supplement_new <- supplement %>%
  dplyr::filter(year(Date) > ckan_max_year)

auholidays <- bind_rows(ckan_data, supplement_new) %>%
  distinct() %>%
  arrange(Date, Jurisdiction)

usethis::use_data(auholidays, internal = FALSE, overwrite = TRUE)
