test_that("clean_nfd produces expected output", {
  
  test_vec <- c("Furniture Manufacturing, nfd", "Surgeons", "Pharmacists", '100000')
  
  expect_equal(clean_nfd(test_vec), 
               c("Furniture Manufacturing", "Surgeons", "Pharmacists", '1'))
  
  expect_equal(clean_nfd('2400'), 
               '24')
  
  expect_equal(clean_nfd('Education Professionals, nfd'), 
               'Education Professionals')
  
  expect_length(clean_nfd(test_vec), 4)
  
  expect_length(clean_nfd('2400'), 1)
})
