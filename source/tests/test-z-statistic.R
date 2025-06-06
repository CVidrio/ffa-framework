# Set seed for reproducibility
set.seed(1)

# NOTE: Tolerance is higher in some tests because of randomness in the bootstrap
test_that("Test z-statistic.R on data set #1", {

	# Load dataset, get L-moments
	ams <- data1$df_clean$max
	sample_moments <- get_sample_lm(ams)

	# Run Z-statistic selection with optional profiling
	start <- Sys.time()
	results <- z_statistic(sample_moments, distributions, ams)
	end <- Sys.time()
	# print(end - start)
	list2env(results, envir = environment())

	# Check the Kappa distribution parameters (only k and h)
	expect_equal(params[3], -0.1544, tol = 1e-4)
	expect_equal(params[4], -0.1704, tol = 1e-4)
	expect_equal(log_params[3], NULL)
	expect_equal(log_params[4], NULL)

	# Check the bootstrap summary statistics
	expect_equal(bootstrap$bias_t4,     -0.0026, tol = 1e-2)
	expect_equal(bootstrap$sd_t4,      0.0514, tol = 1e-2)
	expect_equal(bootstrap$log_bias_t4, NULL)
	expect_equal(bootstrap$log_sd_t4, NULL)

	# Check the Z-distances
	expect_equal(distance$GEV$metric, -0.2524, tol = 1e-2)
	expect_equal(distance$GLO$metric,  0.3673, tol = 1e-2)
	expect_equal(distance$PE3$metric, -1.0738, tol = 1e-2)
	expect_equal(distance$LP3$metric, NULL)
	expect_equal(distance$GNO$metric, -0.5443, tol = 1e-2)
	expect_equal(distance$WEI$metric, -1.3005, tol = 1e-2)
	expect_equal(distance$GPA$metric, -1.8072, tol = 1e-2)

})


test_that("Test z-statistic.R on data set #2", {

	# Load dataset and run Z-statistic selection
	ams <- data2$df_clean$max
	sample_moments <- get_sample_lm(ams)
	results <- z_statistic(sample_moments, distributions, ams)
	list2env(results, envir = environment())

	# Check the Kappa distribution parameters (only k and h)
	expect_equal(params[3],     0.5351, tol = 1e-4)
	expect_equal(params[4],     0.9253, tol = 1e-4)
	expect_equal(log_params[3], 0.7347, tol = 1e-4)
	expect_equal(log_params[4], 0.5134, tol = 1e-4)

	# Check the bootstrap summary statistics
	expect_equal(bootstrap$bias_t4,     0.0010, tol = 1e-2)
	expect_equal(bootstrap$sd_t4,     0.0286, tol = 1e-2)
	expect_equal(bootstrap$log_bias_t4, 0.0009, tol = 1e-2)
	expect_equal(bootstrap$log_sd_t4, 0.0276, tol = 1e-2)

	# Check the Z-distances
	expect_equal(distance$GEV$metric,  3.1342, tol = 1e-2)
	expect_equal(distance$GLO$metric,  4.7538, tol = 1e-2)
	expect_equal(distance$PE3$metric,  2.9672, tol = 1e-2)
	expect_equal(distance$LP3$metric,  2.8678, tol = 1e-2)
	expect_equal(distance$GNO$metric,  3.1922, tol = 1e-2)
	expect_equal(distance$WEI$metric,  2.2269, tol = 1e-2)
	expect_equal(distance$GPA$metric, -0.2103, tol = 1e-2)

})


test_that("Test z-statistic.R on data set #3.1", {

	# Load dataset and run Z-statistic selection
	ams <- data3_1$df_clean$max
	sample_moments <- get_sample_lm(ams)
	results <- z_statistic(sample_moments, distributions, ams)
	list2env(results, envir = environment())

	# Check the Kappa distribution parameters (only k and h)
	expect_equal(params[3],     0.1065, tol = 1e-4)
	expect_equal(params[4],     0.2881, tol = 1e-4)
	expect_equal(log_params[3], 0.2875, tol = 1e-4)
	expect_equal(log_params[4], 0.1371, tol = 1e-4)

	# Check the bootstrap summary statistics
	expect_equal(bootstrap$bias_t4,     0.0001, tol = 1e-2)
	expect_equal(bootstrap$sd_t4,     0.0323, tol = 1e-2)
	expect_equal(bootstrap$log_bias_t4, 0.0005, tol = 1e-2)
	expect_equal(bootstrap$log_sd_t4, 0.0273, tol = 1e-2)

	# Check the Z-distances
	expect_equal(distance$GEV$metric,  0.7609, tol = 1e-2)
	expect_equal(distance$GLO$metric,  2.0339, tol = 1e-2)
	expect_equal(distance$PE3$metric,  0.2525, tol = 1e-2)
	expect_equal(distance$LP3$metric,  0.9258, tol = 1e-2)
	expect_equal(distance$GNO$metric,  0.6342, tol = 1e-2)
	expect_equal(distance$WEI$metric, -0.3527, tol = 1e-2)
	expect_equal(distance$GPA$metric, -2.0352, tol = 1e-2)

})


test_that("Test z-statistic.R on data set #3.2", {

	# Load dataset and run Z-statistic selection
	ams <- data3_2$df_clean$max
	sample_moments <- get_sample_lm(ams)
	results <- z_statistic(sample_moments, distributions, ams)
	list2env(results, envir = environment())

	# Check the Kappa distribution parameters (only k and h)
	expect_equal(params[3],      0.0001, tol = 1e-4)
	expect_equal(params[4],      0.0747, tol = 1e-3) # NOTE: Error is still < 0.001
	expect_equal(log_params[3],  0.1569, tol = 1e-4)
	expect_equal(log_params[4], -0.1367, tol = 1e-3) # NOTE: Error is still < 0.001

	# Check the bootstrap summary statistics
	expect_equal(bootstrap$bias_t4,     -0.0006, tol = 1e-2)
	expect_equal(bootstrap$sd_t4,      0.0409, tol = 1e-2)
	expect_equal(bootstrap$log_bias_t4,  0.0003, tol = 1e-2)
	expect_equal(bootstrap$log_sd_t4,  0.0332, tol = 1e-2)

	# Check the Z-distances
	expect_equal(distance$GEV$metric,  0.1264, tol = 1e-2)
	expect_equal(distance$GLO$metric,  1.0763, tol = 1e-2)
	expect_equal(distance$PE3$metric, -0.4176, tol = 1e-2)
	expect_equal(distance$LP3$metric, -0.0713, tol = 1e-2)
	expect_equal(distance$GNO$metric, -0.0379, tol = 1e-2)
	expect_equal(distance$WEI$metric, -0.8623, tol = 1e-2)
	expect_equal(distance$GPA$metric, -2.0231, tol = 1e-2)

})


test_that("Test z-statistic.R on data set #3.3", {

	# Load dataset and run Z-statistic selection
	ams <- data3_3$df_clean$max
	sample_moments <- get_sample_lm(ams)
	results <- z_statistic(sample_moments, distributions, ams)
	list2env(results, envir = environment())

	# Check the Kappa distribution parameters (only k and h)
	expect_equal(params[3],     0.6732, tol = 1e-4)
	expect_equal(params[4],     1.1215, tol = 1e-4)
	expect_equal(log_params[3], 0.7486, tol = 1e-4)
	expect_equal(log_params[4], 0.4114, tol = 1e-4)

	# Check the bootstrap summary statistics
	expect_equal(bootstrap$bias_t4,     0.0010, tol = 1e-2)
	expect_equal(bootstrap$sd_t4,     0.0273, tol = 1e-2)
	expect_equal(bootstrap$log_bias_t4, 0.0008, tol = 1e-2)
	expect_equal(bootstrap$log_sd_t4, 0.0275, tol = 1e-2)

	# Check the Z-distances
	expect_equal(distance$GEV$metric, 3.9655, tol = 1e-2)
	expect_equal(distance$GLO$metric, 5.6702, tol = 1e-2)
	expect_equal(distance$PE3$metric, 3.8036, tol = 1e-2)
	expect_equal(distance$LP3$metric, 2.5453, tol = 1e-2)
	expect_equal(distance$GNO$metric, 4.0305, tol = 1e-2)
	expect_equal(distance$WEI$metric, 3.0198, tol = 1e-2)
	expect_equal(distance$GPA$metric, 0.4492, tol = 1e-2)

})
