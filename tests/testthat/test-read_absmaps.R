test_that("read_absmaps() retrieves objects", {

  skip_on_cran()
  skip_if_offline()

  expect_type(read_absmap("sa42016"), "list")
  expect_identical(read_absmap("SA42016"),
                   read_absmap("sa42016"))

  expect_identical(names(read_absmap("state2021")),
                   c("state_code_2021",
                     "state_name_2021",
                     "areasqkm_2021",
                     "cent_lat",
                     "cent_long",
                     "geometry"))
})

test_that("read_absmaps() remove_year_suffix param works", {

  skip_on_cran()
  skip_if_offline()

  expect_identical(names(read_absmap("sa42016", remove_year_suffix = TRUE)),
                   c("sa4_code", "sa4_name", "gcc_code", "gcc_name",
                     "state_code", "state_name", "areasqkm", "cent_long",
                     "cent_lat", "geometry"))
})


test_that("read_absmaps() input checking works", {

  # errors
  expect_error(read_absmap(), regexp = "Please")
  expect_error(read_absmap(area = "sa2"), regexp = "Please")
  expect_error(read_absmap(year = 2011), regexp = "Please")
  expect_error(read_absmap(name = "sa42021", export_dir = "this-doesnt-exist"),
               regexp = "does not exist")

})

test_that("read_absmaps() name checking works", {

  # errors
  expect_error(read_absmap(name = "hello"), regexp = "Applicable files")

})

test_that("caching for read_absmaps() works", {

  skip_on_cran()
  skip_if_offline()

  new_dir <- file.path(tempdir(), "test-data")
  dir.create(new_dir)

  read_absmap("sa42021")
  # will be cached
  expect_message(read_absmap("sa42021"), regexp = "Reading")

  # will have to download again
  expect_silent(read_absmap("sa42021", export_dir = new_dir))
  # will be cached
  expect_message(read_absmap("sa42021", export_dir = new_dir))

  unlink(new_dir)

})


