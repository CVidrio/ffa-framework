library(lmom)
library(parallel)

# Load the Kappa parameter fitting algorithm
source("ffa/selection/get-kappa-params.R")

# Select a distribution using the l-distance method
#  - sample_moments is a list of sample L-moments
#  - distributions is a list of list of distribution details
#  - ams is a vector of streamflow data without NaN values
#  - n_sim is the number of bootstrap simulations
z_statistic <- function(sample_moments, distributions, ams, n_sim = 100000) {

	# Unpack the sample L-moments
	lm <- sample_moments$lm
	log_lm <- sample_moments$log_lm
	
	# Fit Kappa distribution to AMS using the L-moments
	params <- get_kappa_params(lm$t3, lm$t4)
	log_params <- get_kappa_params(log_lm$t3, log_lm$t4)

	# Compute bootstrapped L-moments using ITS on the fitted Kappa distribution
	bootstrap_list <- mclapply(1:n_sim, function(i) {
		p <- runif(length(ams))	
		t4 <- get_sample_lm(quakap(p, params))$lm$t4
		log_t4 <- get_sample_lm(quakap(p, log_params))$lm$t4
		c(t4, log_t4)
	})

	sim_t4 <- sapply(bootstrap_list, function(x) x[1])
	sim_log_t4 <- sapply(bootstrap_list, function(x) x[2])

	# Compute bias of tau4 estimates
	b4 <- sum(sim_t4 - lm$t4) / n_sim
	log_b4 <- sum(sim_log_t4 - log_lm$t4) / n_sim

	# Compute standard deviation of tau4 estimates
	s4 <- (sum((sim_t4 - lm$t4)^2 - b4^2) / (n_sim - 1))^(1/2)
	log_s4 <- (sum((sim_log_t4 - log_lm$t4)^2 - log_b4^2) / (n_sim - 1))^(1/2)

	# Helper function to calculate z-score for a distribution
	get_z_distance <- function(dlm, slm, bias, std) {
		tau4 <- suppressWarnings(approx(dlm$t3, dlm$t4, slm$t3)$y)
		kappa <- suppressWarnings(approx(dlm$t3, dlm$k, slm$t3)$y)
		z <- (tau4 - slm$t4 + bias) / std
		list(t3 = slm$t3, t4 = tau4, k = kappa, metric = z)
	}

	# Run the selection on a subset of the distributions
	distribution_list <- c("GEV", "GLO", "PE3", "LP3", "GNO", "WEI", "GPA")
	valid_distributions <- distributions[distribution_list]

	# Generate a list containing the distances for each 3-parameter distribution
	distance <- lapply(valid_distributions, function(distribution) {
		dlm  <- distribution$moments
		slm  <- if (distribution$log) { log_lm } else { lm }
		bias <- if (distribution$log) { log_b4 } else { b4 }
		std  <- if (distribution$log) { log_s4 } else { s4 }
		get_z_distance(dlm, slm, bias, std)
	})

	# Get the distribution with the best fit
	metrics <- sapply(distance, function(d) d$metric)
	recommendation <- names(metrics)[ which.min(metrics) ]

	# Return the results as a list
	bootstrap <- mget(c("b4", "log_b4", "s4", "log_s4"))
	mget(c("params", "log_params", "bootstrap", "distance", "recommendation"))

}
