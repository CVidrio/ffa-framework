test_that("Test l-distance.R on data set #1", {

	# Load dataset and run L-distance selection
	ams <- data1$df_clean$max
	sample_moments <- get_sample_lm(ams)
	results <- l_distance(sample_moments, distributions)
	list2env(results, envir = environment())

	# Check the distances
	expect_equal(distance$GEV$metric, 0.0092, tol = 1e-4) 
	expect_equal(distance$GUM$metric, 0.0923, tol = 1e-4) 
	expect_equal(distance$NOR$metric, 0.2604, tol = 1e-4) 
	expect_equal(distance$LNO$metric, 0.0529, tol = 1e-4) 
	expect_equal(distance$GLO$metric, 0.0199, tol = 1e-4) 
	expect_equal(distance$PE3$metric, 0.0514, tol = 1e-4) 
	expect_equal(distance$LP3$metric, 0.0470, tol = 1e-4) 
	expect_equal(distance$GNO$metric, 0.0235, tol = 1e-4) 
	expect_equal(distance$WEI$metric, 0.0607, tol = 1e-4) 
	expect_equal(distance$GPA$metric, 0.0746, tol = 1e-4) 

})


test_that("Test l-distance.R on data set #2", {

	# Load dataset and run L-distance selection
	ams <- data2$df_clean$max
	sample_moments <- get_sample_lm(ams)
	results <- l_distance(sample_moments, distributions)
	list2env(results, envir = environment())

	# Check the distances
	expect_equal(distance$GEV$metric, 0.0853, tol = 1e-4) 
	expect_equal(distance$GUM$metric, 0.1204, tol = 1e-4) 
	expect_equal(distance$NOR$metric, 0.1407, tol = 1e-4) 
	expect_equal(distance$LNO$metric, 0.0941, tol = 1e-4) 
	expect_equal(distance$GLO$metric, 0.1330, tol = 1e-4) 
	expect_equal(distance$PE3$metric, 0.0837, tol = 1e-4) 
	expect_equal(distance$LP3$metric, 0.0783, tol = 1e-4) 
	expect_equal(distance$GNO$metric, 0.0891, tol = 1e-4) 
	expect_equal(distance$WEI$metric, 0.0625, tol = 1e-4) 
	expect_equal(distance$GPA$metric, 0.0065, tol = 1e-4) 

})


test_that("Test l-distance.R on data set #3.1", {

	# Load dataset and run L-distance selection
	ams <- data3_1$df_clean$max
	sample_moments <- get_sample_lm(ams)
	results <- l_distance(sample_moments, distributions)
	list2env(results, envir = environment())

	# Check the distances
	expect_equal(distance$GEV$metric, 0.0230, tol = 1e-4) 
	expect_equal(distance$GUM$metric, 0.0285, tol = 1e-4) 
	expect_equal(distance$NOR$metric, 0.1623, tol = 1e-4) 
	expect_equal(distance$LNO$metric, 0.0411, tol = 1e-4) 
	expect_equal(distance$GLO$metric, 0.0636, tol = 1e-4) 
	expect_equal(distance$PE3$metric, 0.0080, tol = 1e-4) 
	expect_equal(distance$LP3$metric, 0.0247, tol = 1e-4) 
	expect_equal(distance$GNO$metric, 0.0198, tol = 1e-4) 
	expect_equal(distance$WEI$metric, 0.0114, tol = 1e-4) 
	expect_equal(distance$GPA$metric, 0.0585, tol = 1e-4) 

})


test_that("Test l-distance.R on data set #3.2", {

	# Load dataset and run L-distance selection
	ams <- data3_2$df_clean$max
	sample_moments <- get_sample_lm(ams)
	results <- l_distance(sample_moments, distributions)
	list2env(results, envir = environment())

	# Check the distances
	expect_equal(distance$GEV$metric, 0.0053, tol = 1e-4) 
	expect_equal(distance$GUM$metric, 0.0135, tol = 1e-4) 
	expect_equal(distance$NOR$metric, 0.1854, tol = 1e-4) 
	expect_equal(distance$LNO$metric, 0.0419, tol = 1e-4) 
	expect_equal(distance$GLO$metric, 0.0428, tol = 1e-4) 
	expect_equal(distance$PE3$metric, 0.0163, tol = 1e-4) 
	expect_equal(distance$LP3$metric, 0.0027, tol = 1e-4) 
	expect_equal(distance$GNO$metric, 0.0009, tol = 1e-4) 
	expect_equal(distance$WEI$metric, 0.0339, tol = 1e-4) 
	expect_equal(distance$GPA$metric, 0.0716, tol = 1e-4) 

})


test_that("Test l-distance.R on data set #3.3", {

	# Load dataset and run L-distance selection
	ams <- data3_3$df_clean$max
	sample_moments <- get_sample_lm(ams)
	results <- l_distance(sample_moments, distributions)
	list2env(results, envir = environment())

	# Check the distances
	expect_equal(distance$GEV$metric, 0.1030, tol = 1e-4) 
	expect_equal(distance$GUM$metric, 0.1376, tol = 1e-4) 
	expect_equal(distance$NOR$metric, 0.1513, tol = 1e-4) 
	expect_equal(distance$LNO$metric, 0.1110, tol = 1e-4) 
	expect_equal(distance$GLO$metric, 0.1513, tol = 1e-4) 
	expect_equal(distance$PE3$metric, 0.1022, tol = 1e-4) 
	expect_equal(distance$LP3$metric, 0.0692, tol = 1e-4) 
	expect_equal(distance$GNO$metric, 0.1073, tol = 1e-4) 
	expect_equal(distance$WEI$metric, 0.0810, tol = 1e-4) 
	expect_equal(distance$GPA$metric, 0.0104, tol = 1e-4) 

})
