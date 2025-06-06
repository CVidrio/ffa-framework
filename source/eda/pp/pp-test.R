suppressPackageStartupMessages(library(aTSA))

#' Phillips–Perron Unit Root Test
#'
#' Applies the Phillips–Perron (PP) test to assess the presence of a unit root in annual
#' maximum streamflow (AMS) data. The null hypothesis is that the series contains a unit root
#' (i.e., is non-stationary).
#'
#' @param ams Numeric vector of annual maximum streamflow data with no missing values.
#' @param alpha Numeric significance level. Must be one of 0.01, 0.05, or 0.10.
#' @param quiet Logical. If FALSE, prints a summary message to the console (default is TRUE).
#'
#' @return A named list containing:
#' \describe{
#'   \item{p_value}{Reported p-value from the test. See notes on interpolation thresholds.}
#'   \item{reject}{Logical. TRUE if the null hypothesis of a unit root is rejected at \code{alpha}.}
#'   \item{msg}{Character string summarizing the test result (printed if \code{quiet = FALSE}).}
#' }
#'
#' @details
#' The test is implemented using the \pkg{aTSA} package, which interpolates p-values from the
#' critical values in Banerjee et al. (1993). The critical values are only available for
#' \code{alpha = 0.01}, \code{0.05}, and \code{0.10}. A reported p-value of 0.01 indicates
#' \eqn{p \leq 0.01}, and 0.10 indicates \eqn{p \geq 0.10}.
#'
#' The null hypothesis is that the time series contains a unit root (non-stationary). Rejection
#' of the null suggests that the series is stationary.
#'
#' @references Banerjee, A., Dolado, J., Galbraith, J.W., & Hendry, D.F. (1993). \emph{Cointegration,
#' Error Correction, and the Econometric Analysis of Non-Stationary Data}. Oxford University Press.
#'
#' @seealso \code{\link[aTSA]{pp.test}}, \code{\link{kpss_test}}, \code{\link{mk_test}}
#' @export

pp_test <- function(ams, alpha = 0.05, quiet = TRUE) {
	
	# Run the Phillips-Perron test and return the p-value
	result <- pp.test(ams, output = FALSE)
	p_value <- result[3, 3]

	# Determine whether we reject or fail to reject based on p_value and alpha
	reject <- if (alpha == 0.10) p_value < alpha else p_value <= alpha

	# Set the P-value text to inform the user of the limited significance thresholds
	p_text <- if (p_value == 0.10) { 
		"*at least* 0.10" 
	} else if (p_value == 0.01) {
		"*at most* 0.01"
	} else {
		round(p_value, 3)
	}

	# Print the results of the test
	part1 <- ifelse(reject, "reject", "fail to reject")
	part2 <- ifelse(reject, "NO evidence", "evidence")

	lines <- c(
		"The PP test yielded a p-value of {p_text}.",
		"At a significance level of {alpha}, we {part1} the null hypothesis.",
		"Therefore, there is {part2} of a unit root."
	)

	msg <- glue(paste0("\n - ", lines, collapse = ""))
	if (!quiet) message(msg)

	# Return the results as a list
	mget(c("p_value", "reject", "msg"))

}
