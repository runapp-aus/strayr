
# Reading and cleaning ANZSIC correspondence

library(tidyverse)
library(glue)

# include factor variants or nah?
include_factor_variants <- FALSE

# ty asiripanich
anzsic_url <- "https://raw.githubusercontent.com/asiripanich/anzsic/master/anzsic_2006.csv"

temp_dir <- tempdir()
temp_path <- glue("{temp_dir}/anzsic.csv")

download.file(anzsic_url, temp_path)

# Read
anzsic_raw <- read_csv(temp_path) %>%
    rename_all(~ glue("anzsic_{.}")) %>%
    mutate_if(is.double, as.integer) %>%
    as_tibble()

# Add layers of nfd
class_nfd <- anzsic_raw %>%
  distinct(anzsic_division_title, anzsic_division_code,
           anzsic_subdivision_title, anzsic_subdivision_code,
           anzsic_group_title, anzsic_group_code) %>%
  mutate(anzsic_class_code = anzsic_group_code * 10,
         anzsic_class_title = glue("{anzsic_group_title}, nfd"))

group_nfd <- anzsic_raw %>%
  distinct(anzsic_division_title, anzsic_division_code,
           anzsic_subdivision_title, anzsic_subdivision_code) %>%
  mutate(anzsic_group_title = glue("{anzsic_subdivision_title}, nfd"),
         anzsic_group_code = anzsic_subdivision_code * 10,
         anzsic_class_title = anzsic_group_title,
         anzsic_class_code = anzsic_group_code * 10)

subdivision_nfd <- anzsic_raw %>%
  group_by(anzsic_division_code, anzsic_division_title) %>%
  summarise(anzsic_subdivision_code = min(anzsic_subdivision_code)) %>%
  mutate(anzsic_subdivision_title = glue("{anzsic_division_title}, nfd"),
         anzsic_group_title = anzsic_subdivision_title,
         anzsic_group_code = anzsic_subdivision_code * 10,
         anzsic_class_title = anzsic_group_title,
         anzsic_class_code = anzsic_group_code * 10)

# Finalise data frame; noting that we are avoiding the nfd complication for now
anzsic2006 <- anzsic_raw %>%
  arrange(anzsic_division_code,
          anzsic_subdivision_code,
          anzsic_group_code,
          anzsic_class_code) %>%
  mutate(across(.fns = as.character))

if (include_factor_variants) {
  anzsic2006 <- anzsic2006 %>%
    mutate(across(ends_with("title"), fct_inorder, .names = "{.col}_f"))
}

anzsic2006 <- anzsic %>%
  rename_with(~ str_remove_all(., "\\_title"), everything()) %>%
  arrange(anzsic_division_code,
          anzsic_subdivision_code,
          anzsic_group_code,
          anzsic_class_code)


anzsic_dictionary <- make_dictionary(anzsic2006)

# Export
usethis::use_data(anzsic2006, overwrite = TRUE)
