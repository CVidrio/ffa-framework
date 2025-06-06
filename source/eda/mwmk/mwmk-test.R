source("eda/mk/mk-test.R")

#' Mann-Kendall Test on Moving-Window Variance Series
#'
#' Applies the Mann-Kendall test to a precomputed moving-window standard deviation series
#' to detect significant monotonic trends in variance over time.
#'
#' @param std Numeric vector of moving-window standard deviations, no missing values.
#' @param alpha Numeric significance level for the test (default 0.05).
#' @param quiet Logical; if FALSE, print test summary messages (default TRUE).
#'
#' @return A list containing:
#' \describe{
#'   \item{p_value}{Computed p-value of the Mann-Kendall test.}
#'   \item{reject}{Logical indicating whether null hypothesis is rejected.}
#'   \item{std}{Input moving-window standard deviation vector.}
#'   \item{msg}{Summary message describing the test results.}
#' }
#'
#' @details
#' The function assumes that `std` is already derived via moving-window computations
#' (i.e., it is a series of variance estimates over time windows). The Mann-Kendall test
#' detects monotonic trends in this variance series, indicating changes in variability.

mwmk_test <- function(std, alpha = 0.05, quiet = TRUE) {

	# Run the Mann-Kendall test on the variance series
	results <- mk_test(std, alpha)

	# Print the results of the test
	part1 <- ifelse(results$reject, "reject", "fail to reject")
	part2 <- ifelse(results$reject, "evidence", "NO evidence")

	lines <- c(
		"The MW-MK test yielded a p-value of {round(results$p_value, 3)}.",
		"At a significance level of {alpha}, we {part1} the null hypothesis.",
		"Therefore, there is {part2} of a monotonic trend in the AMS variance."
	)

	msg <- glue(paste0("\n - ", lines, collapse = ""))
	if (!quiet) message(msg)

	# Add the variance series to results and return 
	c(results, list(std = std, msg = msg))

}

