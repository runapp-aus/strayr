#' @title Convert ANZSCO names and abbreviations into the consistent format used by the Australian Bureau of Statistics.
#'
#' @description This function enables both exact (default) and fuzzy matching. Under exact matching, if no match is found, NA is returned.
#'
#' @param x a (character) vector containing ANZSCO titles.
#' Note that \code{clean_anzsco} always returns a character vector. If no match is found, then \code{NA} is returned.
#'
#' @param fuzzy_match logical; either TRUE which indicates that
#' approximate/fuzzy string matching should be used, or FALSE (the default) which indicates that
#' only exact matches should be used. If FALSE, then if no match is found, then NA is returned.
#'
#' @param max_dist numeric, sets the maximum acceptable distance between your
#' string and the matched string. Default is 0.4. Only relevant when fuzzy_match is TRUE.
#'
#' @param method the method used for approximate/fuzzy string matching. Default
#' is "jw", the Jaro-Winker distance; see `??stringdist-metrics` for more options.
#' Only relevant when fuzzy_match is TRUE.
#'
#' @param silent a boolean value. If FALSE (the default), the function will warn that  \code{NA}(s) were returned.
#'
#' @return a character vector of cleaned values that have matches in the official format.
#'
#' @family cleaning functions
#'
#' @seealso \code{\link{clean_anzsic}} for ANZSIC.
#'
#' @examples
#'
#' clean_anzsco("driving instructor")
#'
#' clean_anzsco("Driving", fuzzy_match = TRUE)
#'
#' @export
#'
#'
clean_anzsco <- function(x,
                         fuzzy_match = FALSE,
                         max_dist = 0.4,
                         method = "jw",
                         silent = FALSE) {
  clean_titles(
    dictionary = anzsco_dictionary,
    .vector = x,
    .fuzzy_match = fuzzy_match,
    .max_dist = max_dist,
    .method = method,
    .silent = silent
  )
}
