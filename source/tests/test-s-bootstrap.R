# Set seed for reproducibility
set.seed(1)

# NOTE: Tolerance is high due to randomness in the bootstrap
test_that("Test s-bootstrap.R on data set #1", {

	# Load dataset and run L-moments estimation
	ams <- data1$df_clean$max

	# Generalized Extreme Value (GEV) Distribution with optional profiling
	start <- Sys.time()
	GEV <- s_bootstrap(ams, "GEV", "L-moments")
	end <- Sys.time()
	print(end - start)

	expect_equal(GEV$estimates, c(1831, 2614, 3195, 3803, 4674, 5393), tol = 1e-2)
	expect_equal(GEV$ci_lower , c(1679, 2361, 2819, 3244, 3763, 4134), tol = 1e-2)
	expect_equal(GEV$ci_upper , c(1999, 2885, 3604, 4451, 5842, 7153), tol = 1e-2)

	# Gumbel (GUM) Distribution
	GUM <- s_bootstrap(ams, "GUM", "L-moments")
	expect_equal(GUM$estimates, c(1892, 2684, 3208, 3711, 4361, 4849), tol = 1e-2)
	expect_equal(GUM$ci_lower , c(1736, 2435, 2884, 3310, 3858, 4268), tol = 1e-2)
	expect_equal(GUM$ci_upper , c(2056, 2951, 3561, 4151, 4917, 5491), tol = 1e-2)

	# Normal (NOR) Distribution
	NOR <- s_bootstrap(ams, "NOR", "L-moments")
	expect_equal(NOR$estimates, c(2039, 2761, 3139, 3451, 3802, 4036), tol = 1e-2)
	expect_equal(NOR$ci_lower , c(1877, 2567, 2913, 3191, 3502, 3711), tol = 1e-2)
	expect_equal(NOR$ci_upper , c(2201, 2955, 3365, 3710, 4101, 4364), tol = 1e-2)

	# Log-Normal (LNO) Distribution
	LNO <- s_bootstrap(ams, "LNO", "L-moments")
	expect_equal(LNO$estimates, c(1861, 2667, 3218, 3759, 4476, 5029), tol = 1e-2)
	expect_equal(LNO$ci_lower , c(1713, 2417, 2868, 3296, 3844, 4260), tol = 1e-2)
	expect_equal(LNO$ci_upper , c(2014, 2932, 3601, 4280, 5210, 5944), tol = 1e-2)

	# Generalized Logistic (GLO) Distribution
	GLO <- s_bootstrap(ams, "GLO", "L-moments")
	expect_equal(GLO$estimates, c(1847, 2569, 3123, 3742, 4714, 5599), tol = 1e-2)
	expect_equal(GLO$ci_lower , c(1702, 2326, 2743, 3155, 3730, 4203), tol = 1e-2)
	expect_equal(GLO$ci_upper , c(2003, 2827, 3557, 4480, 6129, 7847), tol = 1e-2)

	# Pearson Type III (PE3) Distribution
	PE3 <- s_bootstrap(ams, "PE3", "L-moments")
	expect_equal(PE3$estimates, c(1823, 2668, 3254, 3822, 4560, 5114), tol = 1e-2)
	expect_equal(PE3$ci_lower , c(1660, 2402, 2873, 3302, 3817, 4195), tol = 1e-2)
	expect_equal(PE3$ci_upper , c(2005, 2949, 3658, 4388, 5386, 6154), tol = 1e-2)

	# Log-Pearson Type III (LP3) Distribution
	# NOTE: Tests have been removed, see matlab.md

	# Generalized Normal (GNO) Distribution
	GNO <- s_bootstrap(ams, "GNO", "L-moments")
	expect_equal(GNO$estimates, c(1826, 2636, 3222, 3818, 4638, 5289), tol = 1e-2)
	expect_equal(GNO$ci_lower , c(1670, 2377, 2840, 3269, 3799, 4200), tol = 1e-2)
	expect_equal(GNO$ci_upper , c(1998, 2912, 3640, 4455, 5678, 6753), tol = 1e-2)

	# Weibull (WEI) Distribution
	WEI <- s_bootstrap(ams, "WEI", "L-moments")
	expect_equal(WEI$estimates, c(1990, 2767, 3183, 3528, 3916, 4174), tol = 1e-2)
	expect_equal(WEI$ci_lower , c(1815, 2556, 2926, 3221, 3544, 3754), tol = 1e-2)
	expect_equal(WEI$ci_upper , c(2163, 2976, 3441, 3844, 4313, 4625), tol = 1e-2)

	# Generalized Pareto (GPA) Distribution
	GPA <- s_bootstrap(ams, "GPA", "L-moments")
	expect_equal(GPA$estimates, c(1802, 2734, 3333, 3854, 4440, 4817), tol = 1e-2)
	expect_equal(GPA$ci_lower , c(1632, 2439, 2963, 3384, 3785, 4000), tol = 1e-2)
	expect_equal(GPA$ci_upper , c(1994, 3039, 3700, 4323, 5140, 5773), tol = 1e-2)

})

test_that("Test s-bootstrap.R on data set #2", {

	# Load dataset and run L-moments estimation
	ams <- data2$df_clean$max

	# Log-Pearson Type III (LP3) Distribution
	LP3 <- s_bootstrap(ams, "LP3", "L-moments")
	expect_equal(LP3$estimates, c(1569, 2239, 2662, 3051, 3532, 3878), tol = 1e-2)
	expect_equal(LP3$ci_lower , c(1419, 2027, 2383, 2675, 2981, 3170), tol = 1e-2)
	expect_equal(LP3$ci_upper , c(1732, 2465, 2961, 3469, 4189, 4779), tol = 1e-2)

})

