#' Convert ASCED fields of education into the consistent format used by the Australian Bureau of Statistics.
#' This function enables both exact (default) and fuzzy matching.
#' Under exact matching, if no match is found, NA is returned.
#'
#' @param x a (character) vector containing ASCED fields of education.
#' Note that clean_asced_foe always returns a character vector. If no match is found, then NA is returned.
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
#' @param silent a boolean value. If FALSE (the default), the function will warn that NAs were returned.
#'
#' @return a character vector
#'
#' @family cleaning functions
#'
#' @seealso  \code{\link{clean_asced_qual}} for ASCED levels, \code{\link{clean_anzsco}} for ANZSCO, \code{\link{clean_anzsic}} for ANZSIC,  \code{\link{clean_state}} for Australian states and territories.
#'
#' @examples
#'
#' clean_asced_foe("Biochemistry & cell biology")
#'
#' clean_asced_foe("Maths", fuzzy_match = TRUE)
#'
#' @export
#'
#'
clean_asced_foe <- function(x,
                         fuzzy_match = FALSE,
                         max_dist = 0.4,
                         method = "jw",
                         silent = FALSE) {
  clean_titles(
    dictionary = asced_foe_dictionary,
    .vector = x,
    .fuzzy_match = fuzzy_match,
    .max_dist = max_dist,
    .method = method,
    .silent = silent
  )
}
