# Define columns for each spreadsheet.
column_names <- list( '2011' = list( 'sa1' = c('structure',
                                               'sa1_7_code',
                                               'population',
                                               'score',
                                               'rank_aus',
                                               'decile_aus',
                                               'percentile_aus',
                                               'state',
                                               'rank_state',
                                               'decile_state',
                                               'percentile_state'),
                                     'sa2' =c('structure',
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
                                              'percent_usual_resident_pop_without_sa1_score'),
                                     'lga' = c('structure',
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
                                               'percent_usual_resident_pop_without_sa1_score'),
                                     'postcode' = c('structure',
                                                    'area_code',
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
                                                    'percent_usual_resident_pop_without_sa1_score'),
                                     'suburb' = c('structure',
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
                                     ),
                      '2016' = list( 'sa1' = c('structure',
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
                                               'percentile_state'),
                                     'sa2' =c('structure',
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
                                              'percent_usual_resident_pop_without_sa1_score'),
                                     'lga' = c('structure',
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
                                               'percent_usual_resident_pop_without_sa1_score'),
                                     'postcode' = c('structure',
                                                    'area_code',
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
                                                    'percent_usual_resident_pop_without_sa1_score',
                                                    'caution_poor_sa1_representation',
                                                    'postcode_crosses_state_boundary'),
                                     'suburb' = c('structure',
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
                                                  'percent_usual_resident_pop_without_sa1_score',
                                                  'caution_poor_sa1_representation')
                      ),
                      '2021' = list( 'sa1' = c('structure',
                                               'sa1_11_code',
                                               'population',
                                               'score',
                                               'rank_aus',
                                               'decile_aus',
                                               'percentile_aus',
                                               'state',
                                               'rank_state',
                                               'decile_state',
                                               'percentile_state'),
                                     'sa2' =c('structure',
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
                                              'percent_usual_resident_pop_without_sa1_score'),
                                     'lga' = c('structure',
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
                                               'percent_usual_resident_pop_without_sa1_score'),
                                     'postcode' = c('structure',
                                                    'area_code',
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
                                                    'percent_usual_resident_pop_without_sa1_score',
                                                    'caution_poor_sa1_representation',
                                                    'postcode_crosses_state_boundary'),
                                     'suburb' = c('structure',
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
                                                  'percent_usual_resident_pop_without_sa1_score',
                                                  'caution_poor_sa1_representation')
                      )
                    )

release_years <- names(column_names)

for(release_year in release_years){

  test_that(paste0('can Import SEIFA SA1 scores for ', release_year, ' release' ), {

    skip_on_cran()
    skip_if_offline()

    df <- get_seifa(structure = 'sa1', year = release_year)

    expect_is(df, 'data.frame')
    expect_equal(colnames(df), column_names[[release_year]][['sa1']])

  })

  test_that(paste0('can Import SEIFA SA2 scores for ', release_year, ' release' ), {

    skip_on_cran()
    skip_if_offline()

    df <- get_seifa(structure = 'sa2', year = release_year)

    expect_is(df, 'data.frame')
    expect_equal(colnames(df), column_names[[release_year]][['sa2']])

  })


  test_that(paste0('can Import SEIFA LGA scores for ', release_year, ' release'), {

    skip_on_cran()
    skip_if_offline()

    df <- get_seifa(structure = 'lga', year = release_year)

    expect_is(df, 'data.frame')
    expect_equal(colnames(df), column_names[[release_year]][['lga']])

  })


  test_that(paste0('can Import SEIFA postcode scores for ', release_year, ' release' ), {

    skip_on_cran()
    skip_if_offline()

    df <- get_seifa(structure = 'postcode', year = release_year)

    expect_is(df, 'data.frame')
    expect_equal(colnames(df), column_names[[release_year]][['postcode']])

  })

  test_that(paste0('can Import SEIFA suburb scores for ', release_year, ' release' ), {

    skip_on_cran()
    skip_if_offline()

    df <- get_seifa(structure = 'suburb', year = release_year)

    expect_is(df, 'data.frame')
    expect_equal(colnames(df), column_names[[release_year]][['suburb']])

  })

}


test_that('sa1 spreadsheet can be parsed for 2016 release', {
    df <- get_seifa_index_sheet(system.file('extdata',
                                            'sa1_seifa_indexes_test.xls',
                                            package = 'strayr',
                                            mustWork = TRUE),
                                'Table 2',
                                'sa1',
                                year = '2016')

    expect_is(df, 'data.frame')
    expect_equal(colnames(df), column_names[['2016']][['sa1']])
  }
)
