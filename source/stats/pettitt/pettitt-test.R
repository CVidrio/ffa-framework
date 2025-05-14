# Mann-Whitney-Pettitt hypothesis test for abrupt changes in the mean
#  - ams: A vector of annual maximum streamflow data with no NA values
#  - alpha: The significance level as a floating point number
pettitt_test <- function(ams, alpha = 0.05) {

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
	k <- max(u_t)

	# Compute the p-value using an approximate formula
	p_value <- round(exp((-6 * k^2) / (n^3 + n^2)), digits=3)

	# Find the minimum statistically significant K-statistic 
	k_alpha <- (-log(alpha) * ((n^3) + (n^2)) / 6)^0.5;

	# Determine the change index if the change is statistically significant
	change_index <- ifelse(k > k_alpha, which.max(u_t), 0)

	# Determine the outcome
	outcome <- ifelse(p_value <= alpha, "reject", "fail to reject")

	# Return a list containing the results of the test
	mget(c("u_t", "k", "k_alpha", "p_value", "change_index", "outcome"))

}
