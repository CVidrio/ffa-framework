library(testthat)

test_that("Test z-statistic.R on data set #1", {

	# Set seed for reproducibility
	set.seed(1)

	# Load dataset and run Z-statistic selection
	ams <- data1$df_clean$max
	results <- z_statistic(ams)
	list2env(results, envir = environment())

	# Check the Kappa distribution parameters
	expect_equal(params$xi,    0.8124, tol = 1e-4)
	expect_equal(params$alfa,  0.2782, tol = 1e-4)
	expect_equal(params$k,    -0.1544, tol = 1e-4)
	expect_equal(params$h,    -0.1704, tol = 1e-4)

	# Check the Log-Kappa distribution parameters
	expect_equal(log_params$xi,    1.0026, tol = 1e-4)
	expect_equal(log_params$alfa,  0.0288, tol = 1e-4)
	expect_equal(log_params$k,    -0.0597, tol = 1e-4)
	expect_equal(log_params$h,    -1.3223, tol = 1e-4)

	# Check the bootstrap summary statistics
	# NOTE: Tolerance is higher here because of randomness in the bootstrap
	expect_equal(bootstrap$b4,     -0.0027, tol = 1e-3)
	expect_equal(bootstrap$log_b4, -0.0006, tol = 1e-3)
	expect_equal(bootstrap$s4,      0.0512, tol = 1e-3)
	expect_equal(bootstrap$log_s4,  0.0364, tol = 1e-3)

	# Check the Z-distances
	# NOTE: Tolerance is higher here because of randomness in the bootstrap
	# -0.2552    0.3679   -1.0812   -1.3080   -0.5487   -1.3091   -1.8185
	expect_equal(z_distance$GEV, -0.2545, tol = 1e-2)
	expect_equal(z_distance$GLO,  0.3670, tol = 1e-2)
	expect_equal(z_distance$PE3, -1.0784, tol = 1e-2)
	expect_equal(z_distance$LP3, -1.3123, tol = 1e-2)
	expect_equal(z_distance$GNO, -0.5473, tol = 1e-2)
	expect_equal(z_distance$WEI, -1.3058, tol = 1e-2)
	expect_equal(z_distance$GPA, -1.8140, tol = 1e-2)

})

