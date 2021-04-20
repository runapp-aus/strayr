
column_names <- c("seifa_index",
                  "spatial_area",
                  'area_code',
                  'area_name',
                  'population',
                  'score',
                  'rank_aus',
                  'decile_aus',
                  'percentile_aus',
                  'state',
                  'rank_state',
                  'decile_state',
                  'percentile_state',
                  'min_score_sa1_area',
                  'max_score_sa1_area',
                  'percent_usual_resident_pop_without_sa1_score')


test_that("can Import SEIFA LGA scores", {
  df <- seifa_scores(spatial_area = 'lga')

  expect_is(df, 'data.frame')
  expect_equal(colnames(df), column_names)

})


test_that('sa1 spreadsheet can be parsed', {
  df <- get_seifa_index_sheet(system.file('extdata',
                                          'sa1_seifa_indexes_test.xls',
                                          package = 'abscorr',
                                          mustWork = TRUE),
                              'Table 2',
                              'sa1')

  expect_is(df, 'data.frame')
  expect_equal(colnames(df), c('spatial_area',
                               'sa1_7_code',
                               'sa1_11_code',
                               'population',
                               'score',
                               'rank_aus',
                               'decile_aus',
                               'percentile_aus',
                               'state',
                               'rank_state',
                               'decile_state',
                               'percentile_state'))

})
