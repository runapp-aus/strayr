# Run all files in data-raw

files <- list.files("data-raw")
files <- files[!stringr::str_detect(files, "_run_all")]

purrr::map(glue::glue("data-raw/{files}"),
           source)
