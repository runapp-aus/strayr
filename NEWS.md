# strayr (development version)
* `create read_correspondence_tbl()` reads correspondence tables from
`absmapsdata` similarly to `read_absmap()`
* updated `anzsco2006` to include leading zeros in codes (see ). This is a backwards incompatible change that may cause issues (not enough for a major version progression)

# strayr 0.2.2
* `anzsco2022` updated to reflect changes made by the ABS

# strayr 0.2.1
* adds `anzsco2022` dataset

# strayr 0.2.0
* adds `school_terms` dataset

# strayr 0.1.7
* `state_name_au` and `state_abb_au` added
* aus_seasons() added by @carlosyanez. Thank you!

# strayr 0.1.6
* `parse_income_range` has been refactored to be quicker

# strayr 0.1.5
* Addition of 'unofficial' colors as a return value to `clean_state`
* Addition of 'unofficial' colors as palette_state_name_2016

# strayr 0.1.4
* `strip_year_suffix` function added and provided as an option in `read_absmap`.
* `anzsco2013` and `anzsco2019` added

# strayr 0.1.3
* `read_absmap` function added
* `absmapsdata` depend removed

# strayr 0.1.2
* Package renamed from `abscorr` to `strayr`.
* `parse_income_range` added

# abscorr 0.1.1
* Functions from `strayr` package to wrangle state names + public holidays added

# abscorr 0.1.0
* use pkgdown for documentation
* Added a `NEWS.md` file to track changes to the package
* Import SEIFA scores for various spatial geometries
