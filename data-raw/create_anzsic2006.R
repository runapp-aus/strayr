
# Reading and cleaning ANZSIC correspondence

library(tidyverse)
library(rvest)

# include factor variants or nah?
include_factor_variants <- FALSE

# fetch from abs website
url <- "https://www.abs.gov.au/statistics/classifications/australian-and-new-zealand-standard-industrial-classification-anzsic/2006-revision-2-0/numbering-system-and-titles/division-subdivision-group-and-class-codes-and-titles"

df <- url %>%
  rvest::read_html() %>%
  rvest::html_table()

# bind tables together
anzsic_2006_temp <-
  purrr::list_rbind(df)

# fix columns names and bind together
colnames(anzsic_2006_temp) <- c("anzsic_division_code", "anzsic_subdivision_code", "anzsic_group_code", "anzsic_class_code", "title")

first_row <-
  as.data.frame(t(colnames(df[[1]])))

colnames(first_row) <- c("anzsic_division_code", "anzsic_subdivision_code", "anzsic_group_code", "anzsic_class_code", "title")

anzsic_2006_total <-
  dplyr::bind_rows(first_row, anzsic_2006_temp)

# replace blanks with NAs
anzsic_2006_total[anzsic_2006_total == ""] <- NA

# fill NAs down from above
anzsic_2006_fill <-
  anzsic_2006_total %>%
  tidyr::fill(colnames(anzsic_2006_total), .direction = c("down"))

# get each grouping type individually
anzsic_2006_class <-
  anzsic_2006_total %>%
  dplyr::filter(stringr::str_detect(anzsic_class_code, "^[:digit:]+$")) %>%
  dplyr::select(anzsic_class_code, anzsic_class_title = title)

anzsic_2006_group <-
  anzsic_2006_total %>%
  dplyr::filter(stringr::str_detect(anzsic_group_code, "^[:digit:]+$")) %>%
  dplyr::select(anzsic_group_code, anzsic_group_title = title)

anzsic_2006_subdivision <-
  anzsic_2006_total %>%
  dplyr::filter(stringr::str_detect(anzsic_subdivision_code, "^[:digit:]+$")) %>%
  dplyr::select(anzsic_subdivision_code, anzsic_subdivision_title = title)

anzsic_2006_division <-
  anzsic_2006_total %>%
  dplyr::filter(stringr::str_detect(anzsic_division_code, "^[:alpha:]+$")) %>%
  dplyr::select(anzsic_division_code, anzsic_division_title = title)

# combine grouping types into final table
anzsic_2006_final <-
  anzsic_2006_fill %>%
  dplyr::left_join(anzsic_2006_division) %>%
  dplyr::left_join(anzsic_2006_subdivision) %>%
  dplyr::left_join(anzsic_2006_group) %>%
  dplyr::left_join(anzsic_2006_class) %>%
  dplyr::filter(!is.na(anzsic_class_title)) %>%
  dplyr::select(
    anzsic_division_code, anzsic_division_title, anzsic_subdivision_code, anzsic_subdivision_title,
    anzsic_group_code, anzsic_group_title, anzsic_class_code, anzsic_class_title
  ) %>%
  dplyr::as_tibble()

# Finalise data frame; noting that we are avoiding the nfd complication for now
anzsic2006 <- anzsic_2006_final %>%
  arrange(anzsic_division_code,
          anzsic_subdivision_code,
          anzsic_group_code,
          anzsic_class_code) %>%
  mutate(across(.fns = as.character))

if (include_factor_variants) {
  anzsic2006 <- anzsic2006 %>%
    mutate(across(ends_with("title"), fct_inorder, .names = "{.col}_f"))
}

anzsic2006 <- anzsic2006  %>%
  rename_with(~ str_remove_all(., "\\_title"), everything()) %>%
  arrange(anzsic_division_code,
          anzsic_subdivision_code,
          anzsic_group_code,
          anzsic_class_code)


anzsic_dictionary <- make_dictionary(anzsic2006)

# Export
usethis::use_data(anzsic2006, overwrite = TRUE)
