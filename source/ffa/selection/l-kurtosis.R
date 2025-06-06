library(lmom)

#' L-Kurtosis Method for Distribution Selection Using L-Moment Ratios
#'
#' Selects a best-fit probability distribution by minimizing the absolute vertical
#' distance (in \eqn{\tau_4}) between the sample L-moment ratios and the theoretical
#' L-moment curves for candidate 3-parameter distributions.
#'
#' @param sample_moments A named list of sample L-moments, with components:
#'   \code{lm} for raw AMS data and \code{log_lm} for log-transformed AMS data.
#' @param distributions A named list of candidate distribution specifications. Each entry must
#'   contain \code{moments} (a data frame of theoretical L-moment ratios) and a logical \code{log}
#'   flag indicating whether log-transformed sample moments should be used.
#'
#' @return A named list containing:
#' \describe{
#'   \item{distance}{A list of interpolated L-moment matches and kurtosis-based metrics for each distribution.}
#'   \item{recommendation}{Name of the distribution with the smallest L-kurtosis deviation.}
#' }
#'
#' @details
#' This method computes the vertical distance in \eqn{\tau_4} (L-kurtosis) between the sample
#' and theoretical L-moment ratio diagrams at fixed \eqn{\tau_3} (L-skewness). The interpolated
#' \eqn{\tau_4} and \eqn{\kappa} values are derived using \code{\link[stats]{approx}}.
#'
#' Only 3-parameter distributions are considered in this method. Specifically, it evaluates
#' GEV, GLO, PE3, LP3, GNO, WEI, and GPA. For more information, see the FFA framework website.
#'
#' @seealso \code{\link{l_distance}}, \code{\link{z_statistic}}
#' @export

l_kurtosis <- function(sample_moments, distributions) {
	
	# Compute y-distance between distribution/sample L-moment ratios
	get_y_distance <- function(dlm, slm) {
		tau4 <- suppressWarnings(approx(dlm$t3, dlm$t4, slm$t3)$y)
		kappa <- suppressWarnings(approx(dlm$t3, dlm$k, slm$t3)$y)
		y <- abs(slm$t4 - tau4)
		list(t3 = slm$t3, t4 = tau4, k = kappa, metric = y)
	}

	# Run the selection on a subset of the distributions
	distribution_list <- c("GEV", "GLO", "PE3", "LP3", "GNO", "WEI", "GPA")
	valid_distributions <- distributions[ distribution_list ]

	# Generate a list containing the distances for each 3-parameter distribution
	distance <- lapply(valid_distributions, function(distribution) {
		dlm <- distribution$moments
		slm <- if (distribution$log) { sample_moments$log_lm } else { sample_moments$lm }
		get_y_distance(dlm, slm)
	})

	# Get the distribution with the best fit
	metrics <- sapply(distance, function(x) x$metric)
	recommendation <- names(distance)[[ which.min(metrics) ]]
	
	# Return the results as a list
	mget(c("distance", "recommendation"))	

}
