test_that("Test sample-lm.R on data set #1", {

	# Load dataset and compute sample L-moments
	ams <- data1$df_clean$max
	results <- sample_lm(ams)
	list2env(results, envir = environment())

	# Test the L-moments
	expect_equal(lm$l1, 2039.1863, tol = 1e-4)
	expect_equal(lm$l2,  484.1581, tol = 1e-4)
	expect_equal(lm$l3,  120.8065, tol = 1e-4)
	expect_equal(lm$l4,   95.4003, tol = 1e-4)
	expect_equal(lm$t2,    0.2374, tol = 1e-4)
	expect_equal(lm$t3,    0.2495, tol = 1e-4)
	expect_equal(lm$t4,    0.1970, tol = 1e-4)

	# Test the Log L-moments
	expect_equal(log_lm$l1, 7.5285, tol = 1e-4)
	expect_equal(log_lm$l2, 0.2391, tol = 1e-4)
	expect_equal(log_lm$l3, 0.0057, tol = 1e-4)
	expect_equal(log_lm$l4, 0.0406, tol = 1e-4)
	expect_equal(log_lm$t2, 0.0318, tol = 1e-4)
	expect_equal(log_lm$t3, 0.0239, tol = 1e-4)
	expect_equal(log_lm$t4, 0.1698, tol = 1e-4)

})


test_that("Test sample-lm.R on data set #2", {

	# Load dataset and compute sample L-moments
	ams <- data2$df_clean$max
	results <- sample_lm(ams)
	list2env(results, envir = environment())

	# Test the L-moments
	expect_equal(lm$l1, 1675.0989, tol = 1e-4)
	expect_equal(lm$l2,  396.5617, tol = 1e-4)
	expect_equal(lm$l3,   45.9490, tol = 1e-4)
	expect_equal(lm$l4,   16.9764, tol = 1e-4)
	expect_equal(lm$t2,    0.2367, tol = 1e-4)
	expect_equal(lm$t3,    0.1159, tol = 1e-4)
	expect_equal(lm$t4,    0.0428, tol = 1e-4)

	# Test the Log L-moments
	expect_equal(log_lm$l1,  7.3337, tol = 1e-4)
	expect_equal(log_lm$l2,  0.2506, tol = 1e-4)
	expect_equal(log_lm$l3, -0.0134, tol = 1e-4)
	expect_equal(log_lm$l4,  0.0113, tol = 1e-4)
	expect_equal(log_lm$t2,  0.0342, tol = 1e-4)
	expect_equal(log_lm$t3, -0.0533, tol = 1e-4)
	expect_equal(log_lm$t4,  0.0451, tol = 1e-4)

})


test_that("Test sample-lm.R on data set #3.1", {

	# Load dataset and compute sample L-moments
	ams <- data3_1$df_clean$max
	results <- sample_lm(ams)
	list2env(results, envir = environment())

	# Test the L-moments
	expect_equal(lm$l1, 212.0734, tol = 1e-4)
	expect_equal(lm$l2,  33.9077, tol = 1e-4)
	expect_equal(lm$l3,   5.5045, tol = 1e-4)
	expect_equal(lm$l4,   4.1682, tol = 1e-4)
	expect_equal(lm$t2,   0.1599, tol = 1e-4)
	expect_equal(lm$t3,   0.1623, tol = 1e-4)
	expect_equal(lm$t4,   0.1229, tol = 1e-4)

	# Test the Log L-moments
	expect_equal(log_lm$l1, 5.3177, tol = 1e-4)
	expect_equal(log_lm$l2, 0.1591, tol = 1e-4)
	expect_equal(log_lm$l3, 0.0053, tol = 1e-4)
	expect_equal(log_lm$l4, 0.0156, tol = 1e-4)
	expect_equal(log_lm$t2, 0.0299, tol = 1e-4)
	expect_equal(log_lm$t3, 0.0331, tol = 1e-4)
	expect_equal(log_lm$t4, 0.0982, tol = 1e-4)

})


test_that("Test sample-lm.R on data set #3.2", {

	# Load dataset and compute sample L-moments
	ams <- data3_2$df_clean$max
	results <- sample_lm(ams)
	list2env(results, envir = environment())

	# Test the L-moments
	expect_equal(lm$l1, 72.6629, tol = 1e-4)
	expect_equal(lm$l2, 11.9970, tol = 1e-4)
	expect_equal(lm$l3,  2.1999, tol = 1e-4)
	expect_equal(lm$l4,  1.7998, tol = 1e-4)
	expect_equal(lm$t2,  0.1651, tol = 1e-4)
	expect_equal(lm$t3,  0.1834, tol = 1e-4)
	expect_equal(lm$t4,  0.1500, tol = 1e-4)

	# Test the Log L-moments
	expect_equal(log_lm$l1, 4.2436, tol = 1e-4)
	expect_equal(log_lm$l2, 0.1637, tol = 1e-4)
	expect_equal(log_lm$l3, 0.0068, tol = 1e-4)
	expect_equal(log_lm$l4, 0.0206, tol = 1e-4)
	expect_equal(log_lm$t2, 0.0386, tol = 1e-4)
	expect_equal(log_lm$t3, 0.0417, tol = 1e-4)
	expect_equal(log_lm$t4, 0.1258, tol = 1e-4)

})


test_that("Test sample-lm.R on data set #3.3", {

	# Load dataset and compute sample L-moments
	ams <- data3_3$df_clean$max
	results <- sample_lm(ams)
	list2env(results, envir = environment())

	# Test the L-moments
	expect_equal(lm$l1, 38.2095, tol = 1e-4)
	expect_equal(lm$l2, 10.6348, tol = 1e-4)
	expect_equal(lm$l3,  1.2227, tol = 1e-4)
	expect_equal(lm$l4,  0.2573, tol = 1e-4)
	expect_equal(lm$t2,  0.2783, tol = 1e-4)
	expect_equal(lm$t3,  0.1150, tol = 1e-4)
	expect_equal(lm$t4,  0.0242, tol = 1e-4)

	# Test the Log L-moments
	expect_equal(log_lm$l1,  3.5110, tol = 1e-4)
	expect_equal(log_lm$l2,  0.3077, tol = 1e-4)
	expect_equal(log_lm$l3, -0.0272, tol = 1e-4)
	expect_equal(log_lm$l4,  0.0171, tol = 1e-4)
	expect_equal(log_lm$t2,  0.0876, tol = 1e-4)
	expect_equal(log_lm$t3, -0.0885, tol = 1e-4)
	expect_equal(log_lm$t4,  0.0557, tol = 1e-4)

})
