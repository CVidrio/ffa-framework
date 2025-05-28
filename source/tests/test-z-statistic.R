# Set seed for reproducibility
set.seed(1)

# NOTE: Tolerance is higher in some tests because of randomness in the bootstrap
test_that("Test z-statistic.R on data set #1", {

	# Load dataset and run Z-statistic selection
	ams <- data1$df_clean$max
	slm <- sample_lm(ams)
	dlm <- distribution_lm()
	results <- z_statistic(slm, dlm, ams)
	list2env(results, envir = environment())

	# Check the Kappa distribution parameters
	expect_equal(params[1], 1656.6551, tol = 1e-4)
	expect_equal(params[2],  567.3440, tol = 1e-4)
	expect_equal(params[3],   -0.1544, tol = 1e-4)
	expect_equal(params[4],   -0.1704, tol = 1e-4)

	# Check the bootstrap summary statistics
	expect_equal(bootstrap$b4,     -0.0026, tol = 5e-3)
	expect_equal(bootstrap$s4,      0.0514, tol = 5e-3)

	# Check the Z-distances
	expect_equal(distance$GEV$metric, -0.2524, tol = 5e-3)
	expect_equal(distance$GLO$metric,  0.3673, tol = 5e-3)
	expect_equal(distance$PE3$metric, -1.0738, tol = 5e-3)
	expect_equal(distance$GNO$metric, -0.5443, tol = 5e-3)
	expect_equal(distance$WEI$metric, -1.3005, tol = 5e-3)
	expect_equal(distance$GPA$metric, -1.8072, tol = 5e-3)

})


test_that("Test z-statistic.R on data set #2", {

	# Load dataset and run Z-statistic selection
	ams <- data2$df_clean$max
	slm <- sample_lm(ams)
	dlm <- distribution_lm()
	results <- z_statistic(slm, dlm, ams)
	list2env(results, envir = environment())

	# Check the Kappa distribution parameters
	expect_equal(params[1],  744.3399, tol = 1e-4)
	expect_equal(params[2], 1479.1656, tol = 1e-4)
	expect_equal(params[3],    0.5351, tol = 1e-4)
	expect_equal(params[4],    0.9253, tol = 1e-4)

	# Check the bootstrap summary statistics
	expect_equal(bootstrap$b4, 0.0010, tol = 5e-3)
	expect_equal(bootstrap$s4, 0.0286, tol = 5e-3)

	# Check the Z-distances
	expect_equal(distance$GEV$metric,  3.1342, tol = 5e-3)
	expect_equal(distance$GLO$metric,  4.7538, tol = 5e-3)
	expect_equal(distance$PE3$metric,  2.9672, tol = 5e-3)
	expect_equal(distance$GNO$metric,  3.1922, tol = 5e-3)
	expect_equal(distance$WEI$metric,  2.2269, tol = 5e-3)
	expect_equal(distance$GPA$metric, -0.2103, tol = 5e-3)

})


test_that("Test z-statistic.R on data set #3.1", {

	# Load dataset and run Z-statistic selection
	ams <- data3_1$df_clean$max
	slm <- sample_lm(ams)
	dlm <- distribution_lm()
	results <- z_statistic(slm, dlm, ams)
	list2env(results, envir = environment())

	# Check the Kappa distribution parameters
	expect_equal(params[1], 174.3927, tol = 1e-4)
	expect_equal(params[2],  60.5123, tol = 1e-4)
	expect_equal(params[3],   0.1065, tol = 1e-4)
	expect_equal(params[4],   0.2881, tol = 1e-4)

	# Check the bootstrap summary statistics
	expect_equal(bootstrap$b4, 0.0001, tol = 5e-3)
	expect_equal(bootstrap$s4, 0.0323, tol = 5e-3)

	# Check the Z-distances
	expect_equal(distance$GEV$metric,  0.7604, tol = 5e-3)
	expect_equal(distance$GLO$metric,  2.0345, tol = 5e-3)
	expect_equal(distance$PE3$metric,  0.2516, tol = 5e-3)
	expect_equal(distance$GNO$metric,  0.6337, tol = 5e-3)
	expect_equal(distance$WEI$metric, -0.3541, tol = 5e-3)
	expect_equal(distance$GPA$metric, -2.0381, tol = 5e-3)

})


test_that("Test z-statistic.R on data set #3.2", {

	# Load dataset and run Z-statistic selection
	ams <- data3_2$df_clean$max
	slm <- sample_lm(ams)
	dlm <- distribution_lm()
	results <- z_statistic(slm, dlm, ams)
	list2env(results, envir = environment())

	# Check the Kappa distribution parameters
	expect_equal(params[1], 61.7459, tol = 1e-4)
	expect_equal(params[2], 17.7802, tol = 1e-4)
	expect_equal(params[3],  0.0001, tol = 1e-4)
	expect_equal(params[4],  0.0747, tol = 1e-4)

	# Check the bootstrap summary statistics
	expect_equal(bootstrap$b4, -0.0006, tol = 5e-3)
	expect_equal(bootstrap$s4, 0.0409, tol = 5e-3)

	# Check the Z-distances
	expect_equal(distance$GEV$metric,  0.1264, tol = 5e-3)
	expect_equal(distance$GLO$metric,  1.0763, tol = 5e-3)
	expect_equal(distance$PE3$metric, -0.4176, tol = 5e-3)
	expect_equal(distance$GNO$metric, -0.0379, tol = 5e-3)
	expect_equal(distance$WEI$metric, -0.8623, tol = 5e-3)
	expect_equal(distance$GPA$metric, -2.0231, tol = 5e-3)

})


test_that("Test z-statistic.R on data set #3.3", {

	# Load dataset and run Z-statistic selection
	ams <- data3_3$df_clean$max
	slm <- sample_lm(ams)
	dlm <- distribution_lm()
	results <- z_statistic(slm, dlm, ams)
	list2env(results, envir = environment())

	# Check the Kappa distribution parameters
	expect_equal(params[1],  5.8934, tol = 1e-3) # NOTE: Unusual amount of error here.
	expect_equal(params[2], 51.3168, tol = 1e-4)
	expect_equal(params[3],  0.6732, tol = 1e-4)
	expect_equal(params[4],  1.1215, tol = 1e-4)

	# Check the bootstrap summary statistics
	expect_equal(bootstrap$b4, 0.0010, tol = 5e-3)
	expect_equal(bootstrap$s4, 0.0273, tol = 5e-3)

	# Check the Z-distances
	expect_equal(distance$GEV$metric, 3.9655, tol = 5e-3)
	expect_equal(distance$GLO$metric, 5.6702, tol = 5e-3)
	expect_equal(distance$PE3$metric, 3.7977, tol = 5e-3)
	expect_equal(distance$GNO$metric, 4.0305, tol = 5e-3)
	expect_equal(distance$WEI$metric, 3.0198, tol = 5e-3)
	expect_equal(distance$GPA$metric, 0.4492, tol = 5e-3)

})
