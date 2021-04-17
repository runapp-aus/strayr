#' ANZSCO
#'
#' Wide table containing all levels of the Australian and New Zealand Standard
#' Classification of Occupations (ANZSCO), First Edition, Revision 1, 2009. Cat. 1220.0.
#'
#' @format A \code{tibble} with 11 variables:
#' \describe{
#' \item{\code{anzsco1_code}}{Major ANZSCO group codes, e.g. "4"}
#' \item{\code{anzsco1}}{Major ANZSCO group names in title case, e.g. "Community and Personal Service Workers"}
#' \item{\code{anzsco1_f}}{Factor version of \code{anzsco1}.}
#' \item{\code{anzsco2_code}}{Sub-major ANZSCO group codes, e.g. "45"}
#' \item{\code{anzsco2}}{Sub-major ANZSCO group names in title case, e.g. "Sports and Personal Service Workers"}
#' \item{\code{anzsco2_f}}{Factor version of \code{anzsco2}.}
#' \item{\code{anzsco3_code}}{Minor ANZSCO group codes, e.g. "452"}
#' \item{\code{anzsco3}}{Minor ANZSCO group names in title case, e.g. "Sports and Fitness Workers"}
#' \item{\code{anzsco3_f}}{Factor version of \code{anzsco3}.}
#' \item{\code{anzsco4_code}}{Unit ANZSCO group codes, e.g. "4523"}
#' \item{\code{anzsco4}}{Unit ANZSCO group names in title case, e.g. "Sports Coaches, Instructors and Officials"}
#' \item{\code{anzsco4_f}}{Factor version of \code{anzsco4}.}
#' \item{\code{anzsco6_code}}{Occupation ANZSCO group codes, e.g. "452311"}
#' \item{\code{anzsco6}}{Occupation ANZSCO group names in title case, e.g. "Diving Instructor (Open Water)"}
#' \item{\code{anzsco6_f}}{Factor version of \code{anzsco5}.}
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
#' \item{\code{anzsic_division_code}}{ANZSCO division codes character, e.g. "A", "B"}
#' \item{\code{anzsic_division_title}}{ANZSCO division title, e.g. "Agriculture, Forestry and Fishing"}
#' \item{\code{anzsic_subdivision_code}}{ANZSCO subdivision codes integer, e.g. 1, 2}
#' \item{\code{anzsic_subdivision_title}}{ANZSCO subdivision title, e.g. "Agriculture"}
#' \item{\code{anzsic_group_code}}{ANZSCO group codes integer, e.g. 11, 12}
#' \item{\code{anzsic_group_title}}{ANZSCO group title, e.g. "Mushroom and Vegetable Growing"}
#' \item{\code{anzsic_class_code}}{ANZSCO class codes integer, e.g. 111, 112}
#' \item{\code{anzsic_class_title}}{ANZSCO class title, e.g. "Vegetable Growing (Under Cover)"}
#' }
"anzsic"





#' ASCED Field of Education
#'
#' Wide table containing all levels of fields of education in the Australian
#' Standard Classification of Education (ASCED), 2001. Cat. 1272.0.
#'
#' @format A \code{tibble} with 6 variables:
#' \describe{
#' \item{\code{foe2_code}}{Broad field of education two-digit code, e.g. "09"}
#' \item{\code{foe2}}{Broad field of education two-digit name in title case, e.g. "Society and Culture"}
#' \item{\code{foe2_f}}{Factor version of \code{foe2}.}
#' \item{\code{foe2_short}}{Shorter two-digit field of education names, e.g. "Science", "IT", "Engineering"}
#' \item{\code{foe2_short_f}}{Factor version of \code{foe2_short}.}
#' \item{\code{foe4_code}}{Narrow field of education four-digit code, e.g. "0921"}
#' \item{\code{foe4}}{Narrow field of education four-digit name in title case, e.g. "Sport and Recreation"}
#' \item{\code{foe4_f}}{Factor version of \code{foe4}.}
#' \item{\code{foe6_code}}{Detailed field of education six-digit code, e.g. "092103"}
#' \item{\code{foe6}}{Detailed field of education six-digit name in title case, e.g. "Sports Coaching, Officiating and Instruction"}
#' \item{\code{foe6_f}}{Factor version of \code{foe6}.}
#' }
"asced_foe"


#' ASCED Level of Education
#'
#' Wide table containing all levels of qualifications in the Australian Standard
#' Classification of Education (ASCED), 2001. Cat. 1272.0.
#'
#' @format A \code{tibble} with 6 variables:
#' \describe{
#' \item{\code{qual1_code}}{Broad qualification level one-digit code, e.g. "1"}
#' \item{\code{qual1}}{Broad qualification level one-digit name in title case, e.g. "Postgraduate Degree Level"}
#' \item{\code{qual1_f}}{Factor version of \code{qual1}.}
#' \item{\code{qual2_code}}{Narrow qualification level two-digit code, e.g. "12"}
#' \item{\code{qual2}}{Narrow qualification level two-digit name in title case, e.g. "Master Degree Level"}
#' \item{\code{qual2_f}}{Factor version of \code{qual2}.}
#' \item{\code{qual3_code}}{Detailed qualification level three-digit code, e.g. "122"}
#' \item{\code{qual3}}{Detailed qualification level three-digit name in title case, e.g. "Master Degree by Coursework"}
#' \item{\code{qual3_f}}{Factor version of \code{qual3}.}
#' }
"asced_qual"


