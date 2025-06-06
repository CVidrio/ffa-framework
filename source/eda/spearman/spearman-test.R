#' Spearman Test for Serial Correlation in Time Series
#'
#' Performs the Spearman rank autocorrelation test on annual maximum streamflow (AMS) data to
#' assess the presence of serial correlation at various lags. Reports the first lag where
#' autocorrelation is no longer statistically significant at the specified level.
#'
#' @param ams Numeric vector of annual maximum streamflow data with no missing values.
#' @param alpha Numeric significance level for the test (default is 0.05).
#' @param quiet Logical. If FALSE, prints a summary message describing the result (default is TRUE).
#'
#' @return A named list containing:
#' \describe{
#'   \item{rho}{Vector of Spearman autocorrelation estimates for lags \code{1} to \code{n - 3}.}
#'   \item{sig}{Logical vector indicating which lags exhibit significant autocorrelation.}
#'   \item{least_lag}{The smallest lag at which autocorrelation is not statistically significant.}
#'   \item{msg}{Character string summarizing the test result (printed if \code{quiet = FALSE}).}
#' }
#'
#' @details
#' For each lag from 1 to \code{n - 3}, the function computes the Spearman rank correlation
#' between the AMS series and its lagged version. The first lag with a non-significant
#' autocorrelation (p-value > \code{alpha}) is returned as \code{least_lag}.
#'
#' This test is useful for identifying the minimum temporal separation required to ensure
#' approximate independence, especially when constructing block-bootstrap resampling schemes.
#'
#' @seealso \code{\link[stats]{cor.test}}, \code{\link{bbmk_test}}
#' @export

spearman_test <- function(ams, alpha = 0.05, quiet = TRUE) {

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
