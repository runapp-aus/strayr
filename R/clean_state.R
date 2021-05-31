#' Convert Australian state names and abbreviations into a consistent format
#'
#' @param x a (character) vector containing Australian state names or abbreviations or
#' a (numeric) vector containing state codes (1 = NSW, 2 = Vic, 3 = Qld, 4 = SA,
#' 5 = WA, 6 = Tas, 7 = NT, 8 = ACT).
#'
#' @param to what form should the state names be converted to? Options are
#' "state_name", "state_abbr" (the default), "iso", "postal", and "code".
#'
#' @param fuzzy_match logical; either TRUE (the default) which indicates that
#' approximate/fuzzy string matching should be used, or FALSE which indicates that
#' only exact matches should be used.
#'
#' @param max_dist numeric, sets the maximum acceptable distance between your
#' string and the matched string. Default is 0.4. Only relevant when fuzzy_match is TRUE.
#'
#' @param method the method used for approximate/fuzzy string matching. Default
#' is "jw", the Jaro-Winker distance; see `??stringdist-metrics` for more options.
#'
#' @param ... all arguments to `strayr` are passed to `clean_state`
#'
#' @return a character vector of state names, abbreviations, or codes.
#'
#' @details `strayr()` is a wrapper around `clean_state()` and is provided for
#' backwards compatibility. `strayr()` is soft-deprecated, but will not be removed
#' for the foreseeable future. New code should use `clean_state()`.
#'
#' @rdname clean_state
#' @examples
#'
#' x <- c("western Straya", "w. A ", "new soth wailes", "SA", "tazz")
#'
#' # Convert the above to state abbreviations
#' clean_state(x)
#'
#' # Convert the elements of `x` to state names
#'
#' clean_state(x, to = "state_name")
#'
#' # Disable fuzzy matching; you'll get NAs unless exact matches can be found
#'
#' clean_state(x, fuzzy_match = FALSE)
#'
#' # You can use clean_state in a dplyr mutate call
#'
#' x_df <- data.frame(state = x, stringsAsFactors = FALSE)
#'
#' \dontrun{x_df %>% mutate(state_abbr = clean_state(state))}
#'
#' @importFrom stringdist amatch
#' @export

clean_state <- function(x, to = "state_abbr", fuzzy_match = TRUE, max_dist = 0.4, method = "jw"){


  if(!is.logical(fuzzy_match)){
    stop("`fuzzy_match` argument must be either `TRUE` or `FALSE`")
  }

  if(!is.numeric(x)) {
    x <- state_string_tidy(x)
  }

  if(fuzzy_match){
    matched_abbr <- names(state_dict[stringdist::amatch(x, tolower(state_dict),
                                               method = method,
                                               matchNA = FALSE,
                                               maxDist = max_dist)])
  } else {
    matched_abbr <- names(state_dict[match(x, tolower(state_dict))])
  }

  ret <- state_table[[to]][match(matched_abbr, state_table$state_abbr)]

  ret <- as.character(ret)

  ret

}

#' @rdname clean_state
#' @export
strayr <- function(...) {
  .Deprecated(new = "clean_state",
              msg = "The strayr() function has been renamed clean_state().")
  clean_state(...)
}



state_string_tidy <- function(string){

  string <- tolower(string)

  string <- trimws(string, "both")

  string <- ifelse(string %in% c("na", "n.a", "n.a.", "n a",
                                 "not applicable"),
                   NA_character_,
                   string)

  string
}
