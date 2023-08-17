
<!-- README.md is generated from README.Rmd. Please edit that file -->

# strayr <img src="man/figures/logo.png" align="right" style="height:150px"/>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![R build
status](https://github.com/runapp-aus/strayr/workflows/R-CMD-check/badge.svg)](https://github.com/runapp-aus/strayr/actions)

<!-- badges: end -->

The `strayr` package provides tools to make working with Australian data
easier. This includes:

- tidy versions of common structures used by the Australian Bureau of
  Statistics (ABS), like ANZSIC and ANZSCO:

- a function to tidy up state names (`clean_states()`);

- a function that knows whether particular dates are public holidays
  (`is_holiday()`); and

- a table containing the start and end dates of school terms in each
  state and territory, back to 1978 (`school_terms`).

This package is currently **in development** and subject to change. The
lifecycle badge will be changed to `stable` when it is stable (should be
relatively soon).

**Contribute to this package**: people are actively encouraged to
contribute to this package.

## Installation

You can install the current version of `strayr` with:

``` r
remotes::install_github("runapp-aus/strayr")
```

## Structures

Current structures stored in `strayr` are:

- Australian and New Zealand Standard Classification of Occupations
  (**ANZSCO**), Cat. 1220.0:
  - `anzsco2022`: occupation levels of ANZSCO,
    [2022](https://www.abs.gov.au/statistics/classifications/anzsco-australian-and-new-zealand-standard-classification-occupations/2022).
  - `anzsco2021`: occupation levels of ANZSCO,
    [2021](https://www.abs.gov.au/statistics/classifications/anzsco-australian-and-new-zealand-standard-classification-occupations/2021).
  - `anzsco2019`: occupation levels of ANZSCO, [2013, Version
    1.3](https://www.abs.gov.au/AUSSTATS/abs@.nsf/allprimarymainfeatures/FCC055588D3EBA19CA2584A8000E7889?opendocument).
  - `anzsco2013`: occupation levels of ANZSCO, [2013, Version
    1.2](https://www.abs.gov.au/AUSSTATS/abs@.nsf/allprimarymainfeatures/4AF138F6DB4FFD4BCA2571E200096BAD?opendocument).
  - `anzsco2009`: occupation levels ANZSCO, [First Edition, Revision 1,
    2009](https://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/1220.0First%20Edition,%20Revision%201?OpenDocument).
- Australian and New Zealand Standard Industrial Classification
  (**ANZSIC**), Cat. 1292.0:
  - `anzsic2006`: industry levels of ANZSIC, [2006 (Revision
    2.0)](https://www.abs.gov.au/statistics/classifications/australian-and-new-zealand-standard-industrial-classification-anzsic/2006-revision-2-0).
- Australian Standard Classification of Education (**ASCED**), Cat.
  1272.0:
  - `asced_foe2001`: field of education levels of ASCED,
    [2001](https://www.abs.gov.au/ausstats/abs@.nsf/mf/1272.0).
  - `asced_qual2001`: qualification levels of ASCED,
    [2001](https://www.abs.gov.au/ausstats/abs@.nsf/mf/1272.0).

## Converting state names and abbreviations

The `clean_state()` function makes it easy to wrangle vectors of State
names and abbreviations - which might be in different forms and possibly
misspelled.

## Australian public holidays

This package includes the `auholidays` dataset from the [Australian
Public Holidays Dates Machine Readable
Dataset](https://data.gov.au/data/dataset/australian-holidays-machine-readable-dataset)
as well as a helper function `is_holiday`.

## Australian school terms

This package includes a dataset with the start and end dates of school
terms in each Australian state and territory from 1978 to 2024:

``` r
school_terms
#> # A tibble: 1,504 × 5
#>    state  year  term start      end       
#>    <chr> <int> <int> <date>     <date>    
#>  1 NSW    1978     1 1978-02-01 1978-05-05
#>  2 Vic    1978     1 1978-02-06 1978-05-12
#>  3 Qld    1978     1 1978-01-23 1978-04-28
#>  4 SA     1978     1 1978-02-06 1978-05-12
#>  5 WA     1978     1 1978-02-06 1978-05-12
#>  6 Tas    1978     1 1978-02-21 1978-05-26
#>  7 NT     1978     1 1978-02-06 1978-05-12
#>  8 ACT    1978     1 1978-02-01 1978-05-05
#>  9 NSW    1978     2 1978-05-22 1978-08-25
#> 10 Vic    1978     2 1978-05-29 1978-08-25
#> # ℹ 1,494 more rows
```

## Parsing income ranges

The `parse_income_range` function provides some tools for extracting
numbers from income ranges commonly used in Australian data. For
example:

``` r
parse_income_range("$1-$199 ($1-$10,399)", limit = "lower")
#> [1] 1
```

## Accessing ABS mapping structures

The `strayr` package also provides tools to access `sf` objects
contained in [`absmapsdata`](https://github.com/wfmackey/absmapsdata).
See `?strayr::read_absmap` for more information.

``` r
read_absmap("sa42021")
```
