suppressPackageStartupMessages(library(aTSA))

#' Kwiatkowski–Phillips–Schmidt–Shin (KPSS) Unit Root Test
#'
#' Performs the KPSS test for stationarity in annual maximum streamflow (AMS) data using the
#' \pkg{aTSA} package. The null hypothesis is that the time series is stationary.
#'
#' @param ams A numeric vector of annual maximum streamflow data. Must not contain NA values.
#' @param alpha A numeric value indicating the significance level. Must be 0.01, 0.05, or 0.10.
#' @param quiet Logical. If FALSE, prints a summary message to the console (default is TRUE).
#'
#' @return A named list with the following components:
#' \describe{
#'   \item{p_value}{The reported p-value from the test. See notes regarding discrete thresholds.}
#'   \item{reject}{Logical. TRUE if the null hypothesis of stationarity is rejected at \code{alpha}.}
#'   \item{msg}{Character string summarizing the test outcome, printed if \code{quiet = FALSE}.}
#' }
#'
#' @details
#' The KPSS test implementation in \pkg{aTSA} uses interpolation from the Hobjin et al. (2004)
#' significance table, which only includes thresholds for 0.01, 0.05, and 0.10. As such, the
#' returned p-values are discretized. Specifically, p = 0.01 implies p ≤ 0.01, and p = 0.10
#' implies p ≥ 0.10.
#'
#' @note This function suppresses startup messages from \pkg{aTSA} and its dependency \pkg{tseries}.
#'
#' @seealso \code{\link[aTSA]{kpss.test}}
#' @export

kpss_test <- function(ams, alpha = 0.05, quiet = TRUE) {

	# Run the KPSS test and get the p_value
	result <- kpss.test(ams, output = FALSE)
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
	part2 <- ifelse(reject, "evidence", "NO evidence")

	lines <- c(
		"The KPSS test yielded a p-value of {p_text}.",
		"At a significance level of {alpha}, we {part1} the null hypothesis.",
		"Therefore, there is {part2} of a unit root."
	)

	msg <- glue(paste0("\n - ", lines, collapse = ""))
	if (!quiet) message(msg)

	# Return the results
	mget(c("p_value", "reject", "msg"))

}

