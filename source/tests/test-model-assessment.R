# Set seed for reproducibility
set.seed(1)

test_that("Test model-assessment on data set #1 with GEV/L-moments/S-bootstrap.", {

	# Load dataset and run L-moments estimation with uncertainty analysis
	ams <- data1$df_clean$max
	estimation_results <- l_moments(ams, "GEV")
	uncertainty_results <- s_bootstrap(ams, "GEV", "L-moments")
	assessment <- model_assessment(ams, "GEV", estimation_results, uncertainty_results)

	# Test results against MATLAB
	expect_equal(assessment$R2  ,   0.9922, tol = 1e-3)
	expect_equal(assessment$RMSE,  95.9225, tol = 1e-3)
	expect_equal(assessment$Bias, -20.6072, tol = 1e-2)
	expect_equal(assessment$AIC , 471.4811, tol = 1e-3)
	expect_equal(assessment$BIC , 479.3561, tol = 1e-3)
	expect_equal(assessment$AW  , 603.0077, tol = 2e-2)
	expect_equal(assessment$POC , 100.0000)
	expect_equal(assessment$CWI , 545.6239, tol = 2e-2)

})


test_that("Test model-assessment on data set #2 with GPA/L-moments/S-bootstrap.", {

	# Load dataset and run L-moments estimation with uncertainty analysis
	ams <- data2$df_clean$max
	estimation_results <- l_moments(ams, "GPA")
	uncertainty_results <- s_bootstrap(ams, "GPA", "L-moments")
	assessment <- model_assessment(ams, "GPA", estimation_results, uncertainty_results)

	# Test results against MATLAB
	expect_equal(assessment$R2  ,   0.9889, tol = 1e-3)
	expect_equal(assessment$RMSE,  73.2271, tol = 1e-3)
	expect_equal(assessment$Bias,  -3.6277, tol = 1e-2)
	expect_equal(assessment$AIC , 396.7145, tol = 1e-3)
	expect_equal(assessment$BIC , 404.2471, tol = 1e-3)
	expect_equal(assessment$AW  , 430.1129, tol = 2e-2)
	expect_equal(assessment$POC , 100.0000)
	expect_equal(assessment$CWI , 389.1822, tol = 2e-2)

})


