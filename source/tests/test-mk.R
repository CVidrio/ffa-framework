library(testthat)

test_that("Test mk-test.R on data set #1", {

	# Load dataset and run MK test
	df <- load("Application_1.csv")
	results <- mk_test(df, 0.05)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(s, 165)
	expect_equal(s_variance, 1.196e5, tolerance = 1e2)
	expect_equal(p_value, 0.635, tolerance = 1e-3)

})

test_that("Test mk-test.R on data set #2", {

	# Load dataset and run MK test
	df <- load("Application_2.csv")
	results <- mk_test(df, 0.05)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(s, -1398)
	expect_equal(s_variance, 8.5071e4, tolerance = 1e2)
	expect_equal(p_value, 0, tolerance = 1e-3)

})


test_that("Test mk-test.R on data set #3.1", {

	# Load dataset and run MK test
	df <- load("Application_3.1.csv")
	results <- mk_test(df, 0.05)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(s, -1035)
	expect_equal(s_variance, 145817, tolerance = 1e2)
	expect_equal(p_value, 0.0068, tolerance = 1e-3)

})


test_that("Test mk-test.R on data set #3.2", {

	# Load dataset and run MK test
	df <- load("Application_3.2.csv")
	results <- mk_test(df, 0.05)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(s, 518)
	expect_equal(s_variance, 7.9617e4, tolerance = 1e2)
	expect_equal(p_value, 0.0669, tolerance = 1e-3)

})


test_that("Test mk-test.R on data set #3.3", {

	# Load dataset and run MK test
	df <- load("Application_3.3.csv")
	results <- mk_test(df, 0.05)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(s, 1822)
	expect_equal(s_variance, 102933, tolerance = 1e2)
	expect_equal(p_value, 0, tolerance = 1e-3)

})



