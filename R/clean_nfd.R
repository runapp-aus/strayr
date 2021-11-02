clean_nfd <- function(vector){
  cleaned_vec <- stringr::str_remove(vector, ', nfd$') %>% 
                  stringr::str_remove("0+$")
  
  return(cleaned_vec)
}



