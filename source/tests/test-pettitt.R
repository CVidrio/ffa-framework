library(testthat)

test_that("Test pettitt-test.R on data set #1", {

	# Load dataset and run Pettitt test
	df <- load("Application_1.csv")
	results <- pettitt_test(df, 0.05)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(length(u_t), 102)
  	expect_equal(k, 372)
	expect_equal(k_alpha, 731.467, tolerance = 1e-3)
	expect_equal(p_value, 0.461, tolerance = 1e-3)

})

test_that("Test pettitt-test.R on data set #2", {

	# Load dataset and run Pettitt test
	df <- load("Application_2.csv")
	results <- pettitt_test(df, 0.05)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(length(u_t), 91)
  	expect_equal(k, 1871)
	expect_equal(k_alpha, 616.753, tolerance = 1e-3)
	expect_equal(p_value, 0, tolerance = 1e-3)

})

test_that("Test pettitt-test.R on data set #3.1", {

	# Load dataset and run Pettitt test
	df <- load("Application_3.1.csv")
	results <- pettitt_test(df, 0.05)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(length(u_t), 109)
  	expect_equal(k, 914)
	expect_equal(k_alpha, 807.790, tolerance = 1e-3)
	expect_equal(p_value, 0.022, tolerance = 1e-3)

})

test_that("Test pettitt-test.R on data set #3.2", {

	# Load dataset and run Pettitt test
	df <- load("Application_3.2.csv")
	results <- pettitt_test(df, 0.05)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(length(u_t), 89)
  	expect_equal(k, 561)
	expect_equal(k_alpha, 596.605, tolerance = 1e-3)
	expect_equal(p_value, 0.071, tolerance = 1e-3)

})

test_that("Test pettitt-test.R on data set #3.3", {

	# Load dataset and run Pettitt test
	df <- load("Application_3.3.csv")
	results <- pettitt_test(df, 0.05)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(length(u_t), 97)
  	expect_equal(k, 1381)
	expect_equal(k_alpha, 678.517, tolerance = 1e-3)
	expect_equal(p_value, 0, tolerance = 1e-3)

})
