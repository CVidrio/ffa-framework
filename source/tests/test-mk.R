library(testthat)

test_that("Test mk-test.R on data set #1", {

	# Load dataset and run MK test
	df_clean <- data1$df_clean 
	results <- mk_test(df_clean$max)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(s, 165)
	expect_equal(s_variance, 1.1956e5, tolerance = 1)
	expect_equal(p_value, 0.635, tolerance = 1e-3)

})

test_that("Test mk-test.R on data set #2", {

	# Load dataset and run MK test
	df_clean <- data2$df_clean 
	results <- mk_test(df_clean$max)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(s, -1398)
	expect_equal(s_variance, 8.5071e4, tolerance = 1)
	expect_equal(p_value, 0, tolerance = 1e-3)

})

test_that("Test mk-test.R on data set #3.1", {

	# Load dataset and run MK test
	df_clean <- data3_1$df_clean 
	results <- mk_test(df_clean$max)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(s, -1035)
	expect_equal(s_variance, 145817, tolerance = 1)
	expect_equal(p_value, 0.0068, tolerance = 1e-3)

})

test_that("Test mk-test.R on data set #3.2", {

	# Load dataset and run MK test
	df_clean <- data3_2$df_clean 
	results <- mk_test(df_clean$max)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(s, 518)
	expect_equal(s_variance, 7.9617e4, tolerance = 1)
	expect_equal(p_value, 0.0669, tolerance = 1e-3)

})

test_that("Test mk-test.R on data set #3.3", {

	# Load dataset and run MK test
	df_clean <- data3_3$df_clean 
	results <- mk_test(df_clean$max)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(s, 1822)
	expect_equal(s_variance, 102933, tolerance = 1)
	expect_equal(p_value, 0, tolerance = 1e-3)

})



