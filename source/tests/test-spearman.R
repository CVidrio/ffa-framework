test_that("Test spearman-test.R on data set #1", {

	# Load dataset and run Spearman test
	df_clean <- data1$df_clean
	results <- spearman_test(df_clean$max)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(least_lag, 0)
	
})


test_that("Test spearman-test.R on data set #2", {

	# Load dataset and run Spearman test
	df_clean <- data2$df_clean
	results <- spearman_test(df_clean$max)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(least_lag, 16)
	
})


test_that("Test spearman-test.R on data set #3.1", {

	# Load dataset and run Spearman test
	df_clean <- data3_1$df_clean
	results <- spearman_test(df_clean$max)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(least_lag, 0)
	
})


test_that("Test spearman-test.R on data set #3.2", {

	# Load dataset and run Spearman test
	df_clean <- data3_2$df_clean
	results <- spearman_test(df_clean$max)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(least_lag, 0)
	
})


test_that("Test spearman-test.R on data set #3.3", {

	# Load dataset and run Spearman test
	df_clean <- data3_3$df_clean
	results <- spearman_test(df_clean$max)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(least_lag, 4)
	
})
