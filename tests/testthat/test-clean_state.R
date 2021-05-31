test_that("clean_state() returns expected output", {

  expect_equal(clean_state(1), "NSW")

  expect_equal(clean_state("1"), "NSW")

  expect_equal(clean_state("NSW", to = "state_abbr"), "NSW")

  expect_equal(clean_state("New South Wales", fuzzy_match = FALSE), "NSW")

  expect_equal(clean_state("Noo Soth Whales"), "NSW")

  expect_equal(clean_state("Noo Soth Whales", fuzzy_match = FALSE), NA_character_)

  expect_equal(class(clean_state("NSW", "code")), "character")

  x <- c("western Straya", "w. A ", "new soth wailes", "SA", "tazz")

  expect_length(clean_state(x), 5)


  expect_equal(clean_state("South Australia"), "SA")
  expect_equal(clean_state("Australia"), "Aus")
  expect_equal(clean_state("South Aus"), "SA")
  expect_equal(clean_state("Aus"), "Aus")

  expect_equal(clean_state("other"), "Oth")
  expect_equal(clean_state("oth"), "Oth")


  expect_equal(clean_state(c("Aus", "NSW", "Vic", "Qld", "WA", "SA", "Tas", "ACT", "NT", "OTH")),
               c("Aus", "NSW", "Vic", "Qld", "WA", "SA", "Tas", "ACT", "NT", "Oth"))

  expect_identical(clean_state("NA"), NA_character_)
  expect_identical(clean_state("n a "), NA_character_)
  expect_equal(clean_state(c("Aus", "SA", "not applicable")),
               c("Aus", "SA", NA_character_))

})

test_that("strayr() returns identical output to clean_state()",{
  state_names <- c("western Straya", "w. A ", "new soth wailes", "SA", "tazz",
                   "Aus", "NSW", "Vic", "Qld", "WA", "SA", "Tas", "ACT", "NT", "OTH")

  expect_identical(clean_state(state_names),
                   suppressWarnings(strayr(state_names)))

  # strayr() should remain deprecated
  expect_warning(strayr(state_names))

})
