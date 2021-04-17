# Clean ASCED qual

library(tidyverse)
library(glue)


asced_url <- "https://www.abs.gov.au/AUSSTATS/subscriber.nsf/log?openagent&1272.0%20australian%20standard%20classification%20of%20education%20(asced)%20structures.xls&1272.0&Data%20Cubes&B286FC6C1777688DCA257ECB001657BC&0&2001&29.09.2015&Latest"


temp_dir <- tempdir()
temp_path <- glue("{temp_dir}/asced.zip")

download.file(asced_url, temp_path)

# Read long list
raw <- readxl::read_excel(temp_path,
                          sheet = 2,
                          range = "A8:D95",
                          col_names = FALSE) %>%
  janitor::clean_names()

# Extract each level:
qual1 <- raw %>%
  filter(!is.na(x1)) %>%
  select(qual1_code = 1,
         qual1 = 2) %>%
  mutate(qual1_f = str_to_title(qual1),       # "Natural And Physical Sciences"
         qual1_f = tools::toTitleCase(qual1_f),
         qual1_f = as_factor(qual1_f),
         qual1_code = as.character(qual1_code))

qual2 <- raw %>%
  anti_join(qual1, by = c("x2" = "qual1")) %>%
  filter(!is.na(x2)) %>%
  select(qual2_code = 2,
         qual2 = 3) %>%
  mutate(qual2_f = as_factor(qual2),
         qual1_code = substr(qual2_code, 1, 1))

qual3 <- raw %>%
  anti_join(qual1, by = c("x2" = "qual1")) %>%
  anti_join(qual2, by = c("x3" = "qual2")) %>%
  filter(!is.na(x3)) %>%
  select(qual3_code = 3,
         qual3 = 4) %>%
  mutate(qual3_f = as_factor(qual3),
         qual2_code = substr(qual3_code, 1, 2),
         qual1_code = substr(qual2_code, 1, 1))


# Join into wide ascedupation list
asced_qual <- qual1 %>%
  left_join(qual2) %>%
  left_join(qual3) %>%
  mutate(qual1 = str_to_title(qual1),       # "Natural And Physical Sciences"
         qual1 = tools::toTitleCase(qual1)) # "Natural and Physical Sciences"


# Export
usethis::use_data(asced_qual, overwrite = TRUE)
