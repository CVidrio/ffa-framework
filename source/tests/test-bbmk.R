library(testthat)

# NOTE: The BB-MK test uses bootstrapping which introduces randomness
# Therefore, these unit tests have higher tolerance than the other ones
# Additionally, the MATLAB scripts only run this test if least_lag > 0
# Therefore, we only unit test on datasets #2 and #3.3

test_that("Test bbmk-test.R on data set #2", {

	# Set seed for reproducibility
	set.seed(1)

	# Load dataset and run BB-MK test
	df_clean <- data2$df_clean
	results <- bbmk_test(df_clean$max)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(p_value, 0.2130, tolerance = 0.02)
	expect_equal(unname(bounds), c(-1862, 1680), tolerance = 50)
	
})

test_that("Test bbmk-test.R on data set #3.3", {

	# Set seed for reproducibility
	set.seed(1)

	# Load dataset and run BB-MK test
	df_clean <- data3_3$df_clean
	results <- bbmk_test(df_clean$max)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(p_value, 2e-4, tolerance = 0.02)
	expect_equal(unname(bounds), c(-927, 908), tolerance = 50)
	
})
