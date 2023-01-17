library(lubridate)

#' @title Get Australian seasons for given dates
#' @description Small helper function that provided a vector with dates, returns the names of corresponding seasons, according to the Australian definition of seasons
#' It can return either "temperate" (4 seasons) or "tropical" (dry/wet) seasons
#' @param dates vectors with dates. It supports Dates, POSIxt  or characters
#' @param type either "temperate" (default) or "tropical"
#' @importFrom lubridate as_date month
#' @importFrom stringr str_remove
#' @returns vector with season names
#' @examples \dontrun{
#' sample_dates <- c("2022-01-01","2018-10-04","2016-07-20")
#' # temperate seasons
#' aus_seasons(sample_dates,"temperate")
#' # tropical seasons
#' aus_seasons(sample_dates,"tropical")
#' }
#' @rdname aus_seasons
#' @export
aus_seasons <- function(dates, type="temperate"){

  # as defined by http://www.bom.gov.au/climate/glossary/seasons.shtml
  seasons_temperate <- list("Summer" = c(12,1,2),
                            "Autumn" = c(3,4,5),
                            "Winter" = c(6,7,8),
                            "Spring" = c(9,10,11)
  )

  # https://www.australia.com/en/facts-and-planning/when-to-go/australias-seasons.html
  seasons_tropical <-list("Wet Season"=c(11,12,1,2,3,4),
                          "Dry Season"=c(5,6,7,8,9,10))


  dates <- as_date(dates)
  dates_month <- month(dates)

  if(type=="tropical"){
    season_vector <- unlist(seasons_tropical)
  }else{
    season_vector <- unlist(seasons_temperate)
  }


  pos <- match(dates_month,season_vector)
  return(str_remove(names(season_vector)[pos],"[0-9]"))

}


