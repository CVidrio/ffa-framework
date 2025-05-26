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
	expect_equal(params$xi,    0.8124, tol = 3e-4)
	expect_equal(params$alfa,  0.2782, tol = 3e-4)
	expect_equal(params$k,    -0.1544, tol = 3e-4)
	expect_equal(params$h,    -0.1704, tol = 3e-4)

	# Check the Log-Kappa distribution parameters
	expect_equal(log_params$xi,    1.0026, tol = 3e-4)
	expect_equal(log_params$alfa,  0.0288, tol = 3e-4)
	expect_equal(log_params$k,    -0.0597, tol = 3e-4)
	expect_equal(log_params$h,    -1.3223, tol = 3e-4)

	# Check the bootstrap summary statistics
	expect_equal(bootstrap$b4,     -0.0027, tol = 1e-3)
	expect_equal(bootstrap$log_b4, -0.0006, tol = 1e-3)
	expect_equal(bootstrap$s4,      0.0512, tol = 1e-3)
	expect_equal(bootstrap$log_s4,  0.0364, tol = 1e-3)

	# Check the Z-distances
	expect_equal(distance$GEV$metric, -0.2545, tol = 1e-2)
	expect_equal(distance$GLO$metric,  0.3670, tol = 1e-2)
	expect_equal(distance$PE3$metric, -1.0784, tol = 1e-2)
	expect_equal(distance$LP3$metric, -1.3123, tol = 1e-2)
	expect_equal(distance$GNO$metric, -0.5473, tol = 1e-2)
	expect_equal(distance$WEI$metric, -1.3058, tol = 1e-2)
	expect_equal(distance$GPA$metric, -1.8140, tol = 1e-2)

})


test_that("Test z-statistic.R on data set #2", {

	# Load dataset and run Z-statistic selection
	ams <- data2$df_clean$max
	slm <- sample_lm(ams)
	dlm <- distribution_lm()
	results <- z_statistic(slm, dlm, ams)
	list2env(results, envir = environment())

	# Check the Kappa distribution parameters
	expect_equal(params$xi,   0.4444, tol = 3e-4)
	expect_equal(params$alfa, 0.8830, tol = 3e-4)
	expect_equal(params$k,    0.5351, tol = 3e-4)
	expect_equal(params$h,    0.9253, tol = 3e-4)

	# Check the Log-Kappa distribution parameters
	expect_equal(log_params$xi,   0.9536, tol = 3e-4)
	expect_equal(log_params$alfa, 0.1126, tol = 3e-4)
	expect_equal(log_params$k,    0.7347, tol = 3e-4)
	expect_equal(log_params$h,    0.5134, tol = 3e-4)

	# Check the bootstrap summary statistics
	expect_equal(bootstrap$b4,     0.0010, tol = 1e-3)
	expect_equal(bootstrap$log_b4, 0.0010, tol = 1e-3)
	expect_equal(bootstrap$s4,     0.0286, tol = 1e-3)
	expect_equal(bootstrap$log_s4, 0.0276, tol = 1e-3)

	# Check the Z-distances
	expect_equal(distance$GEV$metric,  3.1342, tol = 1e-2)
	expect_equal(distance$GLO$metric,  4.7538, tol = 1e-2)
	expect_equal(distance$PE3$metric,  2.9672, tol = 1e-2)
	expect_equal(distance$LP3$metric,  2.8730, tol = 1e-2)
	expect_equal(distance$GNO$metric,  3.1922, tol = 1e-2)
	expect_equal(distance$WEI$metric,  2.2269, tol = 1e-2)
	expect_equal(distance$GPA$metric, -0.2103, tol = 1e-2)

})


test_that("Test z-statistic.R on data set #3.1", {

	# Load dataset and run Z-statistic selection
	ams <- data3_1$df_clean$max
	slm <- sample_lm(ams)
	dlm <- distribution_lm()
	results <- z_statistic(slm, dlm, ams)
	list2env(results, envir = environment())

	# Check the Kappa distribution parameters
	expect_equal(params$xi,   0.8223, tol = 3e-4)
	expect_equal(params$alfa, 0.2853, tol = 3e-4)
	expect_equal(params$k,    0.1065, tol = 3e-4)
	expect_equal(params$h,    0.2881, tol = 3e-4)

	# Check the Log-Kappa distribution parameters
	expect_equal(log_params$xi,   0.9756, tol = 3e-4)
	expect_equal(log_params$alfa, 0.0574, tol = 3e-4)
	expect_equal(log_params$k,    0.2875, tol = 3e-4)
	expect_equal(log_params$h,    0.1371, tol = 3e-4)

	# Check the bootstrap summary statistics
	expect_equal(bootstrap$b4,     0.0001, tol = 1e-3)
	expect_equal(bootstrap$log_b4, 0.0006, tol = 1e-3)
	expect_equal(bootstrap$s4,     0.0323, tol = 1e-3)
	expect_equal(bootstrap$log_s4, 0.0273, tol = 1e-3)

	# Check the Z-distances
	expect_equal(distance$GEV$metric,  0.7604, tol = 1e-2)
	expect_equal(distance$GLO$metric,  2.0345, tol = 1e-2)
	expect_equal(distance$PE3$metric,  0.2516, tol = 1e-2)
	expect_equal(distance$LP3$metric,  0.9267, tol = 1e-2)
	expect_equal(distance$GNO$metric,  0.6337, tol = 1e-2)
	expect_equal(distance$WEI$metric, -0.3541, tol = 1e-2)
	expect_equal(distance$GPA$metric, -2.0381, tol = 1e-2)

})


test_that("Test z-statistic.R on data set #3.2", {

	# Load dataset and run Z-statistic selection
	ams <- data3_2$df_clean$max
	slm <- sample_lm(ams)
	dlm <- distribution_lm()
	results <- z_statistic(slm, dlm, ams)
	list2env(results, envir = environment())

	# Check the Kappa distribution parameters
	expect_equal(params$xi,   0.8498, tol = 3e-4)
	expect_equal(params$alfa, 0.2447, tol = 3e-4)
	expect_equal(params$k,    0.0001, tol = 3e-4)
	expect_equal(params$h,    0.0747, tol = 3e-4)

	# Check the Log-Kappa distribution parameters
	expect_equal(log_params$xi,    0.9785, tol = 3e-4)
	expect_equal(log_params$alfa,  0.0590, tol = 3e-4)
	expect_equal(log_params$k,     0.1569, tol = 3e-4)
	expect_equal(log_params$h,    -0.1367, tol = 3e-4)

	# Check the bootstrap summary statistics
	expect_equal(bootstrap$b4,     -0.0006, tol = 1e-3)
	expect_equal(bootstrap$log_b4,  0.0004, tol = 1e-3)
	expect_equal(bootstrap$s4,      0.0409, tol = 1e-3)
	expect_equal(bootstrap$log_s4,  0.0332, tol = 1e-3)

	# Check the Z-distances
	expect_equal(distance$GEV$metric,  0.1264, tol = 1e-2)
	expect_equal(distance$GLO$metric,  1.0763, tol = 1e-2)
	expect_equal(distance$PE3$metric, -0.4176, tol = 1e-2)
	expect_equal(distance$LP3$metric, -0.0699, tol = 1e-2)
	expect_equal(distance$GNO$metric, -0.0379, tol = 1e-2)
	expect_equal(distance$WEI$metric, -0.8623, tol = 1e-2)
	expect_equal(distance$GPA$metric, -2.0231, tol = 1e-2)

})


test_that("Test z-statistic.R on data set #3.3", {

	# Load dataset and run Z-statistic selection
	ams <- data3_3$df_clean$max
	slm <- sample_lm(ams)
	dlm <- distribution_lm()
	results <- z_statistic(slm, dlm, ams)
	list2env(results, envir = environment())

	# Check the Kappa distribution parameters
	expect_equal(params$xi,   0.1542, tol = 3e-4)
	expect_equal(params$alfa, 1.3430, tol = 3e-4)
	expect_equal(params$k,    0.6732, tol = 3e-4)
	expect_equal(params$h,    1.1215, tol = 3e-4)

	# Check the Log-Kappa distribution parameters
	expect_equal(log_params$xi,   0.9035, tol = 3e-4)
	expect_equal(log_params$alfa, 0.2666, tol = 3e-4)
	expect_equal(log_params$k,    0.7486, tol = 3e-4)
	expect_equal(log_params$h,    0.4114, tol = 3e-4)

	# Check the bootstrap summary statistics
	expect_equal(bootstrap$b4,     0.0010, tol = 1e-3)
	expect_equal(bootstrap$log_b4, 0.0009, tol = 1e-3)
	expect_equal(bootstrap$s4,     0.0273, tol = 1e-3)
	expect_equal(bootstrap$log_s4, 0.0276, tol = 1e-3)

	# Check the Z-distances
	expect_equal(distance$GEV$metric, 3.9655, tol = 1e-2)
	expect_equal(distance$GLO$metric, 5.6702, tol = 1e-2)
	expect_equal(distance$PE3$metric, 3.7977, tol = 1e-2)
	expect_equal(distance$LP3$metric, 2.5411, tol = 1e-2)
	expect_equal(distance$GNO$metric, 4.0305, tol = 1e-2)
	expect_equal(distance$WEI$metric, 3.0198, tol = 1e-2)
	expect_equal(distance$GPA$metric, 0.4492, tol = 1e-2)

})
