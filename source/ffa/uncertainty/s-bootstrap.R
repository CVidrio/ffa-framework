library(lmom)
library(parallel)

source("ffa/estimation/l-moments.R")


#' Sample Bootstrap Confidence Intervals for Flood Quantile Estimates
#'
#' Computes confidence intervals for flood quantile estimates using the nonparametric
#' sample bootstrap method, based on L-moment parameter estimation. This function supports
#' uncertainty quantification for return period estimates derived from a fitted distribution.
#'
#' @param ams Numeric vector of annual maximum streamflow values (no missing values).
#' @param distribution A list representing the selected distribution, which must contain a
#'   \code{quantile} function for inverse evaluation.
#' @param method Character string specifying the estimation method. Currently supports only
#'   \code{"L-moments"}.
#' @param n_sim Integer number of bootstrap simulations (default is 100000).
#' @param alpha Numeric significance level for the confidence intervals (default is 0.05).
#'
#' @return A named list containing:
#' \describe{
#'   \item{estimates}{Vector of estimated quantiles for return periods 2, 5, 10, 20, 50, and 100.}
#'   \item{ci_lower}{Lower bound of the confidence interval for each return period.}
#'   \item{ci_upper}{Upper bound of the confidence interval for each return period.}
#'   \item{t}{Vector of return periods (2, 5, 10, 20, 50, and 100).}
#' }
#'
#' @details
#' The bootstrap procedure simulates resamples from the fitted distribution via inverse transform
#' sampling using the estimated parameters. For each resample, L-moment parameters are re-estimated
#' and used to compute quantiles. Confidence intervals are obtained by applying empirical quantiles
#' to the resulting distribution of estimates.
#'
#' The function currently only supports the L-moments estimation method and assumes that the
#' \code{distribution} object provides a valid quantile function and is compatible with the
#' \code{l_moments()} estimator defined externally.
#'
#' @seealso \code{\link[lmom]{samlmu}}, \code{\link[stats]{quantile}}
#' @export

s_bootstrap <- function(ams, distribution, method, n_sim = 100000, alpha = 0.05) {

	# Set return periods and their quantiles
    t <- c(2, 5, 10, 20, 50, 100)
    returns <- 1 - (1 / t)
    n <- length(ams)

    # Get the quantile function and parameter estimates
	qfunc <- distribution$quantile
    params <- l_moments(ams, distribution)
    estimates <- qfunc(returns, params)

	# Run L-moments sample bootstrap estimation
    if (method == "L-moments") {

		# Vectorized, parallel bootstrap function 
		bootstrap_list <- mclapply(1:n_sim, function(i) {
		    X <- runif(n)
		    SQ <- qfunc(X, params)
		    SQ_params <- l_moments(SQ, distribution)
		    as.numeric(qfunc(returns, SQ_params))
		})

		# Create matrix
		bootstrap_results <- do.call(rbind, bootstrap_list)
	
		# Compute and return confidence intervals
		probs <- c(alpha / 2, 1 - (alpha / 2))
		ci <- apply(bootstrap_results, 2, quantile, probs = probs)

		return (list(
			estimates = estimates,
			ci_lower = ci[1, ],
			ci_upper = ci[2, ],
			t = t
		))
    }

	stop("Unsupported method: ", method)

}
