# Set seed for reproducibility
set.seed(1)

test_that("Test s-bootstrap.R on data set #1", {

	# Load dataset and run L-moments estimation
	ams <- data1$df_clean$max
	params <- l_moments(ams)
	
	# Generalized Extreme Value (GEV) Distribution
	results <- s_bootstrap(ams, params$GEV, "GEV", "L-moments")
	list2env(results, envir = environment())

	expect_equal(estimates, c(1831, 2614, 3194, 3803, 4673, 5393), tol = 50)
	expect_equal( ci_lower, c(1681, 2361, 2819, 3245, 3765, 4152), tol = 50)
	expect_equal( ci_upper, c(1995, 2880, 3601, 4440, 5823, 7133), tol = 50)

	# Gumbel (GUM) Distribution
	results <- s_bootstrap(ams, params$GUM, "GUM", "L-moments")
	list2env(results, envir = environment())

	expect_equal(estimates, c(1892, 2684, 3208, 3710, 4361, 4849), tol = 50)
	expect_equal( ci_lower, c(1738, 2435, 2886, 3310, 3853, 4262), tol = 50)
	expect_equal( ci_upper, c(2051, 2947, 3556, 4146, 4911, 5484), tol = 50)

	# Normal (NOR) Distribution
	results <- s_bootstrap(ams, params$NOR, "NOR", "L-moments")
	list2env(results, envir = environment())

	expect_equal(estimates, c(2039, 2761, 3139, 3451, 3802, 4036), tol = 50)
	expect_equal( ci_lower, c(1877, 2567, 2913, 3191, 3502, 3711), tol = 50)
	expect_equal( ci_upper, c(2201, 2955, 3365, 3710, 4101, 4364), tol = 50)

	# Log-Normal (LNO) Distribution
	results <- s_bootstrap(ams, params$LNO, "LNO", "L-moments")
	list2env(results, envir = environment())

	expect_equal(estimates, c(1861, 2667, 3218, 3759, 4476, 5029), tol = 50)
	expect_equal( ci_lower, c(1713, 2417, 2868, 3296, 3844, 4260), tol = 50)
	expect_equal( ci_upper, c(2014, 2932, 3601, 4280, 5210, 5944), tol = 50)

	# Generalized Logistic (GLO) Distribution
	results <- s_bootstrap(ams, params$GLO, "GLO", "L-moments")
	list2env(results, envir = environment())

	expect_equal(estimates, c(1861, 2667, 3218, 3759, 4476, 5029), tol = 50)
	expect_equal( ci_lower, c(1713, 2417, 2868, 3296, 3844, 4260), tol = 50)
	expect_equal( ci_upper, c(2014, 2932, 3601, 4280, 5210, 5944), tol = 50)

	# Pearson Type III (PE3) Distribution

	# Log-Pearson Type III (LP3) Distribution

	# Generalized Normal (GNO) Distribution

	# Weibull (WEI) Distribution

	# Generalized Pareto (GPA) Distribution



})
