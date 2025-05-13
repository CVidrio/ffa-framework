# Import the Mann-Kendall test
source("stats/mk/mk-test.R")

# Perform the MW-MK test to check for trends in the variance
#  - std: A vector of annual maximum streamflow standard deviations
#  - alpha: The significance level as a floating point number
mwmk_test <- function(std, alpha = 0.05) {

	# Run the Mann-Kendall test on the variance series
	results <- mk_test(std, alpha)

	# Add the variance series to results and return 
	results$std <- std
	results

}

