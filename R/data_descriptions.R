#' ANZSCO
#'
#' Wide table containing all levels of the Australian and New Zealand Standard
#' Classification of Occupations (ANZSCO), First Edition, Revision 1, 2009. Cat. 1220.0.
#'
#' @format A \code{tibble} with 11 variables:
#' \describe{
#' \item{\code{anzsco_major_code}}{Major ANZSCO group codes, e.g. "4"}
#' \item{\code{anzsco_major}}{Major ANZSCO group names in title case, e.g. "Community and Personal Service Workers"}
#' \item{\code{anzsco_submajor_code}}{Sub-major ANZSCO group codes, e.g. "45"}
#' \item{\code{anzsco_submajor}}{Sub-major ANZSCO group names in title case, e.g. "Sports and Personal Service Workers"}
#' \item{\code{anzsco_minor_code}}{Minor ANZSCO group codes, e.g. "452"}
#' \item{\code{anzsco_minor}}{Minor ANZSCO group names in title case, e.g. "Sports and Fitness Workers"}
#' \item{\code{anzsco_unit_code}}{Unit ANZSCO group codes, e.g. "4523"}
#' \item{\code{anzsco_unit}}{Unit ANZSCO group names in title case, e.g. "Sports Coaches, Instructors and Officials"}
#' \item{\code{anzsco_occupation_code}}{Occupation ANZSCO group codes, e.g. "452311"}
#' \item{\code{anzsco_occupation}}{Occupation ANZSCO group names in title case, e.g. "Diving Instructor (Open Water)"}
#' \item{\code{skill_level}}{Skill level required for occupation, determined by the ABS (1 is highest, 5 is lowest).
#' See \url{https://www.abs.gov.au/ausstats/abs@.nsf/Previousproducts/C4BECE1704987586CA257089001A9181 } for details.}
#' }
"anzsco"



#' ANZSIC
#'
#' Wide table containing all levels of the Australian and New Zealand Standard
#' Industrial Classification (ANZSIC), 2006 (Revision 1.0). Cat. 1292.0.
#'
#' @format A \code{tibble} with 8 variables:
#' \describe{
#' \item{\code{anzsic_division_code}}{ANZSIC division codes character, e.g. "A", "B"}
#' \item{\code{anzsic_division}}{ANZSIC division title, e.g. "Agriculture, Forestry and Fishing"}
#' \item{\code{anzsic_subdivision_code}}{ANZSIC subdivision codes integer, e.g. 1, 2}
#' \item{\code{anzsic_subdivision}}{ANZSIC subdivision title, e.g. "Agriculture"}
#' \item{\code{anzsic_group_code}}{ANZSIC group codes integer, e.g. 11, 12}
#' \item{\code{anzsic_group}}{ANZSIC group title, e.g. "Mushroom and Vegetable Growing"}
#' \item{\code{anzsic_class_code}}{ANZSIC class codes integer, e.g. 111, 112}
#' \item{\code{anzsic_class}}{ANZSIC class title, e.g. "Vegetable Growing (Under Cover)"}
#' }
"anzsic"





#' ASCED Field of Education
#'
#' Wide table containing all levels of fields of education in the Australian
#' Standard Classification of Education (ASCED), 2001. Cat. 1272.0.
#'
#' @format A \code{tibble} with 6 variables:
#' \describe{
#' \item{\code{aced_foe_broad_code}}{Broad field of education two-digit code, e.g. "09"}
#' \item{\code{aced_foe_broad}}{Broad field of education two-digit name in title case, e.g. "Society and Culture"}
#' \item{\code{aced_foe_narrow_code}}{Narrow field of education four-digit code, e.g. "0921"}
#' \item{\code{aced_foe_narrow}}{Narrow field of education four-digit name in title case, e.g. "Sport and Recreation"}
#' \item{\code{aced_foe_detailed_code}}{Detailed field of education six-digit code, e.g. "092103"}
#' \item{\code{aced_foe_detailed}}{Detailed field of education six-digit name in title case, e.g. "Sports Coaching, Officiating and Instruction"}
#' }
"asced_foe"

#' ASCED Level of Education
#'
#' Wide table containing all levels of qualifications in the Australian Standard
#' Classification of Education (ASCED), 2001. Cat. 1272.0.
#'
#' @format A \code{tibble} with 6 variables:
#' \describe{
#' \item{\code{aced_qual_broad_code}}{Broad qualification level one-digit code, e.g. "1"}
#' \item{\code{aced_qual_broad}}{Broad qualification level one-digit name in title case, e.g. "Postgraduate Degree Level"}
#' \item{\code{aced_qual_narrow_code}}{Narrow qualification level two-digit code, e.g. "12"}
#' \item{\code{aced_qual_narrow}}{Narrow qualification level two-digit name in title case, e.g. "Master Degree Level"}
#' \item{\code{aced_qual_detailed_code}}{Detailed qualification level three-digit code, e.g. "122"}
#' \item{\code{aced_qual_detailed}}{Detailed qualification level three-digit name in title case, e.g. "Master Degree by Coursework"}
#' }
"asced_qual"


#' @import absmapsdata
NULL
