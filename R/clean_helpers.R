#' clean_titles
#'
#' @param dictionary
#' @param .vector
#' @param .fuzzy_match
#' @param .max_dist
#' @param .method
#' @param .silent
#'
#' @return
#' @importFrom stringdist amatch
#'
#' @examples
#'
clean_titles <- function(dictionary,
                         .vector = vector,
                         .fuzzy_match = fuzzy_match,
                         .max_dist = max_dist,
                         .method = method,
                         .silent = silent) {
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
#' @param category_tbl
#'
#' @return a named vector.

make_dictionary <- function(category_tbl) {
  dictionary_tbl <- category_tbl %>%
    select(!contains("code")) %>%
    pivot_longer(everything(), values_to = "title") %>%
    mutate(clean_title = clean_string(title)) %>%
    select(-name) %>%
    distinct()

  dictionary <- dictionary_tbl %>%
    pull(clean_title)

  names(dictionary) <- dictionary_tbl$title

  return(dictionary)
}
