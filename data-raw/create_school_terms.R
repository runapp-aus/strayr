## code to prepare `school_terms` dataset goes here

devtools::load_all()

xls_files <- list.files(
	path = "./data-raw/school-terms-data",
	pattern = ".xlsx$",
	full.names = TRUE
)

# A function to read, clean and process a school term xlsx file
clean_terms <- function(xl) {
	# Get year from filename
	term_year <- as.integer(stringr::str_extract(xl, "\\d{4}"))

	# Read raw data
	dat_raw <- readxl::read_excel(
		path = xl,
		sheet = "STATE_school_holidays",
		range = "A2:I12",
		col_names = c("term", "nsw", "vic", "qld", "sa", "wa", "tas", "nt", "act"),
		col_types = c("text", rep("date", 8L))
	) |>
		tidyr::drop_na(term) |>
		# Tas 1998 term 4 starts in 1900.
		dplyr::mutate(across(nsw:act, ~ dplyr::na_if(.x, as.POSIXct("1899-12-31 00:00:00", tz = "UTC"))))

	# Convert wide data into long tidy data with cols state, year, term, start, end
	dat_raw |>
		tidyr::pivot_longer(nsw:act, names_to = "state", values_to = "date") |>
		dplyr::mutate(
			date = as.Date(date),
			state = clean_state(state),
			term = tolower(term)
		) |>
		tidyr::separate(term, into = c("word", "term", "phase")) |>
		dplyr::select(-word) |>
		tidyr::pivot_wider(names_from = phase, values_from = date) |>
		dplyr::mutate(
			year = term_year,
			term = dplyr::case_when(
				term == "one" ~ 1L,
				term == "two" ~ 2L,
				term == "three" ~ 3L,
				term == "four" ~ 4L
			)
		) |>
		dplyr::relocate(state, year, term, start, end)
}

# Combine into one dataframe
school_terms <- purrr::map(xls_files, clean_terms) |>
	purrr::list_rbind()

usethis::use_data(school_terms, overwrite = TRUE)
