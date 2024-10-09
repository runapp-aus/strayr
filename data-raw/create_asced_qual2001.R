# Clean ASCED qual

library(tidyverse)
library(glue)
devtools::load_all()


# include factor variants or nah?
include_factor_variants <- FALSE

# get url
asced_url <- "https://www.abs.gov.au/statistics/classifications/australian-standard-classification-education-asced/2001/1272.0%20australian%20standard%20classification%20of%20education%20%28asced%29%20structures.xlsx"


temp_dir <- tempdir()
temp_path <- glue("{temp_dir}/asced_qual.xlsx")

download.file(asced_url, temp_path, mode = "wb")

# Read long list
raw <- readxl::read_excel(temp_path,
  sheet = 2,
  range = "A8:D95",
  col_names = FALSE
) %>%
  janitor::clean_names()

# Extract each level:
qual1 <- raw %>%
  filter(!is.na(x1)) %>%
  select(
    qual1_code = 1,
    qual1 = 2
  ) %>%
  mutate(
    qual1_f = str_to_title(qual1), # "Natural And Physical Sciences"
    qual1_f = tools::toTitleCase(qual1_f),
    qual1_f = as_factor(qual1_f),
    qual1_code = as.character(qual1_code)
  )

qual2 <- raw %>%
  anti_join(qual1, by = c("x2" = "qual1")) %>%
  filter(!is.na(x2)) %>%
  select(
    qual2_code = 2,
    qual2 = 3
  ) %>%
  mutate(
    qual2_f = as_factor(qual2),
    qual1_code = substr(qual2_code, 1, 1)
  )

qual3 <- raw %>%
  anti_join(qual1, by = c("x2" = "qual1")) %>%
  anti_join(qual2, by = c("x3" = "qual2")) %>%
  filter(!is.na(x3)) %>%
  select(
    qual3_code = 3,
    qual3 = 4
  ) %>%
  mutate(
    qual3_f = as_factor(qual3),
    qual2_code = substr(qual3_code, 1, 2),
    qual1_code = substr(qual2_code, 1, 1)
  )


# Join into wide ascedupation list
asced_qual2001 <- qual1 %>%
  left_join(qual2) %>%
  left_join(qual3) %>%
  mutate(
    qual1 = str_to_title(qual1), # "Natural And Physical Sciences"
    qual1 = tools::toTitleCase(qual1)
  ) # "Natural and Physical Sciences"

if (!include_factor_variants) {
  asced_qual2001 <- asced_qual2001 %>%
    select(
      qual1_code, qual1,
      qual2_code, qual2,
      qual3_code, qual3
    )
}

asced_qual_dictionary <- make_dictionary(asced_qual2001)

# Rename using new conventions: https://github.com/runapp-aus/abscorr/issues/17
asced_qual2001 <- asced_qual2001 %>%
  rename(
    aced_qual_broad = qual1,
    aced_qual_broad_code = qual1_code,
    aced_qual_narrow = qual2,
    aced_qual_narrow_code = qual2_code,
    aced_qual_detailed = qual3,
    aced_qual_detailed_code = qual3_code
  )

# Export
usethis::use_data(asced_qual2001, overwrite = TRUE)
