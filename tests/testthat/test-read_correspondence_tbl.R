test_that("read_correspondence_tbl() retrieves objects", {
  skip_on_cran()
  skip_if_offline()

  sa4_corr <- read_correspondence_tbl("sa4", 2011, "sa4", 2016)
  expect_s3_class(sa4_corr, "tbl")
  expect_identical(
    names(sa4_corr),
    c("SA4_CODE_2011",
      "SA4_NAME_2011",
      "SA4_CODE_2016",
      "SA4_NAME_2016",
      "ratio",
      "PERCENTAGE")
  )
})

test_that("read_correspondence_tbl() input checking works", {
  expect_error(
    read_correspondence_tbl("sa4", 2011, "sa4", 2016, export_dir = "this-doesnt-exist"),
    regexp = "does not exist"
  )
})

test_that("caching for read_correspondence_tbl() works", {
  skip_on_cran()
  skip_if_offline()

  read_correspondence_tbl("sa4", 2011, "sa4", 2016)
  # will be cached
  expect_message(read_correspondence_tbl("sa4", 2011, "sa4", 2016), regexp = "Reading")


  new_dir <- file.path(tempdir(), "test-data")
  dir.create(new_dir)
  # will have to download again
  expect_silent(read_correspondence_tbl("sa4", 2011, "sa4", 2016, export_dir = new_dir))
  # will be cached
  expect_message(read_correspondence_tbl("sa4", 2011, "sa4", 2016, export_dir = new_dir))

  unlink(new_dir)
})
