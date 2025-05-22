# Mann-Kendall-Sneyers test for detecting the beginning of a trend 
#  - ams: A vector of annual maximum streamflow data with no NA values
#  - year: A vector of years corresponding to ams with no NA values
#  - alpha: The significance level as a floating point number
mks_test <- function(ams, year, alpha = 0.05, quiet = TRUE) {

	# Compute number of elements such that ams[i] > ams[j] for all j < i < t for all t.
	s_statistic <- function(vt, ams) {

		# Computes the number of elements such that ams[i] > ams[j] for j < i (given i).
		sum_i <- function(i) sum(ams[i] > ams[1:i-1])

		# Applies the sum_i function to a vector values.
		n_i <- sapply(vt, sum_i)

		# Compute cumulative sum of n_i values to get the S-statistic for all t.
		cumsum(n_i)
	}

	# Compute the forward and backwards s-statistics
	idx <- 1:length(ams)
	s_prog_non_normal <- s_statistic(idx, ams)
	s_regr_non_normal <- s_statistic(idx, rev(ams))

	# Get the variance and expectation of the S-statistics
	s_expectation = idx * (idx - 1) / 4
	s_variance = (idx * (idx - 1) * ((2 * idx) + 5)) / 72

	# Prevent a division by zero error at idx = 1
	s_variance[s_variance == 0] <- 1

	# Compute the normalized progressive and regressive s-statistics
	s_prog <- (s_prog_non_normal - s_expectation) / sqrt(s_variance)
	s_regr <- rev((s_regr_non_normal - s_expectation) / sqrt(s_variance))

	# Compute confidence bounds for the normalized s-statistics
	bound <- qnorm(1 - (alpha / 2))

	# Find all crossings between progressive/regressive series
	# Increment by one so that the crossing index is the start of the time series
	s_sign <- sign(s_prog - s_regr)
	cross <- which(s_sign[-1] != s_sign[-length(s_sign)]) + 1

	# Compute the location of each crossing using linear interpolation
	get_crossings <- function(i) {

		# Fit linear models 
		fit_prog <- lm(s_prog[(i - 1):i] ~ year[(i - 1):i])
		fit_regr <- lm(s_regr[(i - 1):i] ~ year[(i - 1):i])

		# Get the slope and y-intercept of each line
		b_prog <- coef(fit_prog)[1]
		b_regr <- coef(fit_regr)[1]
		m_prog <- coef(fit_prog)[2]
		m_regr <- coef(fit_regr)[2]

		# Compute and return y-coordinate of the intersection point
		x_inter = (b_regr - b_prog) / (m_prog - m_regr)
		y_inter = (m_prog * x_inter) + b_prog
		as.numeric(y_inter)

	}

	# Get crossing locations
	locations <- if (length(cross) == 0) numeric() else sapply(cross, get_crossings)

	# Create a dataframe of all crossings
	crossing_df <- data.frame(
		cross = cross,
		year = year[cross],
		statistic = locations,
		max = ams[cross]
	)

	# Compute the p-value of the test and the statistically significant crossings
	if (nrow(crossing_df) > 0) {
		p_value <- 2 * (1 - pnorm(max(abs(crossing_df$statistic))))
		change_df <- crossing_df[which(abs(crossing_df$statistic) > bound), ]
	} else {
		p_value <- 1
		change_df <- crossing_df
	}

	# Determine whether we reject or fail to reject based on p_value and alpha
	reject <- (p_value <= alpha)

	# Print the results of the test
	if (reject) {
		part1 <- "reject"
		part2 <- glue("evidence of change point(s) at {toString(change_df$year)}")
	} else {
		part1 <- "fail to reject"
		part2 <- "NO evidence of change point(s)"
	}

	lines <- c(
		"The MKS test yielded a p-value of {round(p_value, 3)}.",
		"At a significance level of {alpha}, we {part1} the null hypothesis.",
		"Therefore, there is {part2}."
	)

	msg <- glue(paste0("\n - ", lines, collapse = ""))
	if (!quiet) message(msg)

	# Return a list of values results from the test
	mget(c(
		"s_prog",
		"s_regr",
		"bound",
		"crossing_df",
		"change_df",
		"p_value",
		"reject",
		"msg"
	))
	
}
