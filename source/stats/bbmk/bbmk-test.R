# Load auxillary tests
source("stats/mk/mk-test.R")
source("stats/spearman/spearman-test.R")

# Block-Bootstrap Mann-Kendall test for identifying non-autocorrelated trends
#  - ams: A vector of annual maximum streamflow data with no NA values
#  - alpha: The significance level as a floating point number
#  - reps: The number of repetitions for the bootstrap
bbmk_test <- function(ams, alpha = 0.05, reps = 10000) {

	# Assign a variable to the number of data points for convenience
	n <- length(ams)

	# Compute least_lag and s_statistic from the Spearman and MK tests
	least_lag <- spearman_test(ams, alpha)$least_lag
	s_statistic  <- mk_test(ams, alpha)$s_statistic

	# Create blocks
	block_size <- least_lag + 1
	n_blocks <- ceiling(n / block_size)
	blocks <- split(ams[1:(n_blocks * block_size)], rep(1:n_blocks, each = block_size))

	# Loop through the bootstrap
	s_bootstrap <- numeric(reps )
	for (sample in 1:reps ) {

		# Sample blocks for this iteration
		sampled_blocks <- sample(blocks, n_blocks, replace = FALSE)
		resampled_series <- unlist(sampled_blocks, use.names = FALSE)
		ams_resampled <- resampled_series[!is.na(resampled_series)]

		# Compute the Mann-Kendall statistic for this iteration
		s <- 0
		for (i in 1:(n-1)) {
			for (j in (i+1):n) {
				s = s + sign(ams_resampled[j] - ams_resampled[i])
			}
		}

		s_bootstrap[sample] = s
	}

	# Compute the p-value empirically using the bootstrap distribution
	p_value <- ifelse(
		s_statistic < 0, 
		2 * mean(s_statistic >= s_bootstrap),
		2 * mean(s_statistic <= s_bootstrap)
	)

	# Compute the CI bounds
	bounds <- quantile(s_bootstrap, c(alpha / 2, 1 - (alpha / 2)))

	# Determine the outcome based on the p-value and alpha
	outcome <- ifelse(p_value <= alpha, "reject", "fail to reject")

	# Return the results as a list
	mget(c("s_bootstrap", "s_statistic", "p_value", "bounds", "outcome"))

}

