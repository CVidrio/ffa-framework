library(lmom)

source("ffa/estimation/l-moments.R")

s_bootstrap <- function(ams, params, distribution, method, n_sim = 10000, alpha = 0.05, t = c(2, 5, 10, 20, 50, 100)) {

	# Convert the return periods to quantiles (50%, 80%, 90%, etc.)
    returns = 1 - (1/t);

	# Define a list of quantile functions
	quantiles <- list(
		GEV = quagev
	)

	# Run the sample bootstrap for the L-moments method
    if (method == "L-moments") {
		
		estimates <- quantiles[[ distribution ]](returns, params)

		bootstrap_results <- matrix(vector("numeric", n_sim * 6), nrow = n_sim, ncol = 6)

        for (i in 1:n_sim) {
            X = runif(length(ams));
            SQ = quantiles[[ distribution ]](X, params)
            SQ_params = l_moments(SQ)[[ distribution ]]
			bootstrap_results[i, ] <- quantiles[[ distribution ]](returns, SQ_params)
		}

	}

    ci <- apply(bootstrap_results, 2, quantile, probs = c((alpha / 2), 1 - (alpha / 2)))
	list(estimates = estimates, ci_lower = ci[1, ], ci_upper = ci[2, ])

}
