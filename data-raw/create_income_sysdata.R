# Create lookup tables of state names and abbreviations
library(tidyverse)

read_csv("inst/extdata/census-income-2016.csv", skip = 9) %>%
  pull(income = 2)



