

#' @title Import 2016 SEIFA Data from ABS
#' @description The function will download all SEIFA data, for a specified spatial structure,
#' to a temporary excel file and then merge sheets into a single `data.frame`. This `data.frame`
#' also includes the ABS population count for the given spatial structure. For more information
#' on SEIFA indexes go to
#' \url{https://www.abs.gov.au/AUSSTATS/abs@.nsf/Lookup/2033.0.55.001Main+Features12016?OpenDocument}
#'
#' @param structure character value for the desired spatial area. Must be one of:
#' \itemize{
#'   \item{sa1}{ - download size 51.6 MB}
#'   \item{sa2}{ - download size 1.9 MB}
#'   \item{lga}{ - download size 660 KB}
#'   \item{postcode}{ - download size 2.3 MB}
#'   \item{suburb}{ - download size 11.3 MB}
#' }
#' @param data_subclass character vector matching available SEIFA indexes:
#' \itemize{
#'   \item{irsed}{ - Index of Relative Socio-economic Disadvantage}
#'   \item{irsead}{ - Index of Relative Socio-economic Advantage and Disadvantage}
#'   \item{ier}{ - Index of Economic Resources}
#'   \item{ieo}{ - Index of Education and Occupation}
#' }
#' @importFrom purrr map_dfr
#' @importFrom utils download.file
#' @importFrom dplyr starts_with
#'
#' @return `data.frame` if file successfully downloaded, else returns `NULL`.
#' @note For All ABS SEIFA spreadsheets go to \href{https://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/2033.0.55.0012016?OpenDocument}{ABS website}
#' @export
#'
#' @examples
#' \dontrun{
#'
#'   get_seifa(structure = 'lga', data_subclass = 'irsed')
#' }
#'
get_seifa <- function(structure = c('sa1','sa2','lga','postcode','suburb'), data_subclass = c('irsed', 'irsead', 'ier', 'ieo')) {

  stopifnot(all(data_subclass %in% c('irsed', 'irsead', 'ier', 'ieo')))

  # match excel sheet names to data_subclass
  sheet_names <- c('irsed'   = 'Table 2',
                   'irsead'  = 'Table 3',
                   'ier'     = 'Table 4',
                   'ieo'     = 'Table 5')

  sheet_names <- sheet_names[data_subclass]

  # match spatial structures to specific urls
  structure <- match.arg(structure, several.ok = FALSE)

  urls <- c('sa1' = 'https://www.abs.gov.au/ausstats/subscriber.nsf/log?openagent&2033055001%20-%20sa1%20indexes.xls&2033.0.55.001&Data%20Cubes&40A0EFDE970A1511CA25825D000F8E8D&0&2016&27.03.2018&Latest',
            'sa2' = 'https://www.abs.gov.au/ausstats/subscriber.nsf/log?openagent&2033055001%20-%20sa2%20indexes.xls&2033.0.55.001&Data%20Cubes&C9F7AD36397CB43DCA25825D000F917C&0&2016&27.03.2018&Latest',
            'lga' = 'https://www.abs.gov.au/ausstats/subscriber.nsf/log?openagent&2033055001%20-%20lga%20indexes.xls&2033.0.55.001&Data%20Cubes&5604C75C214CD3D0CA25825D000F91AE&0&2016&27.03.2018&Latest',
            'postcode' = 'https://www.abs.gov.au/ausstats/subscriber.nsf/log?openagent&2033055001%20-%20poa%20indexes.xls&2033.0.55.001&Data%20Cubes&DC124D1DAC3D9FDDCA25825D000F9267&0&2016&27.03.2018&Latest',
            'suburb' = 'https://www.abs.gov.au/ausstats/subscriber.nsf/log?openagent&2033055001%20-%20ssc%20indexes.xls&2033.0.55.001&Data%20Cubes&863031D939DE8105CA25825D000F91D2&0&2016&27.03.2018&Latest')

  url <- urls[structure]

  filename <- tempfile(fileext = '.xls')

  try({
    download.file(url, destfile = filename, mode = 'wb')
    message(paste0('ABS ', toupper(structure),' file downloaded to: \n'),
            paste0('    ', filename),
            appendLF = TRUE)
  })

  if (file.exists(filename)) {
    ind <- map_dfr(sheet_names, ~ get_seifa_index_sheet(filename, .x, structure), .id = 'seifa_index')
    return(ind)
  } else {
    warning('Download of ABS file failed. Please check your internet connection and try again.')
    return(NULL)
  }

}


#' @title Parse SEIFA index Spreadsheet
#' @description This is a helper function used by \code{\link{get_seifa}}. The function can also
#' be used independently if you have already downloaded one of the SEIFA index score spreadsheets
#' from \url{https://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/2033.0.55.0012016?OpenDocument}
#'
#' @param filename character name of temporary file when spreadsheet downloaded
#' @param sheetname character name of the sheet to be imported
#' @param structure character spatial structure of the data to be parsed. The spatial structure is
#' important as the shape of the data in the ABS spreadsheets if different for some structures.
#'
#' @import readxl
#' @importFrom dplyr select mutate relocate across
#' @return data.frame
#' @export
#'
#' @examples
#' \dontrun{
#'
#'   get_seifa_index_sheet('downloaded_filename.xls', sheetname = 'Table 2', structure = 'lga')
#' }
#'
get_seifa_index_sheet <- function(filename, sheetname, structure = c('sa1','sa2','lga','postcode','suburb')) {

  structure <- match.arg(structure, several.ok = FALSE)

  column_names <- c('area_code',
                    'area_name',
                    'population',
                    'score',
                    'blank1',
                    'rank_aus',
                    'decile_aus',
                    'percentile_aus',
                    'blank2',
                    'state',
                    'rank_state',
                    'decile_state',
                    'percentile_state',
                    'min_score_sa1_area',
                    'max_score_sa1_area',
                    'percent_usual_resident_pop_without_sa1_score')

  if (structure %in% c('suburb','postcode')) {
    column_names <- c(column_names, 'caution_poor_sa1_representation')
  }

  if (structure == 'postcode') {
    column_names <- column_names[-grep('area_name', column_names)]
    column_names <- c(column_names, 'postcode_crosses_state_boundary')
  }

  if (structure == 'sa1') {
    column_names <- c('sa1_7_code',
                      'sa1_11_code',
                      'population',
                      'score',
                      'blank1',
                      'rank_aus',
                      'decile_aus',
                      'percentile_aus',
                      'blank2',
                      'state',
                      'rank_state',
                      'decile_state',
                      'percentile_state')
  }

  suppressWarnings({
    df <- read_excel(filename,
                     sheetname,
                     skip = 6,
                     col_names = column_names) %>%
      dplyr::filter(across(ends_with('_code'), ~ !is.na(.x))) %>%
      select(-starts_with('blank')) %>%
      mutate(structure = structure) %>%
      relocate(structure)
  })

  return(df)

}


