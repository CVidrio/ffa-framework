library(testthat)

test_that("Test spearman-test.R on data set #1", {

	# Load dataset and run Spearman test
	df <- load("Application_1.csv")
	results <- spearman_test(df, 0.05)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(least_lag, 0)
	
})

test_that("Test spearman-test.R on data set #2", {

	# Load dataset and run Spearman test
	df <- load("Application_2.csv")
	results <- spearman_test(df, 0.05)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(least_lag, 16)
	
})

test_that("Test spearman-test.R on data set #3.1", {

	# Load dataset and run Spearman test
	df <- load("Application_3.1.csv")
	results <- spearman_test(df, 0.05)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(least_lag, 0)
	
})

test_that("Test spearman-test.R on data set #3.2", {

	# Load dataset and run Spearman test
	df <- load("Application_3.2.csv")
	results <- spearman_test(df, 0.05)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(least_lag, 0)
	
})

test_that("Test spearman-test.R on data set #3.3", {

	# Load dataset and run Spearman test
	df <- load("Application_3.3.csv")
	results <- spearman_test(df, 0.05)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(least_lag, 4)
	
})


