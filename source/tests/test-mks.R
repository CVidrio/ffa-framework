library(testthat)

test_that("Test mks-test.R on data set #1", {

	# Load dataset and run MKS test
	df_clean <- data1$df_clean	
	results <- mks_test(df_clean$max, df_clean$year)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(length(s_prog), 102)
	expect_equal(length(s_regr), 102)
	expect_equal(length(cross), 6)
	expect_equal(p_value, 0.237, tolerance = 1e-3)

	# Additional tests for this dataset only
	expect_equal(bound, 1.960, tolerance = 1e-3)
	expect_equal(cross, c(6, 36, 38, 41, 42, 54))
	expect_equal(y_cross, c(-1.18, 0.36, 0.24, 0.54, 0.44, 0.72), tolerance = 1e-2)

})

test_that("Test mks-test.R on data set #2", {

	# Load dataset and run MKS test
	df_clean <- data2$df_clean	
	results <- mks_test(df_clean$max, df_clean$year)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(length(s_prog), 91)
	expect_equal(length(s_regr), 91)
	expect_equal(length(cross), 2)
	expect_equal(p_value, 0.015, tolerance = 1e-3)

})

test_that("Test mks-test.R on data set #3.1", {

	# Load dataset and run MKS test
	df_clean <- data3_1$df_clean	
	results <- mks_test(df_clean$max, df_clean$year)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(length(s_prog), 109)
	expect_equal(length(s_regr), 109)
	expect_equal(length(cross), 0)
	expect_equal(p_value, 1)

})

test_that("Test mks-test.R on data set #3.2", {

	# Load dataset and run MKS test
	df_clean <- data3_2$df_clean	
	results <- mks_test(df_clean$max, df_clean$year)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(length(s_prog), 89)
	expect_equal(length(s_regr), 89)
	expect_equal(length(cross), 6)
	expect_equal(p_value, 0.156, tolerance = 1e-3)

})

test_that("Test mks-test.R on data set #3.3", {

	# Load dataset and run MKS test
	df_clean <- data3_3$df_clean	
	results <- mks_test(df_clean$max, df_clean$year)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(length(s_prog), 97)
	expect_equal(length(s_regr), 97)
	expect_equal(length(cross), 0)
	expect_equal(p_value, 1)

})
