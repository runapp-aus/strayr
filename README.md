
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

-   tidy versions of common structures used by the Australian Bureau of
    Statistics (ABS), like ANZSIC and ANZSCO:

-   a function to tidy up state names (`clean_states()`); and

-   a function that knows whether particular dates are public holidays
    (`is_holiday()`).

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

-   Australian and New Zealand Standard Classification of Occupations
    (**ANZSCO**), Cat. 1220.0:
    -   `anzsco2019`: occupation levels of ANZSCO, [2013, Version
        1.3](https://www.abs.gov.au/AUSSTATS/abs@.nsf/allprimarymainfeatures/FCC055588D3EBA19CA2584A8000E7889?opendocument).
    -   `anzsco2013`: occupation levels of ANZSCO, [2013, Version
        1.2](https://www.abs.gov.au/AUSSTATS/abs@.nsf/allprimarymainfeatures/4AF138F6DB4FFD4BCA2571E200096BAD?opendocument).
    -   `anzsco2009`: occupation levels ANZSCO, [First Edition, Revision
        1,
        2009](https://www.abs.gov.au/AUSSTATS/abs@.nsf/DetailsPage/1220.0First%20Edition,%20Revision%201?OpenDocument).
-   Australian and New Zealand Standard Industrial Classification
    (**ANZSIC**), Cat. 1292.0:
    -   `anzsic2006`: industry levels of ANZSIC, [2006 (Revision
        1.0)](https://www.abs.gov.au/ausstats/abs@.nsf/0/20C5B5A4F46DF95BCA25711F00146D75?opendocument).
-   Australian Standard Classification of Education (**ASCED**), Cat.
    1272.0:
    -   `asced_foe2001`: field of education levels of ASCED,
        [2001](https://www.abs.gov.au/ausstats/abs@.nsf/mf/1272.0).
    -   `asced_qual2001`: qualification levels of ASCED,
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

## Parsing income ranges

The `parse_income_range` function provides some tools for extracting
numbers from income ranges commonly used in Australian data. For
example:

``` r
parse_income_range("$1-$199 ($1-$10,399)", limit = "lower")
#> [1] 1
```

## Accessing ABS mapping structures

The `strayr` package also loads provides tools to access `sf` objects
contained in [`absmapsdata`](https://github.com/wfmackey/absmapsdata).
See `?strayr::read_absmaps`.

``` r
read_absmaps("sa42021")
```
