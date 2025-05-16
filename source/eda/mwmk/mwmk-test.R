# Import the Mann-Kendall test
source("eda/mk/mk-test.R")

# Perform the MW-MK test to check for trends in the variance
#  - std: A vector of annual maximum streamflow standard deviations
#  - alpha: The significance level as a floating point number
mwmk_test <- function(std, alpha = 0.05) {

	# Run the Mann-Kendall test on the variance series
	results <- mk_test(std, alpha, quiet = TRUE)

	# Print the results of the test
	part1 <- ifelse(results$reject, "reject", "fail to reject")
	part2 <- ifelse(results$reject, "evidence", "NO evidence")

	lines <- c(
		"The MW-MK test yielded a p-value of {round(results$p_value, 3)}.",
		"At a significance level of {alpha}, we {part1} the null hypothesis.",
		"Therefore, there is {part2} of a monotonic trend in the AMS variance."
	)

	msg <- glue(paste0("\n - ", lines, collapse = ""))
	message(msg)

	# Add the variance series to results and return 
	c(results, list(std = std, msg = msg))

}

