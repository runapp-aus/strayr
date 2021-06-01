
valid_income_ranges <- c(
  # Census 2011
  "$1-$199 ($1-$10,399)",
  "$200-$299 ($10,400-$15,599)",
  "$300-$399 ($15,600-$20,799)",
  "$400-$599 ($20,800-$31,199)",
  "$600-$799 ($31,200-$41,599)",
  "$800-$999 ($41,600-$51,999)",
  "$1,000-$1,249 ($52,000-$64,999)",
  "$1,250-$1,499 ($65,000-$77,999)",
  "$1,500-$1,999 ($78,000-$103,999)",
  # Census 2016
  "$1-$149 ($1-$7,799)",
  "$150-$299 ($7,800-$15,599)",
  "$300-$399 ($15,600-$20,799)",
  "$400-$499 ($20,800-$25,999)",
  "$500-$649 ($26,000-$33,799)",
  "$650-$799 ($33,800-$41,599)",
  "$800-$999 ($41,600-$51,999)",
  "$1,000-$1,249 ($52,000-$64,999)",
  "$1,250-$1,499 ($65,000-$77,999)",
  "$1,500-$1,749 ($78,000-$90,999)",
  "$1,750-$1,999 ($91,000-$103,999)",
  "$2,000-$2,999 ($104,000-$155,999)",
  # ATO PIT 2018
  "b. $18,201 to $37,000",
  "c. $37,001 to $87,000",
  "d. $87,001 to $180,000",
  # Other
  "Between $10,000 and $90,000",
  "from $10,000 to $90,000, about $50,000 annually",
  "AU$2000-AU$3000"
)

or_more <- c(
  "$2,000 or more ($104,000 or more)",
  "$3,000 or more ($156,000 or more)",
  "e. $180,001 or more"
)

or_less <- c("a. $18,200 or less")

diff_dollar <- c(
  "AUD50000 to AUD90000"
)

negative <- "Negative income"

nil <- "Nil income"

na <- c(
  "Not stated",
  "Not applicable",
  "Total",
  "10000"
)

all_incomes <- c(
  valid_income_ranges,
  or_more,
  or_less,
  negative,
  nil,
  na
)

test_that("parse_income_range works on valid ranges", {
  # Lower
  expect_equal(parse_income_range(valid_income_ranges[1]),
               1)
  # Upper
  expect_equal(parse_income_range(valid_income_ranges[5],
                                  limit = "upper"),
               799)
  # Mid
  expect_equal(parse_income_range(valid_income_ranges[7],
                                  limit = "mid"),
               1125)
  # max income
  expect_equal(parse_income_range(or_more[3],
                                  limit = "upper"),
               180001)
  expect_equal(parse_income_range(or_more[1],
                                  limit = "upper",
                                  max_income = 3000),
               3000)
  expect_equal(parse_income_range(or_more[2],
                                  limit = "mid",
                                  max_income = 4000),
               3500)

  # different dollar
  expect_equal(parse_income_range(diff_dollar,
                                  dollar_prefix = "AUD"),
               50000)
  expect_equal(parse_income_range(diff_dollar,
                                  dollar_prefix = "AUD",
                                  limit = "upper"),
               90000)

  # all valid should work:
  expect_false(any(is.na(
        parse_income_range(c(valid_income_ranges, or_more, or_less),
                           limit = "lower"))
        ))

  expect_false(any(is.na(
    parse_income_range(c(valid_income_ranges, or_more, or_less),
                       limit = "upper"))
  ))
})


test_that("parse_income_range works as expected on invalid ranges", {

  # No INCOMES return NA
  expect_true(is.na(parse_income_range("1000-2000")))
  # Negative is zero
  expect_equal(parse_income_range(negative[1]),
               0)
  # Negative is NA
  expect_true(is.na(parse_income_range(negative[1],
                                       negative_as_zero = FALSE)))
  # NAs are doubles
  expect_type(parse_income_range(na),
              "double")
  # Returns a double vector
  expect_type(parse_income_range(valid_income_ranges),
              "double")
  # Returns the right number of elements
  expect_length(parse_income_range(all_incomes),
                length(all_incomes))
  # Messages
  expect_silent(parse_income_range(all_incomes))
  expect_message(parse_income_range(all_incomes, .silent = FALSE))
})
