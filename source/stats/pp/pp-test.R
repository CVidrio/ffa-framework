# Loading aTSA generates unnecessary warning messages
suppressPackageStartupMessages(library(aTSA))

# Conduct the Phillips-Perron unit root test
#  - ams: A vector of annual maximum streamflow data with no NA values
#  - alpha: The significance level as a floating point number
pp_test <- function(ams, alpha = 0.05) {

	# NOTE: The implementation of the Phillips-Perron test in the aTSA package
	# interpolates the p-value using a table from Banerjee et al. (1993). 
	# This table only contains significance thresholds for 0.01, 0.05, and 0.10.
	# Therefore, this test requires that 0.01 <= alpha <= 0.10.
	# Additionally, a p = 0.01 implies p <= 0.01 and p = 0.10 implies p >= 0.10.
	
	# NOTE: The documentation for this test can be found below
	# https://www.rdocumentation.org/packages/aTSA/versions/3.1.2.1/topics/pp.test
	
	# Run the Phillips-Perron test and return the p-value
	result <- pp.test(ams, output = FALSE)
	p_value <- result[3, 3]

	# Determine the outcome
	outcome <- ifelse(p_value <= alpha, "reject", "fail to reject")

	# Return the results as a list
	mget(c("p_value", "outcome"))

}
