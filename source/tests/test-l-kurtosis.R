test_that("Test l-kurtosis.R on data set #1", {

	# Load dataset and run L-kurtosis selection
	ams <- data1$df_clean$max
	sample_moments <- get_sample_lm(ams)
	results <- l_kurtosis(sample_moments, distributions)
	list2env(results, envir = environment())

	# Check the distances
	expect_equal(distance$GEV$metric, 0.0103, tol = 1e-4) 
	expect_equal(distance$GLO$metric, 0.0215, tol = 1e-4) 
	expect_equal(distance$PE3$metric, 0.0525, tol = 1e-4) 
	expect_equal(distance$LP3$metric, 0.0470, tol = 1e-4) 
	expect_equal(distance$GNO$metric, 0.0253, tol = 1e-4) 
	expect_equal(distance$WEI$metric, 0.0642, tol = 1e-4) 
	expect_equal(distance$GPA$metric, 0.0902, tol = 1e-4) 

})


test_that("Test l-kurtosis.R on data set #2", {

	# Load dataset and run L-kurtosis selection
	ams <- data2$df_clean$max
	sample_moments <- get_sample_lm(ams)
	results <- l_kurtosis(sample_moments, distributions)
	list2env(results, envir = environment())

	# Check the distances
	expect_equal(distance$GEV$metric, 0.0887, tol = 1e-4) 
	expect_equal(distance$GLO$metric, 0.1350, tol = 1e-4) 
	expect_equal(distance$PE3$metric, 0.0839, tol = 1e-4) 
	expect_equal(distance$LP3$metric, 0.0783, tol = 1e-4) 
	expect_equal(distance$GNO$metric, 0.0903, tol = 1e-4) 
	expect_equal(distance$WEI$metric, 0.0627, tol = 1e-4) 
	expect_equal(distance$GPA$metric, 0.0070, tol = 1e-4) 

})


test_that("Test l-kurtosis.R on data set #3.1", {

	# Load dataset and run L-kurtosis selection
	ams <- data3_1$df_clean$max
	sample_moments <- get_sample_lm(ams)
	results <- l_kurtosis(sample_moments, distributions)
	list2env(results, envir = environment())

	# Check the distances
	expect_equal(distance$GEV$metric, 0.0245, tol = 1e-4) 
	expect_equal(distance$GLO$metric, 0.0657, tol = 1e-4) 
	expect_equal(distance$PE3$metric, 0.0081, tol = 1e-4) 
	expect_equal(distance$LP3$metric, 0.0247, tol = 1e-4) 
	expect_equal(distance$GNO$metric, 0.0204, tol = 1e-4) 
	expect_equal(distance$WEI$metric, 0.0115, tol = 1e-4) 
	expect_equal(distance$GPA$metric, 0.0660, tol = 1e-4) 

})


test_that("Test l-kurtosis.R on data set #3.2", {

	# Load dataset and run L-kurtosis selection
	ams <- data3_2$df_clean$max
	sample_moments <- get_sample_lm(ams)
	results <- l_kurtosis(sample_moments, distributions)
	list2env(results, envir = environment())

	# Check the distances
	expect_equal(distance$GEV$metric, 0.0058, tol = 1e-4) 
	expect_equal(distance$GLO$metric, 0.0447, tol = 1e-4) 
	expect_equal(distance$PE3$metric, 0.0165, tol = 1e-4) 
	expect_equal(distance$LP3$metric, 0.0027, tol = 1e-4) 
	expect_equal(distance$GNO$metric, 0.0009, tol = 1e-4) 
	expect_equal(distance$WEI$metric, 0.0347, tol = 1e-4) 
	expect_equal(distance$GPA$metric, 0.0822, tol = 1e-4) 

})


test_that("Test l-kurtosis.R on data set #3.3", {

	# Load dataset and run L-kurtosis selection
	ams <- data3_3$df_clean$max
	sample_moments <- get_sample_lm(ams)
	results <- l_kurtosis(sample_moments, distributions)
	list2env(results, envir = environment())

	# Check the distances
	expect_equal(distance$GEV$metric, 0.1070, tol = 1e-4) 
	expect_equal(distance$GLO$metric, 0.1535, tol = 1e-4) 
	expect_equal(distance$PE3$metric, 0.1025, tol = 1e-4) 
	expect_equal(distance$LP3$metric, 0.0693, tol = 1e-4) 
	expect_equal(distance$GNO$metric, 0.1088, tol = 1e-4) 
	expect_equal(distance$WEI$metric, 0.0813, tol = 1e-4) 
	expect_equal(distance$GPA$metric, 0.0112, tol = 1e-4)

})

