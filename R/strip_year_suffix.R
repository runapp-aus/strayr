#' strip_year_suffix removes year suffixes from variable names
#'
#' @description Some structures in strayr contain variables with year
#' suffixes (e.g. \code{sa3_name_2011}). This function removes these year
#' suffixes from the dataset supplied.
#'
#' @param .data a dataframe
#'
#' @return a tibble
#'
#' @importFrom stringr str_remove
#'
#' @export
#'
strip_year_suffix <- function(.data) {
  names(.data) <- stringr::str_remove(names(.data), "\\_[0-9]{4}")
  return(.data)
}
