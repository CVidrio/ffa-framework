test_that("Test white-test.R on data set #1", {

	# Load dataset and run White test
	df_clean <- data1$df_clean
	results <- white_test(df_clean$max, df_clean$year)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(r_squared, 0.0110, tolerance = 1e-3)
	expect_equal(test_statistic, 1.1197, tolerance = 1e-3)
	expect_equal(p_value, 0.5713, tolerance = 1e-3)

})


test_that("Test white-test.R on data set #2", {

	# Load dataset and run White test
	df_clean <- data2$df_clean
	results <- white_test(df_clean$max, df_clean$year)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(r_squared, 0.1019, tolerance = 1e-3)
	expect_equal(test_statistic, 9.2726, tolerance = 1e-3)
	expect_equal(p_value, 0.0097, tolerance = 1e-3)

})


test_that("Test white-test.R on data set #3.1", {

	# Load dataset and run White test
	df_clean <- data3_1$df_clean
	results <- white_test(df_clean$max, df_clean$year)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(r_squared, 0.0447, tolerance = 1e-3)
	expect_equal(test_statistic, 4.8747, tolerance = 1e-3)
	expect_equal(p_value, 0.0874, tolerance = 1e-3)

})


test_that("Test white-test.R on data set #3.2", {

	# Load dataset and run White test
	df_clean <- data3_2$df_clean
	results <- white_test(df_clean$max, df_clean$year)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(r_squared, 0.0481, tolerance = 1e-3)
	expect_equal(test_statistic, 4.2810, tolerance = 1e-3)
	expect_equal(p_value, 0.1176, tolerance = 1e-3)

})


test_that("Test white-test.R on data set #3.3", {

	# Load dataset and run White test
	df_clean <- data3_3$df_clean
	results <- white_test(df_clean$max, df_clean$year)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(r_squared, 0.0415, tolerance = 1e-3)
	expect_equal(test_statistic, 4.0246, tolerance = 1e-3)
	expect_equal(p_value, 0.1337, tolerance = 1e-3)

})
