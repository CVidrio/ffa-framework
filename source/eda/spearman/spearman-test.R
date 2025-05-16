# Spearman test for serial correlation
#  - ams: A vector of annual maximum streamflow data
#  - alpha: The significance level as a floating point number
spearman_test <- function(ams, alpha = 0.05, quiet = FALSE) {

	# Assign a variable to the number of data points for convenience
	n <- length(ams)

	# Compute the spearman rho-autocorrelation for a given lag
	rho_autocorrelation <- function(lag, ams) {
		ams_original <- ams[(lag + 1):length(ams)]
		ams_lagged <- ams[1:(length(ams) - lag)]
		cor.test(ams_original, ams_lagged, method="spearman", exact=FALSE)
	}

	# Find the lowest non-significant serial correlation lag
	rho <- numeric(n - 3)
	ps <- numeric(n - 3)

	for (i in 1:(n - 3)) {
		result <- rho_autocorrelation(i, ams)
		rho[i] = result$estimate
		ps[i] = result$p.value
	}

	least_lag <- which(ps > alpha)[1] - 1

	# Get a series of booleans for whether the serial correlation is significant
	sig <- (ps < alpha)

	# Print the results
	part <- ifelse(least_lag > 0, "evidence", "NO evidence")

	lines <- c(
		"The Spearman test found a least insignificant lag of {least_lag}.",
		"Therefore, there is {part} of serial correlation."
	)

	msg <- glue(paste0("\n - ", lines, collapse = ""))
	if (!quiet) message(msg)

	# Return the results as a list
	mget(c("rho", "sig", "least_lag", "msg"))

}
