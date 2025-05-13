# Perform the White test to check for heteroskedasticity
#  - ams: A vector of annual maximum streamflow data with no NA values
#  - year: A numeric vector of years corresponding to ams with no NA values
#  - alpha: The significance level as a floating point number
white_test <- function(ams, year, alpha = 0.05) {

	# Do a linear regression of ams against year, get the squared residuals
	primary_model <- lm(ams ~ year)
	squared_residuals <- resid(primary_model)^2

	# Fit an auxillary model to the squared residuals, get the R^2 statistic
	auxillary_model <- lm(squared_residuals ~ year + I(year^2))
	r_squared <- summary(auxillary_model)$r.squared

	# Compute the test statistic and p-value
	test_statistic <- length(ams) * r_squared

	# NOTE: The Chi-squared distribution used to compute the p-value has 2 
	# degrees of freedom because we are using 2 regressors (year and year^2). 
	# See the documentation for more information.
	p_value <- 1 - pchisq(test_statistic, df = 2)

	# Return the results of the test
	mget(c("r_squared", "test_statistic", "p_value"))

}
