# scrape_au_holidays.R
#
# Scrapes Australian public holidays from state/territory government websites
# and appends new data to data-raw/au_holidays_supplement.csv.
#
# Usage:
#   source("data-raw/scrape_au_holidays.R")
#
# Requirements:
#   install.packages(c("rvest", "chromote"))
#   chromote requires Chrome/Chromium installed on the system.
#
# Some states (SA, TAS) block standard HTTP requests with 403 errors.
# For those, we use rvest::read_html_live() which launches a headless Chrome
# browser to render the page — bypassing bot detection.
#
# Government sources:
#   ACT: act.gov.au
#   NSW: nsw.gov.au/about-nsw/public-holidays
#   VIC: business.vic.gov.au/business-information/public-holidays
#   QLD: qld.gov.au/recreation/travel/holidays/public
#   SA:  safework.sa.gov.au/resources/public-holidays (needs headless Chrome)
#   WA:  wa.gov.au
#   TAS: worksafe.tas.gov.au (needs headless Chrome)
#   NT:  nt.gov.au/nt-public-holidays

library(rvest)
library(tidyverse)
library(lubridate)

# --- Helpers ---

# Strip footnote superscript numbers that get merged into text when scraping
clean_holiday_name <- function(name) {
  name <- str_trim(name)
  # Normalise curly/smart quotes to straight ASCII quotes
  name <- str_replace_all(name, "[\u2018\u2019\u2032]", "'")
  name <- str_replace_all(name, "[\u201C\u201D]", '"')
  # Remove anything from a parenthetical onwards (including mid-string footnotes)
  name <- str_remove(name, "\\s*\\(.*$")
  # Remove leading AND trailing digits (footnote markers)
  name <- str_remove(name, "^\\d+")
  name <- str_remove(name, "\\d+$")
  # Remove "- part day holiday" or similar suffixes
  name <- str_remove(name, "\\s*-\\s*part day.*$")
  # Remove table header artifacts from concatenated parsing
  name <- str_remove(name, "^Holiday\\s*(Date)?\\s*")
  # Standardise QLD-specific names to match other states
  name <- case_when(
    name == "The day after Good Friday" ~ "Easter Saturday",
    .default = name
  )
  str_trim(name)
}

# Parse dates like "Monday 26 January 2026" or "Friday 3 April" (with default year)
parse_holiday_date <- function(date_str, default_year = NULL) {
  date_str <- str_trim(date_str)
  # Remove day names at the start
  date_str <- str_remove(date_str, "^\\w+day,?\\s*")
  # Strip footnote digits stuck to month names (e.g. "25 April2" -> "25 April")
  date_str <- str_remove(date_str, "(?<=[A-Za-z])\\d+")
  # Try full date with year
  d <- suppressWarnings(dmy(date_str, quiet = TRUE))
  if (!is.na(d)) return(d)
  # Try with default year appended
  if (!is.null(default_year)) {
    d <- suppressWarnings(dmy(paste(date_str, default_year), quiet = TRUE))
    if (!is.na(d)) return(d)
  }
  NA_Date_
}

# Read HTML with fallback to headless Chrome for sites that block bots
read_html_safe <- function(url, use_live = FALSE) {
  if (use_live) {
    cat("  Using headless Chrome for", url, "\n")
    page <- tryCatch(
      {
        live <- read_html_live(url)
        Sys.sleep(2)
        html <- live$html_elements("body") %>% html_text2()
        live$session$close()
        read_html(live$html_elements("html")[[1]] %>% as.character())
      },
      error = function(e) {
        tryCatch({
          live <- read_html_live(url)
          Sys.sleep(2)
          txt <- live$html_elements("body") %>% html_text2()
          live$session$close()
          txt
        }, error = function(e2) {
          warning("Headless Chrome failed for ", url, ": ", e2$message)
          NULL
        })
      }
    )
    return(page)
  }

  tryCatch(
    read_html(url),
    error = function(e) {
      cat("  Standard fetch failed, retrying with headless Chrome...\n")
      read_html_safe(url, use_live = TRUE)
    }
  )
}

# Extract holiday pairs from a concatenated string like:
# "New Year's DayThursday 1 January 2026Australia DayMonday 26 January 2026..."
# Pattern: HolidayName followed by DayOfWeek DD Month YYYY
parse_concatenated_holidays <- function(text, jurisdiction) {
  # Match: (holiday name)(day-of-week date month year)
  # The holiday name is everything between dates
  matches <- str_match_all(
    text,
    "([A-Z][a-zA-Z '\\-]+?)\\s*((?:Mon|Tue|Wed|Thu|Fri|Sat|Sun)\\w*,?\\s+\\d{1,2}\\s+\\w+\\s+\\d{4})"
  )[[1]]
  if (nrow(matches) == 0) return(tibble())

  results <- list()
  for (i in seq_len(nrow(matches))) {
    holiday_name <- clean_holiday_name(matches[i, 2])
    date_str <- matches[i, 3]
    d <- parse_holiday_date(date_str)
    if (!is.na(d) && holiday_name != "" && nchar(holiday_name) > 2) {
      results <- c(results, list(tibble(
        Date = d, `Holiday Name` = holiday_name, Jurisdiction = jurisdiction
      )))
    }
  }
  bind_rows(results)
}

# --- QLD ---
# QLD has proper HTML tables with year columns — best structured source
scrape_qld <- function() {
  cat("Scraping QLD...\n")
  page <- read_html_safe("https://www.qld.gov.au/recreation/travel/holidays/public")
  if (is.null(page)) {
    warning("QLD: failed to fetch page")
    return(tibble())
  }

  tables <- html_table(page, fill = TRUE)
  results <- list()
  for (tbl in tables) {
    year_cols <- names(tbl)[str_detect(names(tbl), "^\\d{4}$")]
    if (length(year_cols) == 0) next
    holiday_col <- names(tbl)[1]
    for (yr in year_cols) {
      for (i in seq_len(nrow(tbl))) {
        holiday_name <- clean_holiday_name(tbl[[holiday_col]][i])
        date_str <- tbl[[yr]][i]
        if (is.na(holiday_name) || holiday_name == "" ||
            is.na(date_str) || date_str == "") next
        if (str_detect(str_to_lower(holiday_name), "show holidays|other show")) next
        date_parts <- str_split(date_str, "\\+|\\band\\b")[[1]]
        for (dp in date_parts) {
          dp <- str_remove(str_trim(dp), "\\(observed\\).*")
          d <- parse_holiday_date(dp, yr)
          if (!is.na(d)) {
            results <- c(results, list(tibble(
              Date = d, `Holiday Name` = holiday_name, Jurisdiction = "QLD"
            )))
          }
        }
      }
    }
  }
  out <- bind_rows(results) %>% distinct()
  if (nrow(out) == 0) warning("QLD: page fetched but no holidays parsed")
  cat("  QLD:", nrow(out), "entries\n")
  out
}

# --- NSW ---
# NSW page has a table with columns: Holiday, 2026, 2027
# html_table() concatenates the cells into a single string, so we parse that
scrape_nsw <- function() {
  cat("Scraping NSW...\n")
  page <- read_html_safe("https://www.nsw.gov.au/about-nsw/public-holidays")
  if (is.null(page)) {
    warning("NSW: failed to fetch page")
    return(tibble())
  }

  # Try html_table first — NSW has a table with Holiday/year columns
  tables <- html_table(page, fill = TRUE)
  results <- list()

  for (tbl in tables) {
    year_cols <- names(tbl)[str_detect(names(tbl), "^\\d{4}$")]
    if (length(year_cols) == 0) next
    holiday_col <- names(tbl)[!names(tbl) %in% year_cols][1]
    if (is.na(holiday_col)) next
    for (yr in year_cols) {
      for (i in seq_len(nrow(tbl))) {
        holiday_name <- clean_holiday_name(tbl[[holiday_col]][i])
        date_str <- tbl[[yr]][i]
        if (is.na(holiday_name) || holiday_name == "" ||
            is.na(date_str) || date_str == "" ||
            str_detect(date_str, "Not applicable")) next
        d <- parse_holiday_date(date_str, yr)
        if (!is.na(d) && holiday_name != "") {
          results <- c(results, list(tibble(
            Date = d, `Holiday Name` = holiday_name, Jurisdiction = "NSW"
          )))
        }
      }
    }
  }

  out <- bind_rows(results) %>% distinct()

  # Fallback: parse from concatenated text if tables didn't work
  if (nrow(out) == 0) {
    cat("  NSW: no tables found, trying text parsing...\n")
    text <- html_text2(page)
    # Look for the concatenated table string
    lines <- str_split(text, "\n")[[1]] %>% str_trim() %>% .[. != ""]
    concat_lines <- lines[str_detect(lines, "Holiday.*New Year")]
    if (length(concat_lines) > 0) {
      out <- parse_concatenated_holidays(concat_lines[1], "NSW")
    }
  }

  if (nrow(out) == 0) warning("NSW: page fetched but no holidays parsed")
  cat("  NSW:", nrow(out), "entries\n")
  out
}

# --- VIC ---
# VIC has separate pages per year with a table: columns are "Holiday" and "Date in YYYY"
scrape_vic <- function(years = 2026:2028) {
  cat("Scraping VIC...\n")
  results <- list()
  for (yr in years) {
    url <- paste0(
      "https://business.vic.gov.au/business-information/public-holidays/",
      "victorian-public-holidays-", yr
    )
    page <- tryCatch(read_html(url), error = function(e) {
      cat("  VIC", yr, "fetch failed:", e$message, "\n")
      NULL
    })
    if (is.null(page)) next

    tables <- html_table(page, fill = TRUE)
    for (tbl in tables) {
      if (ncol(tbl) < 2) next
      # Find which column is the holiday name and which is the date
      # Column names are like "Holiday" and "Date in 2026"
      col_names <- names(tbl)
      date_col <- which(str_detect(str_to_lower(col_names), "date"))[1]
      name_col <- which(str_detect(str_to_lower(col_names), "holiday"))[1]
      # Fallback: if no clear column names, try both orderings
      if (is.na(date_col) || is.na(name_col)) {
        date_col <- 2
        name_col <- 1
      }
      for (i in seq_len(nrow(tbl))) {
        date_str <- tbl[[date_col]][i]
        holiday_name <- clean_holiday_name(tbl[[name_col]][i])
        if (is.na(date_str) || is.na(holiday_name) || holiday_name == "") next
        date_parts <- str_split(date_str, "/|\\band\\b")[[1]]
        for (dp in date_parts) {
          d <- parse_holiday_date(str_trim(dp), yr)
          if (!is.na(d)) {
            results <- c(results, list(tibble(
              Date = d, `Holiday Name` = holiday_name, Jurisdiction = "VIC"
            )))
          }
        }
      }
    }
  }
  out <- bind_rows(results) %>% distinct()
  if (nrow(out) == 0) warning("VIC: no holidays parsed from any year page")
  cat("  VIC:", nrow(out), "entries\n")
  out
}

# --- NT ---
# NT page has year headers and concatenated holiday text per year
scrape_nt <- function() {
  cat("Scraping NT...\n")
  page <- read_html_safe("https://nt.gov.au/nt-public-holidays")
  if (is.null(page)) {
    warning("NT: failed to fetch page")
    return(tibble())
  }

  text <- html_text2(page)
  # The NT page concatenates all holidays into long strings per year
  # Parse out holiday-date pairs using the concatenated parser
  out <- parse_concatenated_holidays(text, "NT")

  if (nrow(out) == 0) warning("NT: page fetched but no holidays parsed")
  cat("  NT:", nrow(out), "entries\n")
  out
}

# --- TAS ---
# TAS transport page has a proper 3-column HTML table: Holiday, Date, Timetable
scrape_tas <- function() {
  cat("Scraping TAS...\n")
  # Go straight to transport.tas.gov.au — worksafe.tas.gov.au blocks all requests
  page <- read_html_safe(
    "https://www.transport.tas.gov.au/public_transport/bus_timetables/public_holiday_timetables/accordion/state-wide_public_holidays"
  )
  if (is.null(page)) {
    warning("TAS: failed to fetch transport.tas.gov.au")
    return(tibble())
  }

  tables <- html_table(page, fill = TRUE)
  results <- list()
  for (tbl in tables) {
    if (ncol(tbl) < 2) next
    # Table has columns: Holiday, Date, Timetable
    for (i in seq_len(nrow(tbl))) {
      holiday_name <- clean_holiday_name(tbl[[1]][i])
      date_str <- tbl[[2]][i]
      if (is.na(date_str) || is.na(holiday_name) || holiday_name == "") next
      # Skip Easter Tuesday (Tasmanian Public Service only)
      if (holiday_name == "Easter Tuesday") next
      d <- parse_holiday_date(date_str)
      if (!is.na(d)) {
        results <- c(results, list(tibble(
          Date = d, `Holiday Name` = holiday_name, Jurisdiction = "TAS"
        )))
      }
    }
  }
  out <- bind_rows(results) %>% distinct()
  if (nrow(out) == 0) warning("TAS: page fetched but no holidays parsed")
  cat("  TAS:", nrow(out), "entries\n")
  out
}

# --- ACT ---
# ACT publishes holidays as PDFs linked from their holidays page.
# We discover the PDF URLs, download them, and parse the text with pdftools.
scrape_act <- function() {
  cat("Scraping ACT...\n")

  if (!requireNamespace("pdftools", quietly = TRUE)) {
    warning("ACT: pdftools package not installed — install.packages('pdftools')")
    return(tibble())
  }

  # Find PDF links from the ACT holidays page
  page <- read_html_safe(
    "https://www.act.gov.au/living-in-the-act/public-holidays-school-terms-and-daylight-saving"
  )
  if (is.null(page)) {
    warning("ACT: failed to fetch holidays page")
    return(tibble())
  }

  links <- page %>% html_elements("a") %>% html_attr("href")
  pdf_urls <- links[str_detect(links, "(?i)public.holiday.*\\.pdf")]
  pdf_urls <- unique(pdf_urls)

  if (length(pdf_urls) == 0) {
    warning("ACT: no holiday PDF links found on page")
    return(tibble())
  }

  cat("  Found", length(pdf_urls), "PDF(s)\n")

  results <- list()
  for (pdf_url in pdf_urls) {
    # Make absolute URL if needed
    if (!str_starts(pdf_url, "http")) {
      pdf_url <- paste0("https://www.act.gov.au", pdf_url)
    }

    pdf_text <- tryCatch(
      pdftools::pdf_text(pdf_url),
      error = function(e) {
        cat("  Failed to read PDF:", pdf_url, "\n")
        NULL
      }
    )
    if (is.null(pdf_text)) next

    text <- paste(pdf_text, collapse = "\n")

    # Extract year from title line like "ACT PUBLIC HOLIDAYS 2026"
    year_match <- str_match(text, "ACT PUBLIC HOLIDAYS (\\d{4})")
    default_year <- if (!is.na(year_match[1, 2])) year_match[1, 2] else NULL

    # Parse lines matching "Holiday Name    DayOfWeek DD Month YYYY"
    # The PDF has holiday name and date separated by whitespace
    lines <- str_split(text, "\n")[[1]] %>% str_trim() %>% .[. != ""]

    for (line in lines) {
      # Match lines with holiday name followed by date
      m <- str_match(line, "^(.+?)\\s{2,}(\\w+day\\s+\\d{1,2}.+\\d{4})")
      if (!is.na(m[1, 1])) {
        holiday_name <- clean_holiday_name(m[1, 2])
        date_str <- m[1, 3]
        # Handle "Saturday 26 and Monday" (Boxing Day split across lines)
        # Just take the first date on the line
        d <- parse_holiday_date(date_str)
        if (!is.na(d) && holiday_name != "" && nchar(holiday_name) > 2) {
          results <- c(results, list(tibble(
            Date = d, `Holiday Name` = holiday_name, Jurisdiction = "ACT"
          )))
        }
      }
      # Handle the continuation line for Boxing Day: "28 December 2026***"
      m2 <- str_match(line, "^(\\d{1,2}\\s+\\w+\\s+\\d{4})")
      if (!is.na(m2[1, 1]) && length(results) > 0) {
        last_name <- results[[length(results)]]$`Holiday Name`
        d <- parse_holiday_date(m2[1, 1])
        if (!is.na(d) && last_name != "") {
          results <- c(results, list(tibble(
            Date = d, `Holiday Name` = last_name, Jurisdiction = "ACT"
          )))
        }
      }
    }
  }

  out <- bind_rows(results) %>% distinct()
  if (nrow(out) == 0) warning("ACT: PDFs found but no holidays parsed")
  cat("  ACT:", nrow(out), "entries\n")
  out
}

# --- SA (needs headless Chrome — 403s on standard requests) ---
scrape_sa <- function() {
  cat("Scraping SA...\n")
  page <- read_html_safe(
    "https://safework.sa.gov.au/resources/public-holidays",
    use_live = TRUE
  )
  if (is.null(page)) {
    warning("SA: headless Chrome failed (403) — update CSV manually")
    return(tibble())
  }

  text <- if (is.character(page)) page else html_text2(page)
  # html_text2() on a live session can return a vector — collapse to single string
  text <- paste(text, collapse = "\n")
  lines <- str_split(text, "\n")[[1]] %>% str_trim() %>% .[. != ""]

  results <- list()
  current_year <- NULL

  for (line in lines) {
    if (str_detect(line, "^\\d{4}\\s")) {
      current_year <- as.integer(str_extract(line, "^\\d{4}"))
      next
    }
    if (is.null(current_year)) next
    m <- str_match(line, "^\\w+day\\s+(\\d{1,2}\\s+\\w+):\\s*(.+)$")
    if (!is.na(m[1, 1])) {
      d <- parse_holiday_date(m[1, 2], current_year)
      holiday_name <- str_trim(m[1, 3])
      holiday_name <- str_remove(holiday_name, ":\\s*\\d+[ap]m.*$")
      holiday_name <- clean_holiday_name(holiday_name)
      if (!is.na(d) && holiday_name != "" &&
          !str_detect(str_to_lower(holiday_name), "school")) {
        results <- c(results, list(tibble(
          Date = d, `Holiday Name` = holiday_name, Jurisdiction = "SA"
        )))
      }
    }
  }
  out <- bind_rows(results) %>% distinct()
  if (nrow(out) == 0) warning("SA: page fetched but no holidays parsed — update CSV manually")
  cat("  SA:", nrow(out), "entries\n")
  out
}

# --- WA ---
# WA has a table with year columns (like QLD) and "&" separating multiple dates
scrape_wa <- function() {
  cat("Scraping WA...\n")
  page <- read_html_safe(
    "https://www.wa.gov.au/service/employment/workplace-agreements/public-holidays-western-australia"
  )
  if (is.null(page)) {
    warning("WA: failed to fetch page")
    return(tibble())
  }

  tables <- html_table(page, fill = TRUE)
  results <- list()

  for (tbl in tables) {
    if (ncol(tbl) < 2) next
    # Look for year columns like QLD format
    year_cols <- names(tbl)[str_detect(names(tbl), "^\\d{4}$")]
    if (length(year_cols) > 0) {
      # First column is the holiday name (may be unnamed)
      for (yr in year_cols) {
        for (i in seq_len(nrow(tbl))) {
          holiday_name <- clean_holiday_name(tbl[[1]][i])
          date_str <- tbl[[yr]][i]
          if (is.na(holiday_name) || holiday_name == "" ||
              is.na(date_str) || date_str == "") next
          # WA uses "&" to separate multiple dates
          date_parts <- str_split(date_str, "&|\\band\\b")[[1]]
          for (dp in date_parts) {
            d <- parse_holiday_date(str_trim(dp), yr)
            if (!is.na(d)) {
              results <- c(results, list(tibble(
                Date = d, `Holiday Name` = holiday_name, Jurisdiction = "WA"
              )))
            }
          }
        }
      }
    }
  }
  out <- bind_rows(results) %>% distinct()
  if (nrow(out) == 0) warning("WA: page fetched but no holidays parsed")
  cat("  WA:", nrow(out), "entries\n")
  out
}

# --- Main: run all scrapers and update the supplement CSV ---
update_supplement <- function(csv_path = "data-raw/au_holidays_supplement.csv") {
  cat("=== Scraping Australian public holidays ===\n\n")

  scraped <- list(
    scrape_qld(),
    scrape_nsw(),
    scrape_vic(),
    scrape_nt(),
    scrape_tas(),
    scrape_act(),
    scrape_sa(),
    scrape_wa()
  ) %>%
    bind_rows() %>%
    filter(!is.na(Date)) %>%
    distinct()

  if (nrow(scraped) == 0) {
    cat("\nNo data scraped. Check warnings above.\n")
    return(invisible(NULL))
  }

  scraped_states <- unique(scraped$Jurisdiction)
  cat("\nScraped", nrow(scraped), "holiday entries from:",
      paste(sort(scraped_states), collapse = ", "), "\n")

  # Read existing supplement
  if (file.exists(csv_path)) {
    existing <- read_csv(csv_path, show_col_types = FALSE)
    cat("Existing supplement has", nrow(existing), "entries.\n")

    # Merge: keep existing + add genuinely new rows
    combined <- bind_rows(existing, scraped) %>%
      distinct(Date, `Holiday Name`, Jurisdiction) %>%
      arrange(Date, Jurisdiction)

    new_count <- nrow(combined) - nrow(existing)
    cat("Added", new_count, "new entries.\n")
  } else {
    combined <- scraped %>%
      distinct(Date, `Holiday Name`, Jurisdiction) %>%
      arrange(Date, Jurisdiction)
    cat("Creating new supplement with", nrow(combined), "entries.\n")
  }

  write_csv(combined, csv_path)
  cat("\nSaved to", csv_path, "\n")

  all_states <- c("ACT", "NSW", "NT", "QLD", "SA", "TAS", "VIC", "WA")
  missing <- setdiff(all_states, scraped_states)
  if (length(missing) > 0) {
    cat("\nStates that need manual update (scrape failed):\n")
    cat("  ", paste(missing, collapse = ", "), "\n")
    cat("  Existing data for these states was preserved in the CSV.\n")
  } else {
    cat("\nAll states scraped successfully!\n")
  }

  # Summary table
  cat("\n=== Summary ===\n")
  summary_tbl <- combined %>%
    mutate(Year = year(Date)) %>%
    count(Year, Jurisdiction) %>%
    pivot_wider(names_from = Jurisdiction, values_from = n, values_fill = 0) %>%
    arrange(Year)
  print(as.data.frame(summary_tbl))
  cat("\nTotal entries:", nrow(combined), "\n")

  # Preview
  cat("\n=== Preview (first 20 rows) ===\n")
  print(as.data.frame(head(combined, 20)), right = FALSE)

  invisible(combined)
}

# Run if sourced directly
update_supplement()
