test_that("Test l-moments.R on data set #1", {

	# Load dataset and run L-moments estimation
	ams <- data1$df_clean$max

	# Generalized Extreme Value (GEV) Distribution
	GEV <- l_moments(ams, distributions$GEV)
	expect_equal(GEV[1], 1600.2199, tol = 5e-3)
	expect_equal(GEV[2],  616.6660, tol = 5e-3)
	expect_equal(GEV[3],   -0.1207, tol = 5e-3)

	# Gumbel (GUM) Distribution
	GUM <- l_moments(ams, distributions$GUM)
	expect_equal(GUM[1], 1636.0054, tol = 5e-3)
	expect_equal(GUM[2],  698.4925, tol = 5e-3)

	# Normal (NOR) Distribution
	NOR <- l_moments(ams, distributions$NOR)
	expect_equal(NOR[1], 2039.1863, tol = 5e-3)
	expect_equal(NOR[2],  858.1479, tol = 5e-3)

	# Log-Normal (LNO) Distribution
	LNO <- l_moments(ams, distributions$LNO)
	expect_equal(LNO[1],      0)
	expect_equal(LNO[2], 7.5290, tol = 5e-3)
	expect_equal(LNO[3], 0.4272, tol = 5e-3)

	# Generalized Logistic (GLO) Distribution
	GLO <- l_moments(ams, distributions$GLO)
	expect_equal(GLO[1], 1846.4844, tol = 5e-3)
	expect_equal(GLO[2],  436.0754, tol = 5e-3)
	expect_equal(GLO[3],   -0.2495, tol = 5e-3)

	# Pearson Type III (PE3) Distribution
	PE3 <- l_moments(ams, distributions$PE3)
	expect_equal(PE3[1], 2039.1863, tol = 5e-3)
	expect_equal(PE3[2],  920.0709, tol = 5e-3)
	expect_equal(PE3[3],    1.5024, tol = 5e-3)

	# Log-Pearson Type III (LP3) Distribution
	# NOTE: Some test cases missing, see documentation (matlab.md).
	LP3 <- l_moments(ams, distributions$LP3)
	expect_equal(LP3[1],  7.5285, tol = 5e-3)

	# Generalized Normal (GNO) Distribution
	GNO <- l_moments(ams, distributions$GNO)
	expect_equal(GNO[1], 1826.4036, tol = 5e-3)
	expect_equal(GNO[2],  767.1099, tol = 5e-3)
	expect_equal(GNO[3],   -0.5183, tol = 5e-3)

	# Weibull (WEI) Distribution
	WEI <- l_moments(ams, distributions$WEI)
	expect_equal(WEI[1],         0)
	expect_equal(WEI[2], 2296.9298, tol = 5e-3)
	expect_equal(WEI[3],    2.5572, tol = 5e-3)

	# Generalized Pareto (GPA) Distribution
	GPA <- l_moments(ams, distributions$GPA)
	expect_equal(GPA[1],  973.4415, tol = 5e-3)
	expect_equal(GPA[2], 1280.2075, tol = 5e-3)
	expect_equal(GPA[3],    0.2012, tol = 5e-3)

})


test_that("Test l-moments.R on data set #2", {

	# Load dataset and run L-moments estimation
	ams <- data2$df_clean$max

	# Generalized Extreme Value (GEV) Distribution
	GEV <- l_moments(ams, distributions$GEV)
	expect_equal(GEV[1], 1368.3942, tol = 5e-3)
	expect_equal(GEV[2],  615.9079, tol = 5e-3)
	expect_equal(GEV[3],    0.0864, tol = 5e-3)

	# Gumbel (GUM) Distribution
	GUM <- l_moments(ams, distributions$GUM)
	expect_equal(GUM[1], 1344.8637, tol = 5e-3)
	expect_equal(GUM[2],  572.1175, tol = 5e-3)

	# Normal (NOR) Distribution
	NOR <- l_moments(ams, distributions$NOR)
	expect_equal(NOR[1], 1675.0989, tol = 5e-3)
	expect_equal(NOR[2],  702.8872, tol = 5e-3)

	# Log-Normal (LNO) Distribution
	LNO <- l_moments(ams, distributions$LNO)
	expect_equal(LNO[1],      0)
	expect_equal(LNO[2], 7.3329, tol = 5e-3)
	expect_equal(LNO[3], 0.4260, tol = 5e-3)

	# Generalized Logistic (GLO) Distribution
	GLO <- l_moments(ams, distributions$GLO)
	expect_equal(GLO[1], 1600.0150, tol = 5e-3)
	expect_equal(GLO[2],  387.8618, tol = 5e-3)
	expect_equal(GLO[3],   -0.1159, tol = 5e-3)

	# Pearson Type III (PE3) Distribution
	PE3 <- l_moments(ams, distributions$PE3)
	expect_equal(PE3[1], 1675.0989, tol = 5e-3)
	expect_equal(PE3[2],  713.9522, tol = 5e-3)
	expect_equal(PE3[3],    0.7072, tol = 5e-3)

	# Log-Pearson Type III (LP3) Distribution
	LP3 <- l_moments(ams, distributions$LP3)
	expect_equal(LP3[1],  7.3337, tol = 5e-3)
	expect_equal(LP3[2],  0.4457, tol = 5e-3)
	expect_equal(LP3[3], -0.3270, tol = 5e-3)

	# Generalized Normal (GNO) Distribution
	GNO <- l_moments(ams, distributions$GNO)
	expect_equal(GNO[1], 1592.2772, tol = 5e-3)
	expect_equal(GNO[2],  686.5012, tol = 5e-3)
	expect_equal(GNO[3],   -0.2379, tol = 5e-3)

	# Weibull (WEI) Distribution
	WEI <- l_moments(ams, distributions$WEI)
	expect_equal(WEI[1],         0)
	expect_equal(WEI[2], 1886.6486, tol = 5e-3)
	expect_equal(WEI[3],    2.5657, tol = 5e-3)

	# Generalized Pareto (GPA) Distribution
	GPA <- l_moments(ams, distributions$GPA)
	expect_equal(GPA[1],  650.1250, tol = 5e-3)
	expect_equal(GPA[2], 1624.2269, tol = 5e-3)
	expect_equal(GPA[3],    0.5847, tol = 5e-3)

})

test_that("Test l-moments.R on data set #3.1", {

	# Load dataset and run L-moments estimation
	ams <- data3_1$df_clean$max

	# Generalized Extreme Value (GEV) Distribution
	GEV <- l_moments(ams, distributions$GEV)
	expect_equal(GEV[1],  184.1039, tol = 5e-3)
	expect_equal(GEV[2],   49.4535, tol = 5e-3)
	expect_equal(GEV[3],    0.0119, tol = 5e-3)

	# Gumbel (GUM) Distribution
	GUM <- l_moments(ams, distributions$GUM)
	expect_equal(GUM[1], 183.8368, tol = 5e-3)
	expect_equal(GUM[2],  48.9185, tol = 5e-3)

	# Normal (NOR) Distribution
	NOR <- l_moments(ams, distributions$NOR)
	expect_equal(NOR[1], 212.0734, tol = 5e-3)
	expect_equal(NOR[2],  60.0999, tol = 5e-3)

	# Log-Normal (LNO) Distribution
	LNO <- l_moments(ams, distributions$LNO)
	expect_equal(LNO[1],      0)
	expect_equal(LNO[2], 5.3162, tol = 5e-3)
	expect_equal(LNO[3], 0.2853, tol = 5e-3)

	# Generalized Logistic (GLO) Distribution
	GLO <- l_moments(ams, distributions$GLO)
	expect_equal(GLO[1], 203.1358, tol = 5e-3)
	expect_equal(GLO[2],  32.4568, tol = 5e-3)
	expect_equal(GLO[3],  -0.1623, tol = 5e-3)

	# Pearson Type III (PE3) Distribution
	PE3 <- l_moments(ams, distributions$PE3)
	expect_equal(PE3[1], 212.0734, tol = 5e-3)
	expect_equal(PE3[2],  61.9498, tol = 5e-3)
	expect_equal(PE3[3],   0.9861, tol = 5e-3)

	# Log-Pearson Type III (LP3) Distribution
	LP3 <- l_moments(ams, distributions$LP3)
	expect_equal(LP3[1], 5.3177, tol = 5e-3)
	expect_equal(LP3[2], 0.2823, tol = 5e-3)
	expect_equal(LP3[3], 0.2029, tol = 5e-3)

	# Generalized Normal (GNO) Distribution
	GNO <- l_moments(ams, distributions$GNO)
	expect_equal(GNO[1], 202.2116, tol = 5e-3)
	expect_equal(GNO[2],  57.3632, tol = 5e-3)
	expect_equal(GNO[3],  -0.3343, tol = 5e-3)

	# Weibull (WEI) Distribution
	WEI <- l_moments(ams, distributions$WEI)
	expect_equal(WEI[1],         0)
	expect_equal(WEI[2], 234.0440, tol = 5e-3)
	expect_equal(WEI[3],   3.9786, tol = 5e-3)

	# Generalized Pareto (GPA) Distribution
	GPA <- l_moments(ams, distributions$GPA)
	expect_equal(GPA[1], 129.2931, tol = 5e-3)
	expect_equal(GPA[2], 119.3143, tol = 5e-3)
	expect_equal(GPA[3],   0.4413, tol = 5e-3)

})


test_that("Test l-moments.R on data set #3.2", {

	# Load dataset and run L-moments estimation
	ams <- data3_2$df_clean$max

	# Generalized Extreme Value (GEV) Distribution
	GEV <- l_moments(ams, distributions$GEV)
	expect_equal(GEV[1], 62.5092, tol = 5e-3)
	expect_equal(GEV[2], 16.9703, tol = 5e-3)
	expect_equal(GEV[3], -0.0209, tol = 5e-3)

	# Gumbel (GUM) Distribution
	GUM <- l_moments(ams, distributions$GUM)
	expect_equal(GUM[1], 62.6725, tol = 5e-3)
	expect_equal(GUM[2], 17.3080, tol = 5e-3)

	# Normal (NOR) Distribution
	NOR <- l_moments(ams, distributions$NOR)
	expect_equal(NOR[1], 72.6629, tol = 5e-3)
	expect_equal(NOR[2], 21.2642, tol = 5e-3)

	# Log-Normal (LNO) Distribution
	LNO <- l_moments(ams, distributions$LNO)
	expect_equal(LNO[1],      0)
	expect_equal(LNO[2], 4.2424, tol = 5e-3)
	expect_equal(LNO[3], 0.2948, tol = 5e-3)

	# Generalized Logistic (GLO) Distribution
	GLO <- l_moments(ams, distributions$GLO)
	expect_equal(GLO[1], 69.1038, tol = 5e-3)
	expect_equal(GLO[2], 11.3444, tol = 5e-3)
	expect_equal(GLO[3], -0.1834, tol = 5e-3)

	# Pearson Type III (PE3) Distribution
	PE3 <- l_moments(ams, distributions$PE3)
	expect_equal(PE3[1], 72.6629, tol = 5e-3)
	expect_equal(PE3[2], 22.0977, tol = 5e-3)
	expect_equal(PE3[3],  1.1114, tol = 5e-3)

	# Log-Pearson Type III (LP3) Distribution
	LP3 <- l_moments(ams, distributions$LP3)
	expect_equal(LP3[1], 4.2436, tol = 5e-3)
	expect_equal(LP3[2], 0.2907, tol = 5e-3)
	expect_equal(LP3[3], 0.2560, tol = 5e-3)

	# Generalized Normal (GNO) Distribution
	GNO <- l_moments(ams, distributions$GNO)
	expect_equal(GNO[1], 68.7351, tol = 5e-3)
	expect_equal(GNO[2], 20.0322, tol = 5e-3)
	expect_equal(GNO[3], -0.3783, tol = 5e-3)

	# Weibull (WEI) Distribution
	WEI <- l_moments(ams, distributions$WEI)
	expect_equal(WEI[1],       0)
	expect_equal(WEI[2], 80.3498, tol = 5e-3)
	expect_equal(WEI[3],  3.8412, tol = 5e-3)

	# Generalized Pareto (GPA) Distribution
	GPA <- l_moments(ams, distributions$GPA)
	expect_equal(GPA[1], 44.1080, tol = 5e-3)
	expect_equal(GPA[2], 39.4106, tol = 5e-3)
	expect_equal(GPA[3],  0.3802, tol = 5e-3)

})


test_that("Test l-moments.R on data set #3.3", {

	# Load dataset and run L-moments estimation
	ams <- data3_3$df_clean$max

	# Generalized Extreme Value (GEV) Distribution
	GEV <- l_moments(ams, distributions$GEV)
	expect_equal(GEV[1], 29.9956, tol = 5e-3)
	expect_equal(GEV[2], 16.5362, tol = 5e-3)
	expect_equal(GEV[3],  0.0878, tol = 5e-3)

	# Gumbel (GUM) Distribution
	GUM <- l_moments(ams, distributions$GUM)
	expect_equal(GUM[1], 29.3534, tol = 5e-3)
	expect_equal(GUM[2], 15.3427, tol = 5e-3)

	# Normal (NOR) Distribution
	NOR <- l_moments(ams, distributions$NOR)
	expect_equal(NOR[1], 38.2095, tol = 5e-3)
	expect_equal(NOR[2], 18.8496, tol = 5e-3)

	# Log-Normal (LNO) Distribution
	LNO <- l_moments(ams, distributions$LNO)
	expect_equal(LNO[1],      0)
	expect_equal(LNO[2], 3.5162, tol = 5e-3)
	expect_equal(LNO[3], 0.5038, tol = 5e-3)

	# Generalized Logistic (GLO) Distribution
	GLO <- l_moments(ams, distributions$GLO)
	expect_equal(GLO[1], 36.2114, tol = 5e-3)
	expect_equal(GLO[2], 10.4051, tol = 5e-3)
	expect_equal(GLO[3], -0.1150, tol = 5e-3)

	# Pearson Type III (PE3) Distribution
	PE3 <- l_moments(ams, distributions$PE3)
	expect_equal(PE3[1], 38.2095, tol = 5e-3)
	expect_equal(PE3[2], 19.1418, tol = 5e-3)
	expect_equal(PE3[3],  0.7018, tol = 5e-3)

	# Log-Pearson Type III (LP3) Distribution
	LP3 <- l_moments(ams, distributions$LP3)
	expect_equal(LP3[1],  3.5110, tol = 5e-3)
	expect_equal(LP3[2],  0.5504, tol = 5e-3)
	expect_equal(LP3[3], -0.5416, tol = 5e-3)

	# Generalized Normal (GNO) Distribution
	GNO <- l_moments(ams, distributions$GNO)
	expect_equal(GNO[1], 36.0055, tol = 5e-3)
	expect_equal(GNO[2], 18.4170, tol = 5e-3)
	expect_equal(GNO[3], -0.2360, tol = 5e-3)

	# Weibull (WEI) Distribution
	WEI <- l_moments(ams, distributions$WEI)
	expect_equal(WEI[1],       0)
	expect_equal(WEI[2], 43.1435, tol = 5e-3)
	expect_equal(WEI[3],  2.1250, tol = 5e-3)

	# Generalized Pareto (GPA) Distribution
	GPA <- l_moments(ams, distributions$GPA)
	expect_equal(GPA[1], 10.6915, tol = 5e-3)
	expect_equal(GPA[2], 43.6862, tol = 5e-3)
	expect_equal(GPA[3],  0.5875, tol = 5e-3)

})

