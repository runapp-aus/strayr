#' Convert ANZSIC names and abbreviations into the consistent format used by the Australian Bureau of Statistics.
#' This function enables both exact (default) and fuzzy matching.
#' Under exact matching, if no match is found, NA is returned.
#'
#' @param x a (character) vector containing ANZSIC titles or codes.
#' Note that clean_anzsic always returns a character vector. If no match is found, then NA is returned.
#'
#' @param to what form should the ANZSIC names or codes be converted to? Options are
#' "title" (the default) or "code".
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
#' @examples
#'
#'
#'
#' @importFrom stringdist amatch
#' @importFrom stringr str_to_lower str_trim
#' @importFrom stringi stri_trans_general
#' @export
#'
#'
clean_anzsic <- function(x,
                         to = c("title", "code"),
                         fuzzy_match = FALSE,
                         max_dist = 0.4,
                         method = "jw",
                         return_na = FALSE)



