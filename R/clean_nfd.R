#' @title Return highest level of detail from "NFD" codes
#'
#' @description Removes ", nfd" or trailing zeroes from the end of ANZCO/ANZSIC labels or codes.
#'
#' @param vector A character vector or column containing ANZCO/ANZSIC names or codes. 
#'
#' @return Returns the same character vector without "NFD" or trailing zeroes. Strings without "NFC" or trailing zeroes are unchanged.
#'
#' @family cleaning functions
#'
#' @examples
#'
#' clean_nfd("Furniture Manufacturing, nfd")
#'
#' clean_nfd(c("Managers, nfd", "2510"))
#'
#' @export
#'

clean_nfd <- function(vector){
  cleaned_vec <- stringr::str_remove(vector, ', nfd$') %>% 
                  stringr::str_remove("0+$")
  
  return(cleaned_vec)
}



