# Mann-Whitney-Pettitt hypothesis test for abrupt changes in the mean
#  - ams: A vector of annual maximum streamflow data with no NA values
#  - year: A vector of years corresponding to ams with no NA values
#  - alpha: The significance level as a floating point number
pettitt_test <- function(ams, year, alpha = 0.05) {

	# Extract the length of ams for convenience
	n <- length(ams)

	# Compute the U-statistic for all t-values from 1 to n
	u_t <- numeric(n)

	for (t in 1:n) {
		u <- 0

		# u_t = sum(sign(ams[j] - ams[i])) for all i <= t, j > t
		for (i in 1:t) {
			for (j in min(t + 1, n):n) {
				u = u + sign(ams[j] - ams[i])
			}
		}

		u_t[t] = abs(u)
	}

	# The K-statistic is the maximum absolute value of the U-statistics
	k_statistic <- max(u_t)

	# Compute the p-value using an approximate formula
	p_value <- round(exp((-6 * k_statistic^2) / (n^3 + n^2)), digits=3)

	# Find the minimum statistically significant K-statistic 
	k_alpha <- (-log(alpha) * ((n^3) + (n^2)) / 6)^0.5;

	# Determine the change index if the change is statistically significant
	reject <- (p_value <= alpha)
	change_index <- ifelse(reject, which.max(u_t), 0)
	change_year <- ifelse(reject, year[change_index], 0)

	# Print the results of the test
	if (reject) {
		part1 <- "reject"
		part2 <- glue("evidence of a change point in {change_year}")
	} else {
		part1 <- "fail to reject"
		part2 <- "NO evidence of a change point"
	}

	lines <- c(
		"The Pettitt test yielded a p-value of {round(p_value, 3)}.",
		"At a significance level of {alpha}, we {part1} the null hypothesis.",
		"Therefore, there is {part2}."
	)

	msg <- glue(paste0("\n - ", lines, collapse = ""))
	message(msg)

	# Return a list containing the results of the test
	mget(c(
		"u_t",
		"k_statistic",
		"k_alpha",
		"p_value",
		"change_index",
		"change_year",
		"reject",
		"msg"
	))

}
