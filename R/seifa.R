

#' @title Import SEIFA Data from ABS
#' @description The function will download all SEIFA data, for a specified spatial structure,
#' to a temporary excel file and then merge sheets into a single `data.frame`. This `data.frame`
#' also includes the ABS population count for the given spatial structure. For more information
#' on SEIFA indexes go to
#' \url{https://www.abs.gov.au/statistics/people/people-and-communities/socio-economic-indexes-areas-seifa-australia}
#'
#' To learn more about the individual data-sets for each year, please visit their respective pages:
#' 2011
#' \url{https://www.abs.gov.au/AUSSTATS/abs@.nsf/allprimarymainfeatures/8C5F5BB699A0921CCA258259000BA619}
#' 2016
#' \url{https://www.abs.gov.au/ausstats/abs@.nsf/mf/2033.0.55.001}
#' 2021
#' \url{https://www.abs.gov.au/statistics/people/people-and-communities/socio-economic-indexes-areas-seifa-australia/2021}

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
#' @param year a character string or numeric of the release year of SEIFA object, eg "2016"; 2011.
#'
#' @importFrom purrr map
#' @importFrom purrr list_rbind
#' @importFrom utils download.file
#' @importFrom dplyr starts_with
#'
#' @return `data.frame` if file successfully downloaded, else returns `NULL`.
#' @note For All ABS SEIFA spreadsheets go to \href{https://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/2033.0.55.0012016?OpenDocument}{ABS website}
#' @export
#'
#' @examples
#' \dontrun{
#'   get_seifa(structure = 'lga', data_subclass = 'irsed', year = 2016)
#' }
#'
get_seifa <- function(structure = c('sa1','sa2','lga','postcode','suburb'),
                      data_subclass = c('irsed', 'irsead', 'ier', 'ieo'),
                      year = NULL) {

  # TODO: 2006 SEIFA has the Statistical Local Area (SLA) structure, not the
  # Statistical Level Areas (SA1, SA2) structures. Would need to update logic to
  # handle 2006.
  release_years = c(2011, 2016, 2021)

  stopifnot(all(data_subclass %in% c('irsed', 'irsead', 'ier', 'ieo')))

  # match excel sheet names to data_subclass
  sheet_names <- c('irsed'   = 'Table 2',
                   'irsead'  = 'Table 3',
                   'ier'     = 'Table 4',
                   'ieo'     = 'Table 5')

  sheet_names <- sheet_names[data_subclass]

    # match spatial structures to specific urls
  structure <- match.arg(structure, several.ok = FALSE)

  urls <- list( '2011' = c( 'sa1' = 'https://www.abs.gov.au/AUSSTATS/subscriber.nsf/log?openagent&2033.0.55.001%20sa1%20indexes.xls&2033.0.55.001&Data%20Cubes&9828E2819C30D96DCA257B43000E923E&0&2011&05.04.2013&Latest',
                            'sa2' = 'https://www.abs.gov.au/AUSSTATS/subscriber.nsf/log?openagent&2033.0.55.001%20SA2%20Indexes.xls&2033.0.55.001&Data%20Cubes&76D0BC44356DC34ACA257B3B001A4913&0&2011&12.11.2014&Latest',
                            'lga' = 'https://www.abs.gov.au/AUSSTATS/subscriber.nsf/log?openagent&2033.0.55.001%20lga%20indexes.xls&2033.0.55.001&Data%20Cubes&28EF8569335AC7CDCA257BAB00136B0F&0&2011&18.07.2013&Latest',
                            'postcode' = 'https://www.abs.gov.au/AUSSTATS/subscriber.nsf/log?openagent&2033.0.55.001%20POA%20Indexes.xls&2033.0.55.001&Data%20Cubes&209B3364525C82CCCA257B3B001A4D56&0&2011&12.11.2014&Latest',
                            'suburb' = 'https://www.abs.gov.au/AUSSTATS/subscriber.nsf/log?openagent&2033.0.55.001%20ssc%20indexes.xls&2033.0.55.001&Data%20Cubes&F40D0630B245D5DCCA257B43000EA0F1&0&2011&05.04.2013&Latest'),

                '2016' = c( 'sa1' = 'https://www.abs.gov.au/ausstats/subscriber.nsf/log?openagent&2033055001%20-%20sa1%20indexes.xls&2033.0.55.001&Data%20Cubes&40A0EFDE970A1511CA25825D000F8E8D&0&2016&27.03.2018&Latest',
                            'sa2' = 'https://www.abs.gov.au/ausstats/subscriber.nsf/log?openagent&2033055001%20-%20sa2%20indexes.xls&2033.0.55.001&Data%20Cubes&C9F7AD36397CB43DCA25825D000F917C&0&2016&27.03.2018&Latest',
                            'lga' = 'https://www.abs.gov.au/ausstats/subscriber.nsf/log?openagent&2033055001%20-%20lga%20indexes.xls&2033.0.55.001&Data%20Cubes&5604C75C214CD3D0CA25825D000F91AE&0&2016&27.03.2018&Latest',
                            'postcode' = 'https://www.abs.gov.au/ausstats/subscriber.nsf/log?openagent&2033055001%20-%20poa%20indexes.xls&2033.0.55.001&Data%20Cubes&DC124D1DAC3D9FDDCA25825D000F9267&0&2016&27.03.2018&Latest',
                            'suburb' = 'https://www.abs.gov.au/ausstats/subscriber.nsf/log?openagent&2033055001%20-%20ssc%20indexes.xls&2033.0.55.001&Data%20Cubes&863031D939DE8105CA25825D000F91D2&0&2016&27.03.2018&Latest'),

                '2021' = c( 'sa1' = 'https://www.abs.gov.au/statistics/people/people-and-communities/socio-economic-indexes-areas-seifa-australia/2021/Statistical%20Area%20Level%201%2C%20Indexes%2C%20SEIFA%202021.xlsx',
                            'sa2' = 'https://www.abs.gov.au/statistics/people/people-and-communities/socio-economic-indexes-areas-seifa-australia/2021/Statistical%20Area%20Level%202%2C%20Indexes%2C%20SEIFA%202021.xlsx',
                            'lga' = 'https://www.abs.gov.au/statistics/people/people-and-communities/socio-economic-indexes-areas-seifa-australia/2021/Local%20Government%20Area%2C%20Indexes%2C%20SEIFA%202021.xlsx',
                            'postcode' = 'https://www.abs.gov.au/statistics/people/people-and-communities/socio-economic-indexes-areas-seifa-australia/2021/Postal%20Area%2C%20Indexes%2C%20SEIFA%202021.xlsx',
                            'suburb' = 'https://www.abs.gov.au/statistics/people/people-and-communities/socio-economic-indexes-areas-seifa-australia/2021/Suburbs%20and%20Localities%2C%20Indexes%2C%20SEIFA%202021.xlsx' )

                )


  if( is.null(year) ){
    year = as.character(max(release_years))
  }else{
    if(! (is.numeric(year) | is.character(year) ) ){
      stop('year must either be an integer or character string.')
    }
    year <- as.character(year)

    if(! any(year %in% as.character(release_years))){
      stop('year is not a valid release year, please check SEIFA webpage.')
    }
  }

  url <- urls[[year]][structure]

  # Get file extension if possible, otherwise assume xls.
  url_ext <- tools::file_ext(sub("\\?.+", "", url))
  if(url_ext == ""){url_ext <- 'xls'}

  filename <- tempfile(fileext = paste0('.',url_ext) )

  try({
    download.file(url, destfile = filename, mode = 'wb')
    message(paste0('ABS ', toupper(structure),' file downloaded to: \n'),
            paste0('    ', filename),
            appendLF = TRUE)
  })

  if (file.exists(filename)) {
    ind <- map(sheet_names, ~ get_seifa_index_sheet(filename, .x, structure, year), .id = 'seifa_index') %>%
      list_rbind()
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
#' @inheritParams get_seifa
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
get_seifa_index_sheet <- function(filename, sheetname, structure = c('sa1','sa2','lga','postcode','suburb'), year) {

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

  # Add column for SEIFA releases >= 2016 with structures suburb or postcode.
  if (structure %in% c('suburb','postcode') && year >= 2016 ) {
    column_names <- c(column_names, 'caution_poor_sa1_representation')
  }

  if (structure == 'postcode') {
    column_names <- column_names[-grep('area_name', column_names)]
    if(year >= 2016){
      column_names <- c(column_names, 'postcode_crosses_state_boundary')
    }
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

    # remove sa1_11_code column for 2011 release.
    if( year == 2011) {
      column_names <- column_names[-grep('sa1_11_code', column_names)]
    }else if( year == 2021) {
      column_names <- column_names[-grep('sa1_7_code', column_names)]
    }
  }

  suppressWarnings({
    df <- read_excel(filename,
                     sheetname,
                     skip = 6,
                     col_names = column_names,
                     na = c("", "NA") ) %>%
      dplyr::filter(across(ends_with('_code'), ~ !is.na(.x))) %>%
      select(-starts_with('blank')) %>%
      mutate(structure = structure) %>%
      relocate(structure)
  })

  return(df)

}
