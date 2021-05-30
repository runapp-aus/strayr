# Reading and cleaning ANZSCO correspondence

library(tidyverse)
library(glue)
devtools::load_all()

# include factor variants or nah?
include_factor_variants <- FALSE

# fun for captial -> title case
to_title <- function(x) str_to_title(x) %>% tools::toTitleCase()

# Set up
anzsco_url <- "https://www.abs.gov.au/ausstats/subscriber.nsf/log?openagent&1220.0%20ANZSCO%20Version%201.2%20Structure%20v3.xls&1220.0&Data%20Cubes&6A8A6C9AC322D9ABCA257B9E0011956C&0&2013,%20Version%201.2&05.07.2013&Latest"

temp_dir <- tempdir()
temp_path <- glue("{temp_dir}/anzsco.xls")

download.file(anzsco_url, temp_path, mode = "wb")

# Read
raw <- readxl::read_excel(temp_path,
                          sheet = 6,
                          range = "A11:G1555",
                          col_names = FALSE) %>%
  janitor::clean_names()

# Extract each level:
anzsco1 <- raw %>%
  filter(!is.na(x1)) %>%
  select(anzsco1_code = 1,
         anzsco1 = 2) %>%
  mutate(anzsco1_code = as.character(anzsco1_code))

anzsco2 <- raw %>%
  anti_join(anzsco1, by = c("x2" = "anzsco1")) %>%
  filter(!is.na(x2)) %>%
  select(anzsco2_code = 2,
         anzsco2 = 3) %>%
  mutate(anzsco1_code = substr(anzsco2_code, 1, 1))

anzsco3 <- raw %>%
  anti_join(anzsco1, by = c("x2" = "anzsco1")) %>%
  anti_join(anzsco2, by = c("x3" = "anzsco2")) %>%
  filter(!is.na(x3)) %>%
  select(anzsco3_code = 3,
         anzsco3 = 4) %>%
  mutate(anzsco2_code = substr(anzsco3_code, 1, 2),
         anzsco1_code = substr(anzsco2_code, 1, 1))

anzsco4 <- raw %>%
  anti_join(anzsco1, by = c("x2" = "anzsco1")) %>%
  anti_join(anzsco2, by = c("x3" = "anzsco2")) %>%
  anti_join(anzsco3, by = c("x4" = "anzsco3")) %>%
  filter(!is.na(x4)) %>%
  select(anzsco4_code = 4,
         anzsco4 = 5) %>%
  mutate(anzsco3_code = substr(anzsco4_code, 1, 3),
         anzsco2_code = substr(anzsco3_code, 1, 2),
         anzsco1_code = substr(anzsco2_code, 1, 1))

anzsco6 <- raw %>%
  anti_join(anzsco1, by = c("x2" = "anzsco1")) %>%
  anti_join(anzsco2, by = c("x3" = "anzsco2")) %>%
  anti_join(anzsco3, by = c("x4" = "anzsco3")) %>%
  anti_join(anzsco4, by = c("x5" = "anzsco4")) %>%
  filter(!is.na(x5)) %>%
  select(anzsco6_code = 5,
         anzsco6 = 6,
         skill_level = 7) %>%
  mutate(anzsco4_code = substr(anzsco6_code, 1, 4),
         anzsco3_code = substr(anzsco4_code, 1, 3),
         anzsco2_code = substr(anzsco3_code, 1, 2),
         anzsco1_code = substr(anzsco2_code, 1, 1))

# Join into wide anzscoupation list
comb <- anzsco1 %>%
  left_join(anzsco2) %>%
  left_join(anzsco3) %>%
  left_join(anzsco4) %>%
  left_join(anzsco6) %>%
  mutate(anzsco1 = to_title(anzsco1))


# Generate ', nfd' variants, which are used in eg Census
nfd1 <- comb %>%
  select(anzsco1_code, anzsco1) %>%
  distinct() %>%
  mutate(anzsco2 = glue("{anzsco1}, nfd"),
         anzsco2_code = glue("{anzsco1_code}0"),
         anzsco3 = glue("{anzsco1}, nfd"),
         anzsco3_code = glue("{anzsco1_code}00"),
         anzsco4 = glue("{anzsco1}, nfd"),
         anzsco4_code = glue("{anzsco1_code}000"),
         anzsco6 = glue("{anzsco1}, nfd"),
         anzsco6_code = glue("{anzsco1_code}00000"))

nfd2 <- comb %>%
  select(anzsco1_code, anzsco1, anzsco2_code, anzsco2) %>%
  distinct() %>%
  mutate(anzsco3 = glue("{anzsco2}, nfd"),
         anzsco3_code = glue("{anzsco2_code}0"),
         anzsco4 = glue("{anzsco2}, nfd"),
         anzsco4_code = glue("{anzsco2_code}00"),
         anzsco6 = glue("{anzsco2}, nfd"),
         anzsco6_code = glue("{anzsco2_code}0000"))


nfd3 <- comb %>%
  select(anzsco1_code, anzsco1, anzsco2_code, anzsco2, anzsco3_code, anzsco3) %>%
  distinct() %>%
  mutate(anzsco4 = glue("{anzsco3}, nfd"),
         anzsco4_code = glue("{anzsco3_code}0"),
         anzsco6 = glue("{anzsco3}, nfd"),
         anzsco6_code = glue("{anzsco3_code}000"))

anzsco <- comb %>%
  bind_rows(nfd1, nfd2, nfd3) %>%
  arrange(anzsco1_code, anzsco2_code, anzsco3_code,
          anzsco4_code, anzsco6_code) %>%
  mutate(across(.fns = as.character)) %>%
  arrange(anzsco6_code)

if (include_factor_variants) {
  anzsco <- anzsco %>%
    mutate(
      anzsco1_f = as_factor(anzsco1),
      anzsco2_f = as_factor(anzsco2),
      anzsco3_f = as_factor(anzsco3),
      anzsco4_f = as_factor(anzsco4),
      anzsco6_f = as_factor(anzsco6),
      skill_level = as_factor(skill_level)) %>%
    # order
    select(anzsco1_code, anzsco1, anzsco1_f,
           anzsco2_code, anzsco2, anzsco2_f,
           anzsco3_code, anzsco3, anzsco3_f,
           anzsco4_code, anzsco4, anzsco4_f,
           anzsco6_code, anzsco6, anzsco6_f,
           skill_level)

}

# Rename using new conventions: https://github.com/runapp-aus/abscorr/issues/17
anzsco <- anzsco %>%
  rename(
    anzsco_major = anzsco1,
    anzsco_major_code = anzsco1_code,
    anzsco_submajor = anzsco2,
    anzsco_submajor_code = anzsco2_code,
    anzsco_minor = anzsco3,
    anzsco_minor_code = anzsco3_code,
    anzsco_unit = anzsco4,
    anzsco_unit_code = anzsco4_code,
    anzsco_occupation = anzsco6,
    anzsco_occupation_code = anzsco6_code
  )

anzsco_dictionary <- make_dictionary(anzsco)


# Export
usethis::use_data(anzsco, overwrite = TRUE)
