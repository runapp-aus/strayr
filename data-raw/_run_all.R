# Run all files in data-raw

files <- list.files("data-raw", pattern = ".R$")
files <- files[!stringr::str_detect(files, "_run_all")]

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
