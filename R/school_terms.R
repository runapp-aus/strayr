#' @title Australian School Terms
#' @description Tidy data set of Australian school terms from 1978 to 2024,
#' inclusive. As the data are manually collected by the ABS there is no
#' guarantee of accuracy or comprehensiveness. Missing or obviously incorrect
#' dates are replaced with \code{NA}.
#' @format A data frame with 1504 rows and 5 variables:
#' \describe{
#'   \item{\code{state}}{The state or territory of the school term}
#'   \item{\code{year}}{The year of the school term}
#'   \item{\code{term}}{The term number of the school term}
#'   \item{\code{start}}{The start date of the school term}
#'   \item{\code{end}}{The end date of the school term}
#'}
#' @source State and Territory governments via the Australian Bureau of Statistics via direct correspondence.
"school_terms"
