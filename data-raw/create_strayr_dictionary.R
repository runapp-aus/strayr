# Create lookup tables of state names and abbreviations
library(tidyverse)

state_table <- tibble::tribble(
  ~state_name, ~state_abbr,     ~iso, ~postal,
  "New South Wales",       "NSW", "AU-NSW",   "NSW",
  "Queensland",       "Qld", "AU-QLD",   "QLD",
  "South Australia",        "SA",  "AU-SA",    "SA",
  "Tasmania",       "Tas", "AU-TAS",   "TAS",
  "Victoria",       "Vic", "AU-VIC",   "VIC",
  "Western Australia",        "WA",  "AU-WA",    "WA",
  "Australian Capital Territory",       "ACT", "AU-ACT",   "ACT",
  "Northern Territory",        "NT",  "AU-NT",    "NT",
  "Australia",       "Aus",     "AU",    "AU",
  "Other Territories",       "Oth", NA_character_, NA_character_,
  "Total",       "Tot", NA_character_, NA_character_
)


state_or_territory_palette <- c(
  'New South Wales'    = '#87ceeb',
  'Victoria'           = '#000080',
  'Queensland'         = '#800000',
  'South Australia'    = '#dc0014',
  'Western Australia'  = '#fecb29',
  'Tasmania'           = '#006a4e',
  'Northern Territory' = '#e65a00',
  'Australian Capital Territory' = '#94c949',
  'Other Territories' = '#c0c0c0')


state_or_territory_palette_tbl <- enframe(state_or_territory_palette, "state_name", "colour")



state_table <- tibble::tribble(
  ~code,                           ~state_name,
  1,              "New South Wales",
  2,                     "Victoria",
  3,                   "Queensland",
  4,              "South Australia",
  5,            "Western Australia",
  6,                     "Tasmania",
  7,           "Northern Territory",
  8, "Australian Capital Territory",
  9, "Other Territories"
) %>%
  right_join(state_table, by = "state_name") %>%
  right_join(state_or_territory_palette_tbl,  by = "state_name")



state_dict_df <- state_table %>%
  gather(key = "type", value = "alias", -state_abbr)

state_dict_df <- state_table %>%
  select(state_abbr) %>%
  mutate(alias = state_abbr,
         type = "state_abbr") %>%
  bind_rows(state_dict_df)

# create dictionary as character vector
state_dict <- state_dict_df$alias
names(state_dict) <- state_dict_df$state_abbr

state_dict <- c(state_dict,
                "Aus" = "Australia",
                "Aus" = "Aus",
                "Aus" = "Oz",
                "SA" = "south oz",
                "WA" = "west oz",
                "WA" = "double you ay",
                "WA" = "dubyooway",
                "WA" = "westraya",
                "Tas" = "tassie",
                "Tas" = "tazzie",
                "Tas" = "tazzy",
                "Oth" = "Other",
                "Other Territories" = "Other",
                "Oth" = "Oth",
                "Tot" = "Total",
                "Tot" = "Tot")

nospaces <- gsub(" ", "", state_table$state_name)
names(nospaces) <- state_table$state_abbr

state_dict <- c(state_dict, nospaces)

state_dict <- state_dict[!duplicated(state_dict)]

state_dict <- tolower(state_dict)

