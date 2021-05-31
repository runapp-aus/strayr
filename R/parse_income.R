#' parse_income extracts dollar figures from income bucket ranges used in Census
#' data and elsewhere
#'
#' @param raw_income a character vector of income ranges, eg "$800-$999 ($41,600-$51,999)"
#' @param limit either "lower" (the default) and "upper" bounds of the range, or "mid" to return the mid-point
#' @param max_income numeric value of 'and over' value of the highest bracket.
#' \code{NULL}, the default, returns a max_income value equal to the lower bound
#' of the highest bracket. Important for \code{limit = "mid"} or \code{limit = "upper"}.
#' @param negative_as_zero a boolean value. If TRUE, the default, the character
#' string "Negative income" is interpreted as \code{0}. If FALSE, \code{NA} is returned.
#' @param .silent a boolean value. If FALSE (the default), the function will warn that  \code{NA}(s) were returned.
#'
#' @return a numeric vector of incomes
#'
# @importFrom stringdist amatch
#'
#'
parse_income <- function(raw_income,
                         limit = "lower",
                         max_income = NULL,
                         negative_as_zero = TRUE,
                         .silent = TRUE) {

  known_nas <- c("Not stated", "Not applicable", "Total", "All")

  # run
  purrr::map_dbl(raw_income, .parse_income_single,
                 .limit = limit,
                 .negative_as_zero = negative_as_zero,
                 .max_income = max_income)

}

.parse_income_single <- function(x,
                                .limit,
                                .negative_as_zero,
                                .max_income) {

  tic(msg = "specials")
  # Non-numeric specials
  if (is.na(x)) return(NA_real_)
  if (x == "Nil income") return(0)
  if (x == "Negative income") {
    if (.negative_as_zero) return(0) else return(NA_real_)
  }
  if (x %in% known_nas) return(NA_real_)
  toc()

  tic(msg = "is there a number")
  # Is there a number?
  if (!str_detect(x, "[0-9]")) return(NA_real_)
  toc()

  tic(msg = "more or less")
  # 'or more' and 'or less'
  if (str_detect(x, " more")) { # 'X or more'
    # get first only
    max_lower <- parse_number(x)
    # get max_upper
    if (!is.null(.max_income)) {
      max_upper <- .max_income
    } else {
      max_upper <- max_lower
    }
    all <- c(max_lower, max_upper)
  } else if (str_detect(x, " less")) { # 'X or less'
    # get first only
    min_upper <- parse_number(x)
    all <- c(0, min_upper)
  } else {
    # otherwise, extract the $numerics
    all <- str_split(x, pattern = "\\$") %>%
      unlist() %>%
      parse_number() %>%
      .[!is.na(.)]
  }
  toc()

  tic(msg = "too long or short")
  # too long or short?
  len_all <- length(all)
  # If too long, take the first 2
  if (len_all > 2) {
    if (!.silent) message("More than two dollar figures found in ", x, "; using the first two")
    all <-  all[1:2]
    # If none found, return NA
  } else if (len_all == 0) {
    if (!.silent) message("No dollar signs found in ", x, ". Returning NA")
    return(NA_real_)
  }
  toc()

  tic(msg = "return min max sum")
  if (.limit == "lower") return(all[1])
  if (.limit == "upper") return(all[2])
  if (.limit == "mid")   return((sum(round(all, -1))) / 2)
  toc()

}
