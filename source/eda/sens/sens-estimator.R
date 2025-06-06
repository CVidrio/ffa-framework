library(randtests)

#' Sen's Slope Estimator with Residual Randomness Test
#'
#' Computes Sen's slope estimator and intercept for a univariate time series and evaluates the
#' randomness of the residuals using the Wald–Wolfowitz runs test. This method provides a
#' non-parametric linear trend estimate and a post hoc check on model adequacy.
#'
#' @param data Numeric vector of AMS values or variances with no missing values.
#' @param year Numeric vector of years corresponding to \code{data}, with no missing values.
#' @param alpha Numeric significance level for the runs test (default is 0.05).
#' @param quiet Logical. If FALSE, prints a summary message describing results (default is TRUE).
#'
#' @return A named list containing:
#' \describe{
#'   \item{sens_slope}{Median slope of all pairwise data-year combinations (Sen's slope).}
#'   \item{sens_intercept}{Median intercept estimate of the fitted line.}
#'   \item{residuals}{Vector of residuals between observed and fitted values.}
#'   \item{p_value}{P-value from the Wald–Wolfowitz runs test applied to residuals.}
#'   \item{reject}{Logical. TRUE if null hypothesis of random residuals is rejected.}
#'   \item{msg}{Character string summarizing the estimator and test result.}
#' }
#'
#' @details
#' Sen's slope estimator is a robust, non-parametric trend estimator computed from the median
#' of all pairwise slopes between data points. The corresponding intercept is taken as the
#' median of residual-corrected values. To assess the assumption of independence in residuals,
#' the Wald–Wolfowitz runs test is applied to the residual sequence.
#'
#' Rejection of the null hypothesis in the runs test indicates non-randomness in residuals,
#' which may suggest model misfit or autocorrelation.
#'
#' @references
#' Sen, P.K. (1968). Estimates of the regression coefficient based on Kendall's tau.
#' \emph{Journal of the American Statistical Association}, 63(324), 1379–1389. \cr
#' Wald, A., & Wolfowitz, J. (1940). On a test whether two samples are from the same population.
#' \emph{Annals of Mathematical Statistics}, 11(2), 147–162.
#'
#' @seealso \code{\link[randtests]{runs.test}}, \code{\link{mk_test}}
#' @export

sens_estimator <- function(data, year, alpha = 0.05, quiet = TRUE) {

	# Get the length of data for convenience
	n <- length(data)

	# Compute all pairwise slopes
	slopes <- c()
	for (i in 1:(n-1)) {
		for (j in (i+1):n) {
			slopes <- c(slopes, (data[j] - data[i]) / (year[j] - year[i]))
		}
	}

	# Get the estimate for the slope
	sens_slope <- median(slopes)

	# Get the estimate for the intercept
	intercepts <- data - (sens_slope * year)
	sens_intercept <- median(intercepts)

	# Compute the predicted AMS values and the residuals
	predicted_data <- sens_intercept + (sens_slope * year)
	residuals <- data - predicted_data

	# Check for randomness of the residuals using the Wald-Wolfowitz runs test
	# https://search.r-project.org/CRAN/refmans/randtests/html/runs.test.html
	results <- runs.test(residuals)
	p_value <- results$p.value

	# Determine whether we reject or fail to reject based on p_value and alpha
	reject <- (p_value <= alpha)

	# Print the results of Sen's trend estimator and the Runs test
	m <- sens_slope
	b <- sens_intercept

	part1 <- ifelse(reject, "reject", "fail to reject")
	part2 <- ifelse(reject, "are NOT random", "are random")

	lines <- c(
		"Estimated trend: y = {round(m, 3)}x + {round(b, 2)}.",
		"The Runs test yielded a p-value of {round(p_value, 3)}.",
		"At a significance level of {alpha}, we {part1} the null hypothesis.",
		"Therefore, there is evidence the residuals {part2}."
	)

	msg <- glue(paste0("\n - ", lines, collapse = ""))
	if (!quiet) message(msg)

	# Return the results as a list
	mget(c("sens_slope", "sens_intercept", "residuals", "p_value", "reject", "msg"))

}
