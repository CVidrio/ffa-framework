#' Pettitt Test for Abrupt Changes in the Mean of a Time Series
#'
#' Performs the non-parametric Pettitt test to detect a single change point in the
#' mean of a time series, often used for abrupt shifts in hydrological data.
#'
#' @param ams Numeric vector of annual maximum streamflow values, no missing data.
#' @param year Numeric vector of years corresponding to \code{ams}, no missing data.
#' @param alpha Numeric significance level for hypothesis testing (default 0.05).
#' @param quiet Logical; if FALSE, print test summary messages (default TRUE).
#'
#' @return A named list containing:
#' \describe{
#'   \item{u_t}{Vector of absolute U-statistics for all time indices.}
#'   \item{k_statistic}{Maximum absolute U-statistic (test statistic).}
#'   \item{k_alpha}{Critical K-statistic value for given \code{alpha}.}
#'   \item{p_value}{Approximate p-value for the test.}
#'   \item{change_index}{Index of the detected change point (0 if none).}
#'   \item{change_year}{Year of the detected change point (0 if none).}
#'   \item{reject}{Logical indicating if null hypothesis was rejected.}
#'   \item{msg}{Formatted summary message describing the test result.}
#' }
#'
#' @details
#' The Pettitt test is a rank-based non-parametric test that evaluates the
#' hypothesis of a change point in the median/mean of a time series.
#' It computes the maximum of the absolute value of the U-statistic over all
#' possible split points. The p-value is approximated using an asymptotic formula.
#'
#' @references Pettitt, A.N. (1979) A non-parametric approach to the change-point problem,
#' \emph{Applied Statistics}, 28(2), 126-135.
 
pettitt_test <- function(ams, year, alpha = 0.05, quiet = TRUE) {

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
	if (!quiet) message(msg)

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
