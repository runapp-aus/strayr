# Clean ASCED

library(tidyverse)
library(glue)


# include factor variants or nah?
include_factor_variants <- FALSE

# fun for captial -> title case
to_title <- function(x) str_to_title(x) %>% tools::toTitleCase()


asced_url <- "https://www.abs.gov.au/AUSSTATS/subscriber.nsf/log?openagent&1272.0%20australian%20standard%20classification%20of%20education%20(asced)%20structures.xls&1272.0&Data%20Cubes&B286FC6C1777688DCA257ECB001657BC&0&2001&29.09.2015&Latest"


temp_dir <- tempdir()
temp_path <- glue("{temp_dir}/asced.zip")

download.file(asced_url, temp_path)

# Read long list
raw <- readxl::read_excel(temp_path,
                          sheet = 3,
                          range = "A8:D446",
                          col_names = FALSE) %>%
  janitor::clean_names()

# Extract each level:
foe2 <- raw %>%
  filter(!is.na(x1)) %>%
  select(foe2_code = 1,
         foe2 = 2) %>%
  mutate(foe2_code = as.character(foe2_code))


foe4 <- raw %>%
  mutate(x2 = to_title(x2)) %>%
  anti_join(foe2, by = c("x2" = "foe2")) %>%
  filter(!is.na(x2)) %>%
  select(foe4_code = 2,
         foe4 = 3) %>%
  mutate(foe2_code = substr(foe4_code, 1, 2))


foe6 <- raw %>%
  anti_join(foe2, by = c("x2" = "foe2")) %>%
  anti_join(foe4, by = c("x3" = "foe4")) %>%
  filter(!is.na(x3)) %>%
  select(foe6_code = 3,
         foe6 = 4) %>%
  mutate(foe4_code = substr(foe6_code, 1, 4),
         foe2_code = substr(foe4_code, 1, 2))


# Join into wide ascedupation list
comb <- foe2 %>%
  left_join(foe4) %>%
  left_join(foe6) %>%
  mutate(foe2 = to_title(foe2)) # "Natural and Physical Sciences"


# Get ", nfd"
nfd2 <- comb %>%
  select(foe2_code, foe2) %>%
  distinct() %>%
  mutate(foe4 = glue("{foe2}, nfd"),
         foe4_code = glue("{foe2_code}00"),
         foe6 = glue("{foe2}, nfd"),
         foe6_code = glue("{foe2_code}0000"))

nfd4 <- comb %>%
  select(foe2_code, foe2, foe4_code, foe4) %>%
  distinct() %>%
  mutate(foe6 = glue("{foe4}, nfd"),
         foe6_code = glue("{foe4_code}00"))


asced_foe <- bind_rows(comb, nfd2, nfd4) %>%
  arrange(foe2_code, foe4_code, foe6_code) %>%
  mutate(across(.fns = as.character))

if (include_factor_variants) {
  asced_foe <- asced_foe %>%
    mutate(foe2_f = fct_inorder(foe2),
           foe4_f = fct_inorder(foe4),
           foe6_f = fct_inorder(foe6)) %>%
  select(foe2_code, foe2, foe2_f,
         foe4_code, foe4, foe4_f,
         foe6_code, foe6, foe6_f)
}


# Export
usethis::use_data(asced_foe, overwrite = TRUE)
