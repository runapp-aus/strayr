#' parse_income_range extracts dollar figures from income bucket ranges used in Census
#' data and elsewhere
#'
#' @param income_range a character vector containing income ranges, e.g.
#' \code{"b. $18,201 to $37,000"}, \code{"$400-$499 ($20,800-$25,999)"}
#' @param limit either "lower" (the default) and "upper" bounds of the range, or "mid" to return the mid-point
#' @param max_income numeric value of 'and over' value of the highest bracket. \code{Inf} by default.
#' If \code{NULL}, returns a max_income value equal to the lower bound of the
#' highest bracket. Important for \code{limit = "mid"} or \code{limit = "upper"}.
#' @param is_zero a character vector of values to be interpreted as zero. Defaults to \code{c("Nil income")}.
#' @param negative_as_zero a boolean value. If TRUE (the default) the character
#' @param dollar_prefix a character string to denote the dollar delimiter.
#' \code{"$"} by default, but could be e.g. \code{"AUD"} or \code{"USD"}.
#' string "Negative income" is interpreted as \code{0}. If FALSE, \code{NA} is returned.
#' @param .silent a boolean value. If FALSE (the default), the function will warn that  \code{NA}(s) were returned.
#'
#' @return a numeric vector of incomes
#'
#' @importFrom stringr str_detect str_split str_replace_all
#' @importFrom readr parse_number
#'
#' @export
#'
parse_income_range <- function(income_range,
                               limit = "lower",
                               max_income = Inf,
                               is_zero = c("Nil income"),
                               negative_as_zero = TRUE,
                               dollar_prefix = "$",
                               .silent = TRUE) {

  # correct for use in regex
  if (stringr::str_detect(dollar_prefix, "\\$")) {
    dollar_prefix <- stringr::str_replace_all(dollar_prefix, "\\$", "\\\\$")
  }

  # run
  purrr::map_dbl(income_range,
                 .parse_income_range_single,
                 .limit = limit,
                 .negative_as_zero = negative_as_zero,
                 .is_zero = is_zero,
                 .max_income = max_income,
                 .dollar_prefix = dollar_prefix,
                 silent = .silent)

}

.parse_income_range_single <- function(x,
                                .limit,
                                .negative_as_zero,
                                .is_zero,
                                .max_income,
                                .dollar_prefix,
                                silent) {

  # Non-numeric specials
  if (is.na(x)) return(NA_real_)
  if (x %in% .is_zero) return(0)
  if (stringr::str_detect(x, "(N|n)egative")) {
    if (.negative_as_zero) return(0) else return(NA_real_)
  }
  if (x %in% c("Not stated", "Not applicable", "Total", "All")) return(NA_real_)

  # Return NA if there is no number
  if (!stringr::str_detect(x, .dollar_prefix)) return(NA_real_)

  # Remove cruft before .dollar_prefix
  stripped_x <- stringr::str_remove_all(x, paste0("[^0-9", .dollar_prefix, "]*"))

  # 'or more' and 'or less'
  if (stringr::str_detect(x, " more")) { # 'X or more'

    # get first only
    max_lower <- suppressWarnings(readr::parse_number(stripped_x))

    # get max_upper
    if (!is.null(.max_income)) {
      max_upper <- .max_income
    } else {
      max_upper <- max_lower
    }
    all <- c(max_lower, max_upper)

  } else if (stringr::str_detect(x, " less")) { # 'X or less'

    # get first only
    min_upper <- suppressWarnings(readr::parse_number(stripped_x))
    all <- c(0, min_upper)

  } else {
    # otherwise, extract the $numerics
    all <- stringr::str_split(stripped_x, pattern = .dollar_prefix)
    all <- unlist(all)

    all <- suppressWarnings(readr::parse_number(all))
    all <- all[!is.na(all)]
  }

  # too long or short?
  len_all <- length(all)
  # If too long, take the first 2
  if (len_all > 2) {

    if (!silent) message("More than two dollar figures found in ", x, "; using the first two")

    all <-  all[1:2]

    # If none found, return NA
  } else if (len_all == 0) {

    if (!silent) message("No dollar signs found in ", x, ". Returning NA")

    return(NA_real_)
  }

  if (.limit == "lower") return(all[1])
  if (.limit == "upper") return(all[2])
  if (.limit == "mid")   return((sum(round(all, -1))) / 2)

}
