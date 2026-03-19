# Run all files in data-raw

# Scrape latest holiday data before building the dataset
source("data-raw/scrape_au_holidays.R")

files <- list.files("data-raw", pattern = ".R$")
files <- files[!stringr::str_detect(files, "_run_all|scrape_au_holidays")]

purrr::walk(glue::glue("data-raw/{files}"),
           source)

#save internal only datasets
usethis::use_data(anzsco_dictionary,
                  anzsic_dictionary,
                  asced_foe_dictionary,
                  asced_qual_dictionary,
                  state_dict,
                  state_table,
                  internal = TRUE, overwrite = TRUE)

usethis::use_data(palette_state_name_2016,
                  state_name_au,
                  state_abb_au,
                  overwrite = TRUE)
