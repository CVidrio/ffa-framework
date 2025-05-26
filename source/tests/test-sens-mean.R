test_that("Test sens-estimator.R on means of data set #1", {

	# Load the data for the means
	df_clean <- data1$df_clean
	results <- sens_estimator(df_clean$max, df_clean$year)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
  	expect_equal(sens_slope, 1.1628, tolerance = 1e-3)
	expect_equal(sens_intercept, -477.5581, tolerance = 1e-3)

})


test_that("Test sens-estimator.R on means of data set #2", {

	# Load the data for the means
	df_clean <- data2$df_clean
	results <- sens_estimator(df_clean$max, df_clean$year)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
  	expect_equal(sens_slope, -13.8571, tolerance = 1e-3)
	expect_equal(sens_intercept, 2.9026e4, tolerance = 1e-3)

})

 
test_that("Test sens-estimator.R on means of data set #3.1", {

	# Load the data for the means
	df_clean <- data3_1$df_clean
	results <- sens_estimator(df_clean$max, df_clean$year)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
  	expect_equal(sens_slope, -0.4882, tolerance = 1e-3)
	expect_equal(sens_intercept, 1.1597e3, tolerance = 1e-3)

})


test_that("Test sens-estimator.R on means of data set #3.2", {

	# Load the data for the means
	df_clean <- data3_2$df_clean
	results <- sens_estimator(df_clean$max, df_clean$year)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
  	expect_equal(sens_slope, 0.1370, tolerance = 1e-3)
	expect_equal(sens_intercept, -200.4634, tolerance = 1e-3)

})


test_that("Test sens-estimator.R on means of data set #3.3", {

	# Load the data for the means
	df_clean <- data3_3$df_clean
	results <- sens_estimator(df_clean$max, df_clean$year)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
  	expect_equal(sens_slope, 0.4039, tolerance = 1e-3)
	expect_equal(sens_intercept, -756.2370, tolerance = 1e-3)

})
