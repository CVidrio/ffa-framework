library(parallel)

# Load auxillary tests
source("eda/mk/mk-test.R")
source("eda/spearman/spearman-test.R")

# Block-Bootstrap Mann-Kendall test for identifying non-autocorrelated trends
#  - ams: A vector of annual maximum streamflow data with no NA values
#  - alpha: The significance level as a floating point number
#  - n_sim: The number of repetitions for the bootstrap
bbmk_test <- function(ams, alpha = 0.05, n_sim = 10000, quiet = TRUE) {

	# Assign a variable to the number of data points for convenience
	n <- length(ams)

	# Compute least_lag and s_statistic from the Spearman and MK tests
	least_lag <- spearman_test(ams, alpha)$least_lag
	s_statistic  <- mk_test(ams, alpha)$s_statistic

	# Create blocks
	block_size <- least_lag + 1
	n_blocks <- ceiling(n / block_size)
	blocks <- split(ams[1:(n_blocks * block_size)], rep(1:n_blocks, each = block_size))

	# Loop through the bootstrap in parallel
	bootstrap_list <- mclapply(1:n_sim, function(i) { 

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

		return (s)
	})

	bootstrap_results <- as.numeric(bootstrap_list)

	# Compute the p-value empirically using the bootstrap distribution
	p_value <- ifelse(
		s_statistic < 0, 
		2 * mean(s_statistic >= bootstrap_results),
		2 * mean(s_statistic <= bootstrap_results)
	)

	# Compute the CI bounds
	bounds <- quantile(bootstrap_results, c(alpha / 2, 1 - (alpha / 2)))

	# Determine whether we reject or fail to reject based on p_value and alpha
	reject <- (p_value <= alpha)

	# Print the results of the test
	part1 <- ifelse(reject, "reject", "fail to reject")
	part2 <- ifelse(reject, "was NOT due to", "was due to")

	lines <- c(
		"The BB-MK test yielded a p-value of {round(p_value, 3)}.",
		"At a significance level of {alpha}, we {part1} the null hypothesis.",
		"Therefore, the trend identified by the MK test {part2} serial correlation."
	)

	msg <- glue(paste0("\n - ", lines, collapse = ""))
	if (!quiet) message(msg)

	# Return the results as a list
	mget(c("bootstrap_results", "s_statistic", "p_value", "bounds", "reject", "msg"))

}

