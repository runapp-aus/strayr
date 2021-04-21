
<!-- README.md is generated from README.Rmd. Please edit that file -->

# abscorr <img src="man/figures/apple-touch-icon-152x152.png" align="right" style="height:150px"/>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/runapp-aus/abscorr/workflows/R-CMD-check/badge.svg)](https://github.com/runapp-aus/abscorr/actions)
<!-- badges: end -->

The `abscorr` package provides tidy versions of common structures used
by the Australian Bureau of Statistics (ABS).

This package is currently **in development** and subject to change. The
lifecycle badge will be changed to `stable` when structures are stable
(should be relatively soon).

**Contribute to this package**: people are actively encouraged to
contribute to this package.

## Installation

You can install the current version of `abscorr` with:

``` r
remotes::install_github("runapp-aus/abscorr")
```

## Structures

Current structures stored in `abscorr` are:

-   `anzsco`: occupation levels of the [Australian and New Zealand
    Standard Classification of Occupations (ANZSCO), First Edition,
    Revision 1, 2009. Cat.
    1220.0](https://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/1220.0First%20Edition,%20Revision%201?OpenDocument).
-   `anzsic`: industry levels of the [Australian and New Zealand
    Standard Industrial Classification (ANZSIC), 2006 (Revision 1.0).
    Cat.
    1292.0](https://www.abs.gov.au/ausstats/abs@.nsf/0/20C5B5A4F46DF95BCA25711F00146D75?opendocument).
-   `asced_foe`: field of education levels of the [Australian Standard
    Classification of Education (ASCED), 2001. Cat.
    1272.0](https://www.abs.gov.au/ausstats/abs@.nsf/mf/1272.0).
-   `asced_qual`: qualification levels of the [Australian Standard
    Classification of Education (ASCED), 2001. Cat.
    1272.0](https://www.abs.gov.au/ausstats/abs@.nsf/mf/1272.0).

The `abscorr` package also loads
[`absmapsdata`](https://github.com/wfmackey/absmapsdata), which contains
the following structures *and their geometry* as `sf` objects:

**ASGS Main Structures**

-   `sa12011`: Statistical Area 1 2011
-   `sa12016`: Statistical Area 1 2016
-   `sa22011`: Statistical Area 2 2011
-   `sa22016`: Statistical Area 2 2016
-   `sa32011`: Statistical Area 3 2011
-   `sa32016`: Statistical Area 3 2016
-   `sa42011`: Statistical Area 4 2011
-   `sa42016`: Statistical Area 4 2016
-   `gcc2011`: Greater Capital Cities 2011
-   `gcc2016`: Greater Capital Cities 2016
-   `ra2011`: Remoteness Areas 2011
-   `ra2016`: Remoteness Areas 2016
-   `state2011`: State 2011
-   `state2016`: State 2016

**ASGS Non-ABS Structures**

-   `ced2018`: Commonwealth Electoral Divisions 2018
-   `sed2018`: State Electoral Divisions 2018
-   `lga2016`: Local Government Areas 2016
-   `lga2018`: Local Government Areas 2018
-   `regional_ivi2008`: Regions for the Internet Vacancy Index 2008
-   `postcodes2016`: Postcodes 2016
-   `dz2011`: Census of Population and Housing Destination Zones 2011
-   `dz2016`: Census of Population and Housing Destination Zones 2016

## Using `abscorr`

Loading the package will lazily load the structures listed above. Call
them with their name:

``` r
library(abscorr)
#> Loading required package: absmapsdata
library(dplyr)
```

``` r
glimpse(anzsco)
#> Rows: 1,180
#> Columns: 11
#> $ anzsco1_code <chr> "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1…
#> $ anzsco1      <chr> "Managers", "Managers", "Managers", "Managers", "Managers…
#> $ anzsco2_code <chr> "10", "11", "11", "11", "11", "11", "11", "11", "11", "12…
#> $ anzsco2      <chr> "Managers, nfd", "Chief Executives, General Managers and …
#> $ anzsco3_code <chr> "100", "110", "111", "111", "111", "111", "111", "111", "…
#> $ anzsco3      <chr> "Managers, nfd", "Chief Executives, General Managers and …
#> $ anzsco4_code <chr> "1000", "1100", "1110", "1111", "1112", "1112", "1113", "…
#> $ anzsco4      <chr> "Managers, nfd", "Chief Executives, General Managers and …
#> $ anzsco6_code <chr> "100000", "110000", "111000", "111111", "111211", "111212…
#> $ anzsco6      <chr> "Managers, nfd", "Chief Executives, General Managers and …
#> $ skill_level  <chr> NA, NA, NA, "1", "1", "1", "1", "1", "1", NA, NA, "1", "1…
glimpse(anzsic)
#> Rows: 506
#> Columns: 8
#> $ anzsic_division_code    <chr> "A", "A", "A", "A", "A", "A", "A", "A", "A", "…
#> $ anzsic_division         <chr> "Agriculture, Forestry and Fishing", "Agricult…
#> $ anzsic_subdivision_code <chr> "1", "1", "1", "1", "1", "1", "1", "1", "1", "…
#> $ anzsic_subdivision      <chr> "Agriculture", "Agriculture", "Agriculture", "…
#> $ anzsic_group_code       <chr> "11", "11", "11", "11", "11", "12", "12", "12"…
#> $ anzsic_group            <chr> "Nursery and Floriculture Production", "Nurser…
#> $ anzsic_class_code       <chr> "111", "112", "113", "114", "115", "121", "122…
#> $ anzsic_class            <chr> "Nursery Production (Under Cover)", "Nursery P…
glimpse(asced_foe)
#> Rows: 439
#> Columns: 6
#> $ foe2_code <chr> "01", "01", "01", "01", "01", "01", "01", "01", "01", "01", …
#> $ foe2      <chr> "Natural and Physical Sciences", "Natural and Physical Scien…
#> $ foe4_code <chr> "0100", "0101", "0101", "0101", "0101", "0103", "0103", "010…
#> $ foe4      <chr> "Natural and Physical Sciences, nfd", "Mathematical Sciences…
#> $ foe6_code <chr> "010000", "010100", "010101", "010103", "010199", "010300", …
#> $ foe6      <chr> "Natural and Physical Sciences, nfd", "Mathematical Sciences…
glimpse(asced_qual)
#> Rows: 64
#> Columns: 6
#> $ qual1_code <chr> "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "2",…
#> $ qual1      <chr> "Postgraduate Degree Level", "Postgraduate Degree Level", "…
#> $ qual2_code <chr> "11", "11", "11", "11", "11", "11", "12", "12", "12", "12",…
#> $ qual2      <chr> "Doctoral Degree Level", "Doctoral Degree Level", "Doctoral…
#> $ qual3_code <chr> "111", "112", "113", "114", "115", "116", "121", "122", "12…
#> $ qual3      <chr> "Higher Doctorate", "Doctorate by Research", "Doctorate by …
glimpse(sa42016)
#> Rows: 107
#> Columns: 10
#> $ sa4_code_2016   <chr> "101", "102", "103", "104", "105", "106", "107", "108"…
#> $ sa4_name_2016   <chr> "Capital Region", "Central Coast", "Central West", "Co…
#> $ gcc_code_2016   <chr> "1RNSW", "1GSYD", "1RNSW", "1RNSW", "1RNSW", "1RNSW", …
#> $ gcc_name_2016   <chr> "Rest of NSW", "Greater Sydney", "Rest of NSW", "Rest …
#> $ state_code_2016 <chr> "1", "1", "1", "1", "1", "1", "1", "1", "1", "1", "1",…
#> $ state_name_2016 <chr> "New South Wales", "New South Wales", "New South Wales…
#> $ areasqkm_2016   <dbl> 51895.5631, 1681.0724, 70297.0604, 13229.7578, 339363.…
#> $ cent_long       <dbl> 149.2450, 151.2855, 148.3558, 152.7739, 145.0269, 150.…
#> $ cent_lat        <dbl> -35.56480, -33.30797, -33.21697, -29.81603, -30.98611,…
#> $ geometry        <list> [150.31133, 150.31258, 150.30964, 150.31133, -35.6658…
glimpse(ced2018)
#> Rows: 169
#> Columns: 6
#> $ ced_code_2018 <chr> "101", "102", "103", "104", "105", "106", "107", "108", …
#> $ ced_name_2018 <chr> "Banks", "Barton", "Bennelong", "Berowra", "Blaxland", "…
#> $ areasqkm_2018 <dbl> 49.4460, 39.6466, 58.6052, 749.6359, 61.1166, 98.3974, 3…
#> $ cent_long     <dbl> 151.0465, 151.1274, 151.0985, 151.0385, 151.0090, 151.15…
#> $ cent_lat      <dbl> -33.96482, -33.94082, -33.79360, -33.56993, -33.89634, -…
#> $ geometry      <list> [151.01558, 151.01209, 151.00812, 151.00593, 151.00422,…
```
