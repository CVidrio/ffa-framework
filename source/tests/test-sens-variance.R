test_that("Test sens-estimator.R on variances of data set #1", {

	# Load the data for the variances
	df_variance <- data1$df_variance
	results <- sens_estimator(df_variance$std, df_variance$year)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
  	expect_equal(sens_slope, 0.8474, tolerance = 1e-3)
	expect_equal(sens_intercept, -794.4911, tolerance = 1e-3)

})


test_that("Test sens-estimator.R on variances of data set #2", {

	# Load the data for the variances
	df_variance <- data2$df_variance
	results <- sens_estimator(df_variance$std, df_variance$year)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
  	expect_equal(sens_slope, -3.4902, tolerance = 1e-3)
	expect_equal(sens_intercept, 7.3114e3, tolerance = 1e-3)

})


test_that("Test sens-estimator.R on variances of data set #3.1", {

	# Load the data for the variances
	df_variance <- data3_1$df_variance
	results <- sens_estimator(df_variance$std, df_variance$year)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
  	expect_equal(sens_slope, -0.0094, tolerance = 1e-3)
	expect_equal(sens_intercept, 71.6560, tolerance = 1e-3)

})


test_that("Test sens-estimator.R on variances of data set #3.2", {

	# Load the data for the variances
	df_variance <- data3_2$df_variance
	results <- sens_estimator(df_variance$std, df_variance$year)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
  	expect_equal(sens_slope, 0.2260, tolerance = 1e-3)
	expect_equal(sens_intercept, -424.3596, tolerance = 1e-3)

})


test_that("Test sens-estimator.R on variances of data set #3.3", {

	# Load the data for the variances
	df_variance <- data3_3$df_variance
	results <- sens_estimator(df_variance$std, df_variance$year)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
  	expect_equal(sens_slope, 0.1346, tolerance = 1e-3)
	expect_equal(sens_intercept, -249.9469, tolerance = 1e-3)

})
