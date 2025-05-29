library(lmom)
library(parallel)

source("ffa/estimation/l-moments.R")

s_bootstrap <- function(ams, distribution, method, n_sim = 100000, alpha = 0.05) {

	# Set return periods and their quantiles
    t <- c(2, 5, 10, 20, 50, 100)
    returns <- 1 - (1 / t)
    n <- length(ams)

    # Define quantile functions
    quantiles <- list(
		GEV = quagev,
		GUM = quagum,
		NOR = quanor,
		LNO = qualn3,
		GLO = quaglo,
		PE3 = quape3,
		LP3 = function(x, params) exp(quape3(x, params)),
		GNO = quagno,
		WEI = quawei,
		GPA = quagpa
    )

    # Get the quantile function and parameter estimates
    qfunc <- quantiles[[distribution]]
    params <- l_moments(ams, distribution)
    estimates <- qfunc(returns, params)

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
