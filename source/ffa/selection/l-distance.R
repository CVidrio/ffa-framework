library(lmom)

#' L-Distance Method for Distribution Selection Using L-Moment Ratios
#'
#' Selects the best-fit distribution from a candidate set by minimizing the Euclidean distance
#' between theoretical and sample L-moment ratios (\eqn{\tau_3}, \eqn{\tau_4}). This method
#' quantifies goodness-of-fit in the L-moment ratio space and returns the closest matching
#' distribution.
#'
#' @param sample_moments A named list containing sample L-moments, with components:
#'   \code{lm} for raw AMS, and \code{log_lm} for log-transformed AMS.
#' @param distributions A named list of distribution specifications. Each entry must contain:
#'   \code{moments}, a data frame of theoretical L-moment ratios, and a logical \code{log}
#'   indicating whether log-transformed moments should be used.
#'
#' @return A named list containing:
#' \describe{
#'   \item{distance}{A list of fitted moment points for each candidate distribution with
#'     associated L-distance metrics.}
#'   \item{recommendation}{The name of the distribution with the smallest L-distance.}
#' }
#'
#' @details
#' For each candidate distribution, the method computes the Euclidean distance between
#' sample L-moment ratios (\eqn{\tau_3}, \eqn{\tau_4}) and the closest point on the
#' theoretical distribution's L-moment surface. The distribution with the minimum distance
#' is selected.
#'
#' If a distribution is flagged as requiring log-transformed data, the \code{log_lm}
#' component is used for matching.
#'
#' @seealso \code{\link{z_statistic}}, \code{\link{l_kurtosis}}
#' @export

l_distance <- function(sample_moments, distributions) {

	# Compute euclidian distance between distribution/sample L-moment ratios
	get_minimum_distance <- function(dlm, slm) { 
		dlm$metric <- sqrt((dlm$t3 - slm$t3)^2 + (dlm$t4 - slm$t4)^2)
		as.list(dlm[which.min(dlm$metric), ])
	}

	# Generate a list containing the distances for each distribution
	distance <- lapply(distributions, function(distribution) { 
		dlm <- distribution$moments
		slm <- if (distribution$log) { sample_moments$log_lm } else { sample_moments$lm }
		get_minimum_distance(dlm, slm)	
	})

	# Get the distribution with the best fit
	metrics <- sapply(distance, function(x) x$metric)
	recommendation <- names(distance)[[ which.min(metrics) ]]

	# Return the results as a list
	mget(c("distance", "recommendation"))	

}
