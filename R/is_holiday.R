#' @title Identifies if a given date is a public holiday in Australia
#' @param date Date, POSIXct object or a string that can be parsed with `parsedate::parse_date`
#' @param jurisdictions Vector of state jurisdictions you wish to filter on, defaults to all of Australia
#' @return logical(`TRUE` or `FALSE`) vector
#' @examples
#' is_holiday('2020-01-01')
#' is_holiday('2019-05-27', jurisdictions=c('ACT', 'TAS'))
#' h_df <- data.frame(dates = c('2020-01-01', '2020-01-10'))
#' h_df %>%
#'   dplyr::mutate(IsHoliday = is_holiday(dates))
#' @rdname is_holiday
#' @export
#' @importFrom purrr map_lgl
is_holiday <- function(date, jurisdictions = c()) {
  ret <- purrr::map_lgl(date, do_is_holiday, jurisdictions = jurisdictions)

  return(ret)
}

do_is_holiday <- function(date, jurisdictions = c()) {
  if (is.na(date)) {
    stop("`date` argument cannot be NA")
  }

  if (!lubridate::is.Date(date) & !lubridate::is.POSIXct(date)) {
    # Attempt to coerce to date
    new_date <- parsedate::parse_date(date)

    if (is.na(new_date)) {
      stop("`date` must be a Date, POSIXct object or a string that can be parsed as a date")
    }

    # Remove any time or time zone element
    new_date <- lubridate::as_date(new_date)
  } else {
    new_date <- lubridate::as_date(date)
  }

  if (length(jurisdictions) == 0) {
    ret <- abscorr::auholidays[abscorr::auholidays$Date == new_date, ]
  } else {
    ret <- abscorr::auholidays[abscorr::auholidays$Date == new_date & (abscorr::auholidays$Jurisdiction %in% jurisdictions | abscorr::auholidays$Jurisdiction == "NAT"), ]
  }

  return(nrow(ret) > 0)
}
