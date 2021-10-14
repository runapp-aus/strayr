#' @title Read ABS geographic data
#'
#' @description Read ABS geographic data as sf objects from the [absmapsdata](https://github.com/wfmackey/absmapsdata) package.
#'
#' @param name a character string containing absmapsdata file names in [\code{area}][\code{year}] format, eg "sa42016"; "gcc2021".
#' See full list at https://github.com/wfmackey/absmapsdata.
#' Note: if \code{name} is entered, then \code{area} and \code{year} values will be ignored.
#'
#' @param area a character string containing the concise absmapsdata area names, eg "sa4"; "gcc".
#' See full list at https://github.com/wfmackey/absmapsdata.
#'
#' @param year a character string or numeric of the full source year of absmapsdata object, eg "2016"; 2021.
#' See full list at https://github.com/wfmackey/absmapsdata.
#'
#' @param remove_year_suffix logical defaulting to FALSE.
#' If TRUE, `strip_year_suffix` is run before returning the object, removing
#' the `_year` suffix from variable names.
#'
#' @return an sf object.
#'
#'
#' @seealso https://github.com/wfmackey/absmapsdata
#'
#' @examples
#'
#' \dontrun{read_absmap("sa42016")}
#'
#' \dontrun{read_absmap(area = "sa4", year = 2016)}
#'
#' @export
#'
#'
read_absmap <- function(name = NULL,
                        area = NULL,
                        year = NULL,
                        remove_year_suffix = FALSE) {

  if (all(is.null(name), is.null(area), is.null(year))) {
    stop("Please enter a name (eg name = 'sa32016') or an area/year combination (eg area = 'sa3', year = '2016').")
  }

  if (is.null(name) & (is.null(area) | is.null(year))) {
    stop("Please enter a name (eg name = 'sa32016') or an area/year combination (eg area = 'sa3', year = '2016').")
  }

  if (!is.null(name) & !is.null(area) & !is.null(year)) {
    warning("Both name and area/year entered. Defaulting to name value: ", name)
  }

  # Define name
  if (is.null(name)) name <- paste0(area, year)
  name <- stringr::str_to_lower(name)

  # Define url
  base_url <- "https://github.com/wfmackey/absmapsdata/raw/master/data/"
  url <- paste0(base_url, name, ".rda")

  # download to temporary file
  out_path <- tempfile(fileext = ".rda")
  download.file(url,
                destfile = out_path)

  load(out_path)

  d <- get(name)

  if (isTRUE(remove_year_suffix)) d <- strip_year_suffix(d)

  return(d)

}
