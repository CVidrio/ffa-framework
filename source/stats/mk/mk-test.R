# Mann-Kendall test for trends
#  - data: A vector of AMS data or AMS variances with no NA values
#  - alpha: The significance level as a floating point number
mk_test <- function(data, alpha = 0.05) {

	# Assign a variable to number of data points for convenience
	n <- length(data)

	# Compute the test statistic S by iterating through all pairs of values in data
	s <- 0
	for (i in 1:(n-1)) {
		for (j in (i+1):n) {
			s = s + sign(data[j] - data[i])
		}
	}

	# Identify tied groups and find the number of elements in each group
	freqs <- table(data)        # Frequency of each data point
	ties <- freqs[freqs > 1]    # Get data points with frequency > 1 (i.e. ties)
	g <- length(ties)           # Get the total number of groups
	tp <- as.vector(ties)       # Get a vector of group sizes

	# Compute the normalized test statistic Z
	group_sum <- sum(tp * (tp - 1) * (2 * tp + 5))
	s_variance <- (1 / 18) * ((n * (n-1) * (2 * n + 5)) - group_sum)

	z <- if (s > 0) { 
		(s - 1) / sqrt(s_variance) 
	} else if (s == 0) { 
		0 
	} else { 
		(s + 1) / sqrt(s_variance) 
	}

	# Rename s to s_statistic for consistency with BBMK test
	s_statistic <- s

	# Compute the p-value for a two-sided test
	p_value <- 2 * pnorm(abs(z), lower.tail=FALSE)

	# Determine the outcome
	outcome <- ifelse(p_value <= alpha, "reject", "fail to reject")

	# Return the results of the test as a list
	mget(c("s_statistic", "s_variance", "p_value", "outcome"))

}

