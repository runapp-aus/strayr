#' Read in ASGC/ASGS 2016 population-weighted correspondence tables from the ABS.
#' @source <https://data.gov.au/dataset/ds-dga-23fe168c-09a7-42d2-a2f9-fd08fbd0a4ce>
#'
#' @param from_area The area you want to correspond FROM (ie the areas your data are currently in). For example: "sa1", "sa2, "sa3", "sa4".
#' @param from_year The year you want to correspond FROM. For example: 2011, 2016.
#' @param to_area The area you want to correspond TO (ie the areas you want your data to be in).
#' @param to_year The year you want to correspond TO.
#' @param export_dir path to a directory to store the desired sf object. \code{tempdir()} by default.
#'
#' @return A \code{tibble} object.
#' @export
#'
#' @examples
#' \dontrun{
#' sa4_corr <- read_correspondence_tbl("sa4", 2011, "sa4", 2016)
#' lga2011_to_2018 <- read_correspondence_tbl("LGA", 2011, "LGA", 2018)
#' }
read_correspondence_tbl <- function(from_area,
                                    from_year,
                                    to_area,
                                    to_year,
                                    export_dir = tempdir()) {
  if (!dir.exists(export_dir)) {
    stop("export_dir provided does not exist: ", export_dir)
  }

  url <- "https://github.com/wfmackey/absmapsdata/raw/master/R/sysdata.rda"

  # download to temporary file
  out_path <- file.path(export_dir, "cg_tables.rda")

  if (!file.exists(out_path)) {
    tryCatch(
      download.file(url,
                    destfile = out_path,
                    mode = "wb"),
      error = "Download failed. Check that you have access to the internet and that your requested object is available at https://github.com/wfmackey/absmapsdata/tree/master/data"
    )
  } else {
    message("Reading file found in ", export_dir)
  }

  load(out_path)

  filename <- paste(
    "CG",
    toupper(from_area), from_year,
    toupper(to_area), to_year,
    sep = "_"
  )

  cg_tbl <- try(get(filename))

  if (inherits(cg_tbl, "try-error")) {
    message("The following correspondence tables are available:")
    for(obj in ls()[str_detect(ls(), "^CG_")]) {
      message(obj)
    }
    stop("Correspondence table not available.")
  }

  cg_tbl
}
