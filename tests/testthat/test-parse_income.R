
test_that("parse_income works as intended", {
  # Check that it matches with and &
  expect_equal(clean_anzsco("driving instructor"), "Driving Instructor")
  # Check that it doesn't match when looking for exact match
  expect_equal(clean_anzsco("driving", silent = TRUE), NA_character_)
  # Check that it does match when looking for fuzzy match
  expect_equal(clean_anzsco("driving", fuzzy_match = TRUE), "Driving Instructor")
  # Test class is as expected
  expect_is(clean_anzsco("driving instructor"), "character")
  # Test length
  expect_length(clean_anzsco(c("driving instructor", "community and personal Service Workers")), 2)
})


test_that("clean_anzsco appropriately warns when can't find a match", {
  x <- c("driving instructor", "community and personal Service Workers", "non-anzsco", "another-non-anzsco")
  expect_warning(y <- clean_anzsco(x))
  expect_equal(length(y), length(x))
})
