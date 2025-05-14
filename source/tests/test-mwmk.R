library(testthat)

test_that("Test mwmk-test.R on data set #1", {

	# Load dataset and run MK test
	df_variance <- data1$df_variance 
	results <- mwmk_test(df_variance$std)
	list2env(results, envir = environment())

	# Test that the var is equivalent (this dataset only)
	expect_equal(std, c(
		745.171,
		492.819,
		590.699,
		814.666,
		368.347,
		1091.63,
		1194.07,
		1331.44,
		1256.36,
		716.991,
		1111.76,
		992.558,
		875.702,
		1173.87,
		963.863,
		678.473,
		652.974,
		486.122,
		912.038,
		957.871
	), tolerance = 1e-2)

	# Ensure the test results are the same as MATLAB
	expect_equal(s_statistic, 2)
	expect_equal(s_variance, 950, tolerance = 1)
	expect_equal(p_value, 0.9741, tolerance = 1e-3)

})

test_that("Test mwmk-test.R on data set #2", {

	# Load dataset and run MK test
	df_variance <- data2$df_variance 
	results <- mwmk_test(df_variance$std)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(s_statistic, -70)
	expect_equal(s_variance, 589.3333, tolerance = 1)
	expect_equal(p_value, 0.0045, tolerance = 1e-3)

})

test_that("Test mwmk-test.R on data set #3.1", {

	# Load dataset and run MK test
	df_variance <- data3_1$df_variance 
	results <- mwmk_test(df_variance$std)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(s_statistic, -2)
	expect_equal(s_variance, 1.0967e3, tolerance = 1)
	expect_equal(p_value, 0.9759, tolerance = 1e-3)

})

test_that("Test mwmk-test.R on data set #3.2", {

	# Load dataset and run MK test
	df_variance <- data3_2$df_variance 
	results <- mwmk_test(df_variance$std)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(s_statistic, 85)
	expect_equal(s_variance, 697, tolerance = 1)
	expect_equal(p_value, 0.0015, tolerance = 1e-3)

})

test_that("Test mwmk-test.R on data set #3.3", {

	# Load dataset and run MK test
	df_variance <- data3_3$df_variance 
	results <- mwmk_test(df_variance$std)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(s_statistic, 81)
	expect_equal(s_variance, 697, tolerance = 1)
	expect_equal(p_value, 0.0024, tolerance = 1e-3)

})


