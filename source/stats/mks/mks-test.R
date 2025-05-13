# Mann-Kendall-Sneyers test for detecting the beginning of a trend 
#  - ams: A vector of annual maximum streamflow data with no NA values
#  - year: A numeric vector of years corresponding to ams with no NA values
#  - alpha: The significance level as a floating point number
mks_test <- function(ams, year, alpha = 0.05) {

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
	s_sign <- sign(s_prog - s_regr)
	cross <- which(s_sign[-1] != s_sign[-length(s_sign)])

	# Compute the location of each crossing using linear interpolation
	get_crossing_location <- function(i) {

		# Fit linear models 
		fit_prog <- lm(s_prog[i:(i + 1)] ~ year[i:(i + 1)])
		fit_regr <- lm(s_regr[i:(i + 1)] ~ year[i:(i + 1)])

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

	y_cross <- sapply(cross, get_crossing_location)

	# Compute the p-value of the test (i.e. the maximum crossing location)
	p_value <- ifelse(
		length(y_cross) > 0,
		2 * pnorm(max(abs(y_cross)), lower.tail=FALSE),
		1
	)

	# Return a list of values results from the test
	mget(c("s_prog", "s_regr", "bound", "cross", "y_cross", "p_value"))
	
}


