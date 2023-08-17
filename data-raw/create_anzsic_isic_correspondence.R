
# Reading and cleaning ANZSIC correspondence

library(tidyverse)
library(rvest)

# include factor variants or nah?
include_factor_variants <- FALSE

# fetch from abs website
url <- "https://www.abs.gov.au/statistics/classifications/australian-and-new-zealand-standard-industrial-classification-anzsic/2006-revision-2-0/correspondences/anzsic-2006-isic-rev-4"

df <- url %>%
  rvest::read_html() %>%
  rvest::html_table()

# bind tables together
anzsic_isic_temp <-
  purrr::list_rbind(df) %>%
  rename(anzsic_class_code = 2,
         anzsic_class_title = 3,
         isic_class_code = 4,
         isic_title = 5) %>%
  select(2:5)

anzsic_isic_temp[anzsic_isic_temp == ""] <- NA

anzsic_isic_temp <- anzsic_isic_temp %>%
  filter(!is.na(isic_class_code))

anzsic_isic_fill <-
  anzsic_isic_temp %>%
  tidyr::fill(colnames(anzsic_isic_temp), .direction = c("down")) %>%
  filter(stringr::str_detect(anzsic_class_code, "^[:digit:]+$"))


# Finalise data frame; noting that we are avoiding the nfd complication for now
anzsic_isic <- anzsic_isic_fill %>%
  arrange(anzsic_class_code,
          isic_class_code) %>%
  mutate(across(.fns = as.character))

if (include_factor_variants) {
  anzsic_isic <- anzsic_isic %>%
    mutate(across(ends_with("title"), fct_inorder, .names = "{.col}_f"))
}

anzsic_isic <- anzsic_isic  %>%
  rename_with(~ str_remove_all(., "\\_title"), everything()) %>%
  arrange(anzsic_class_code,
          isic_class_code)


anzsic_isic_dictionary <- make_dictionary(anzsic_isic)

# Export
usethis::use_data(anzsic_isic, overwrite = TRUE)
