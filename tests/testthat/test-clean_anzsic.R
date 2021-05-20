test_that("clean_anzsic works as intended", {
  # Check that it matches with and &
  expect_equal(clean_anzsic("Agriculture forestry & Fishing"), "Agriculture, Forestry and Fishing")
  # Check that it doesn't match when looking for exact match
  expect_equal(clean_anzsic("Agriculture, Forestry", silent = TRUE), NA_character_)
  # Check that it does match when looking for fuzzy match
  expect_equal(clean_anzsic("Agriculture, Forestry", fuzzy_match = TRUE), "Agriculture, Forestry and Fishing")
  # Test class is as expected
  expect_is(clean_anzsic("Agriculture forestry & Fishing"), "character")
  # Test length
  expect_length(clean_anzsic(c("Agriculture forestry & Fishing", "Other services")), 2)
})


test_that("clean_anzsic appropriately warns when can't find a match", {
  x <- c("Agriculture forestry & Fishing", "Other services", "non-anzsic", "another-non-anzsic")
  expect_warning(y <- clean_anzsic(x))
  expect_equal(length(y), length(x))
})
