#' clean_titles is a helper function for the clean
#'
#' @param dictionary a dictionary created with the make_dictionary function
#' @param .vector a character vector
#' @param .fuzzy_match logical; either TRUE which indicates that
#' approximate/fuzzy string matching should be used, or FALSE (the default) which indicates that
#' only exact matches should be used. If FALSE, then if no match is found, then NA is returned.
#' @param .max_dist numeric, sets the maximum acceptable distance between your
#' string and the matched string. Default is 0.4. Only relevant when fuzzy_match is TRUE.
#' @param .method the method used for approximate/fuzzy string matching. Default
#' is "jw", the Jaro-Winker distance; see `??stringdist-metrics` for more options.
#' Only relevant when fuzzy_match is TRUE.
#' @param .silent a boolean value. If FALSE (the default), the function will warn that  \code{NA}(s) were returned.
#'
#' @return a character vector of cleaned values that have matches in the dictionary.
#'
#' @importFrom stringdist amatch
#'
#'
clean_titles <- function(dictionary = NULL,
                         .vector = NULL,
                         .fuzzy_match = FALSE,
                         .max_dist = 0.4,
                         .method = "jw",
                         .silent = FALSE) {
  if (!is.logical(.fuzzy_match)) {
    stop("`fuzzy_match` argument must be either `TRUE` or `FALSE`")
  }

  if (!is.logical(.silent)) {
    stop("`silent` argument must be either `TRUE` or `FALSE`")
  }

  if (!is.character(.vector)) {
    stop("`vector` argument must be a character vector")
  }

  clean_vector <- clean_string(.vector)


  if (.fuzzy_match) {
    matched_titles <- names(dictionary[stringdist::amatch(clean_vector, dictionary,
      method = .method,
      maxDist = .max_dist
    )])
  }


  else {
    matched_titles <- names(dictionary[match(clean_vector, dictionary)])
  }


  no_match <- sum(is.na(matched_titles))

  if (no_match > 0 & !.silent) {
    warning(no_match, " titles(s) could not be matched. NA was returned.")
  }

  return(matched_titles)
}




#' Helper function to clean strings
#'
#' @param string a character vector
#'
#' @importFrom stringr str_to_lower str_trim str_replace_all str_remove_all

#' @return a cleaned string with no punctuation, trailing letter s, numbers etc
#'

clean_string <- function(string) {
  clean_string <- string %>%
    # Replace punctuation with spaces
    stringr::str_replace_all("[:punct:]", " ") %>%
    # Remove numbers
    stringr::str_remove_all("\\d") %>%
    # Remove any capitalised letters at the start of the string
    stringr::str_remove_all("\\b[A-Z]?\\b") %>%
    # convert to lower
    stringr::str_to_lower() %>%
    # remove the word "and"
    stringr::str_remove_all(" and ") %>%
    # Remove any whitespace
    stringr::str_remove_all("[:space:]")

  return(clean_string)
}


#' A helper function to create a dictionary for use in the clean family of functions
#'
#' @param category_tbl a tibble of categories, e.g. \code{anzsco}
#'
#' @importFrom dplyr select contains pull everything distinct ends_with everything mutate
#' @importFrom tidyr pivot_longer
#' @importFrom rlang .data
#'
#' @return a named vector.

make_dictionary <- function(category_tbl) {
  dictionary_tbl <- category_tbl %>%
    select(!contains("code")) %>%
    pivot_longer(everything(), values_to = "title") %>%
    mutate(clean_title = clean_string(.data$title)) %>%
    select(-.data$name) %>%
    distinct()

  dictionary <- dictionary_tbl %>%
    pull(.data$clean_title)

  names(dictionary) <- dictionary_tbl$title

  return(dictionary)
}
