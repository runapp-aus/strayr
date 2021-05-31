test_that("is_holiday returns expected output for single numbers", {
  # Test 2020 numbers
  expect_true(is_holiday("2020-01-01"))
  expect_false(is_holiday("2020-01-19"))

  # Test 2014 numbers
  expect_true(is_holiday("2014-06-09"))

  # Test jurisdiction only
  expect_true(is_holiday("2019-05-27", jurisdictions = c("ACT", "NSW")))
  expect_false(is_holiday("2019-05-27", jurisdictions = c("TAS")))

  # Test with time
  expect_true(is_holiday("2020-01-01 12:45"))
})

test_that("is_holiday returns errors for poor values", {
  expect_error(is_holiday(NA))
  expect_error(is_holiday("Australia Day"))
})
