library(lmom)
library(parallel)

source("ffa/estimation/l-moments.R")

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
