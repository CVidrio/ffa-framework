# Set seed for reproducibility
set.seed(1)

# NOTE: Tolerance is high due to randomness in the bootstrap
test_that("Test bbmk-test.R on data set #2", {

	# Load dataset and run BB-MK test with profiling
	df_clean <- data2$df_clean
	# start <- Sys.time()
	results <- bbmk_test(df_clean$max)
	# end <- Sys.time()
	# print(end - start)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(p_value, 0.2105, tolerance = 2e-2)
	expect_equal(unname(bounds), c(-1862, 1698), tolerance = 2e-2)
	
})


test_that("Test bbmk-test.R on data set #3.3", {

	# Load dataset and run BB-MK test
	df_clean <- data3_3$df_clean
	results <- bbmk_test(df_clean$max)
	list2env(results, envir = environment())

	# Ensure the test results are the same as MATLAB
	expect_equal(p_value, 8e-6, tolerance = 2e-2)
	expect_equal(unname(bounds), c(-902, 894), tolerance = 2e-2)
	
})
