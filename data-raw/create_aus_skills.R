# Reading and cleaning the Australian Skills Classification
# see: https://www.nationalskillscommission.gov.au/australian-skills-classification-resources

library(tidyverse)
library(glue)
devtools::load_all()

# include factor variants or nah?
include_factor_variants <- FALSE

# fun for captial -> title case
to_title <- function(x) str_to_title(x) %>% tools::toTitleCase()

# Set up
asc_url <- "https://www.nationalskillscommission.gov.au/sites/default/files/2021-03/Australian%20Skills%20Classification%2012-03-2021.xlsx"

temp_dir <- "data-raw/raw-data"
temp_path <- glue("{temp_dir}/asc.xlsx")

download.file(asc_url, temp_path, mode = "wb")

tidy_acs <- function(.data) {
  .data %>%
    janitor::clean_names() %>%
    rename_with(~ str_replace(.x, "title", "name")) %>%
    rename_with(~ str_replace(.x, "_desc", "_description")) %>%
    mutate(across(contains("anzsco_code"), as.character),
           across(contains("tech_tool_ranking"), as.integer))
}

# Read and tidy
asc_descriptions <- readxl::read_excel(temp_path, sheet = 2) %>%
  tidy_acs()

asc_core_competencies <- readxl::read_excel(temp_path, sheet = 3) %>%
  tidy_acs()

asc_core_competency_descriptions <- readxl::read_excel(temp_path, sheet = 4) %>%
  tidy_acs()

asc_specialist_tasks <- readxl::read_excel(temp_path, sheet = 5) %>%
  tidy_acs()

asc_technology_tools <- readxl::read_excel(temp_path, sheet = 6) %>%
  tidy_acs()

asc_technology_tools_ranking <- readxl::read_excel(temp_path, sheet = 7) %>%
  tidy_acs()


# Export
usethis::use_data(asc_descriptions,
                  asc_core_competencies,
                  asc_core_competency_descriptions,
                  asc_specialist_tasks,
                  asc_technology_tools,
                  asc_technology_tools_ranking,
                overwrite = TRUE)
