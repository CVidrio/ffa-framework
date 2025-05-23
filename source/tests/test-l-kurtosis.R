library(testthat)

test_that("Test l-kurtosis.R on data set #1", {

	# Load dataset and run L-kurtosis selection
	ams <- data1$df_clean$max
	results <- l_kurtosis(ams)
	list2env(results, envir = environment())

	# Check the distances
	expect_equal(distance$GEV, 0.0103, tol = 1e-4) 
	expect_equal(distance$GUM, 0.0466, tol = 1e-4) 
	expect_equal(distance$NOR, 0.0744, tol = 1e-4) 
	expect_equal(distance$LNO, 0.0472, tol = 1e-4) 
	expect_equal(distance$GLO, 0.0215, tol = 1e-4) 
	expect_equal(distance$PE3, 0.0525, tol = 1e-4) 
	expect_equal(distance$LP3, 0.0470, tol = 1e-4) 
	expect_equal(distance$GNO, 0.0253, tol = 1e-4) 
	expect_equal(distance$WEI, 0.0642, tol = 1e-4) 
	expect_equal(distance$GPA, 0.0902, tol = 1e-4) 

})


test_that("Test l-kurtosis.R on data set #2", {

	# Load dataset and run L-kurtosis selection
	ams <- data2$df_clean$max
	results <- l_kurtosis(ams)
	list2env(results, envir = environment())

	# Check the distances
	expect_equal(distance$GEV, 0.0887, tol = 1e-4) 
	expect_equal(distance$GUM, 0.1076, tol = 1e-4) 
	expect_equal(distance$NOR, 0.0798, tol = 1e-4) 
	expect_equal(distance$LNO, 0.0775, tol = 1e-4) 
	expect_equal(distance$GLO, 0.1350, tol = 1e-4) 
	expect_equal(distance$PE3, 0.0839, tol = 1e-4) 
	expect_equal(distance$LP3, 0.0783, tol = 1e-4) 
	expect_equal(distance$GNO, 0.0903, tol = 1e-4) 
	expect_equal(distance$WEI, 0.0627, tol = 1e-4) 
	expect_equal(distance$GPA, 0.0070, tol = 1e-4) 

})


test_that("Test l-kurtosis.R on data set #3.1", {

	# Load dataset and run L-kurtosis selection
	ams <- data3_1$df_clean$max
	results <- l_kurtosis(ams)
	list2env(results, envir = environment())

	# Check the distances
	expect_equal(distance$GEV, 0.0245, tol = 1e-4) 
	expect_equal(distance$GUM, 0.0275, tol = 1e-4) 
	expect_equal(distance$NOR, 0.0003, tol = 1e-4) 
	expect_equal(distance$LNO, 0.0244, tol = 1e-4) 
	expect_equal(distance$GLO, 0.0657, tol = 1e-4) 
	expect_equal(distance$PE3, 0.0081, tol = 1e-4) 
	expect_equal(distance$LP3, 0.0247, tol = 1e-4) 
	expect_equal(distance$GNO, 0.0204, tol = 1e-4) 
	expect_equal(distance$WEI, 0.0115, tol = 1e-4) 
	expect_equal(distance$GPA, 0.0660, tol = 1e-4) 

})


test_that("Test l-kurtosis.R on data set #3.2", {

	# Load dataset and run L-kurtosis selection
	ams <- data3_2$df_clean$max
	results <- l_kurtosis(ams)
	list2env(results, envir = environment())

	# Check the distances
	expect_equal(distance$GEV, 0.0058, tol = 1e-4) 
	expect_equal(distance$GUM, 0.0004, tol = 1e-4) 
	expect_equal(distance$NOR, 0.0274, tol = 1e-4) 
	expect_equal(distance$LNO, 0.0032, tol = 1e-4) 
	expect_equal(distance$GLO, 0.0447, tol = 1e-4) 
	expect_equal(distance$PE3, 0.0165, tol = 1e-4) 
	expect_equal(distance$LP3, 0.0027, tol = 1e-4) 
	expect_equal(distance$GNO, 0.0009, tol = 1e-4) 
	expect_equal(distance$WEI, 0.0347, tol = 1e-4) 
	expect_equal(distance$GPA, 0.0822, tol = 1e-4) 

})


test_that("Test l-kurtosis.R on data set #3.3", {

	# Load dataset and run L-kurtosis selection
	ams <- data3_3$df_clean$max
	results <- l_kurtosis(ams)
	list2env(results, envir = environment())

	# Check the distances
	expect_equal(distance$GEV, 0.1070, tol = 1e-4) 
	expect_equal(distance$GUM, 0.1262, tol = 1e-4) 
	expect_equal(distance$NOR, 0.0984, tol = 1e-4) 
	expect_equal(distance$LNO, 0.0669, tol = 1e-4) 
	expect_equal(distance$GLO, 0.1535, tol = 1e-4) 
	expect_equal(distance$PE3, 0.1025, tol = 1e-4) 
	expect_equal(distance$LP3, 0.0693, tol = 1e-4) 
	expect_equal(distance$GNO, 0.1088, tol = 1e-4) 
	expect_equal(distance$WEI, 0.0813, tol = 1e-4) 
	expect_equal(distance$GPA, 0.0112, tol = 1e-4)

})

