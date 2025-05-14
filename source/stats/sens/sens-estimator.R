library(randtests)

# Compute Sen's trend estimator for a dataframe
#  - data: A vector of AMS data or AMS variances with no NA values
#  - year: A numeric vector of years corresponding to data with no NA values
sens_estimator <- function(data, year) {

	# Get the length of data for convenience
	n <- length(data)

	# Compute all pairwise slopes
	slopes <- c()
	for (i in 1:(n-1)) {
		for (j in (i+1):n) {
			slopes <- c(slopes, (data[j] - data[i]) / (year[j] - year[i]))
		}
	}

	# Get the estimate for the slope
	sens_slope <- median(slopes)

	# Get the estimate for the intercept
	intercepts <- data - (sens_slope * year)
	sens_intercept <- median(intercepts)

	# Compute the predicted AMS values and the residuals
	predicted_data <- sens_intercept + (sens_slope * year)
	residuals <- data - predicted_data

	# Check for randomness of the residuals using the Wald-Wolfowitz runs test
	# https://search.r-project.org/CRAN/refmans/randtests/html/runs.test.html
	results <- runs.test(residuals)
	p_value <- results$p.value

	# Return the results as a list
	mget(c("sens_slope", "sens_intercept", "residuals", "p_value"))

}
