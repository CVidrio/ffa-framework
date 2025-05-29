library(lmom)
library(parallel)

# Select a distribution using the l-distance method
#  - slm is a list of sample L-moments
#  - dlm is a list of list of distribution L-moments
#  - ams is a vector of streamflow data without NaN values
#  - n_sim is the number of bootstrap simulations
z_statistic <- function(slm, dlm, ams, n_sim = 100000) {
	
	# Fit Kappa distribution to AMS using the L-moments
	params <- unname(pelkap(samlmu(ams)))

	# Compute bootstrapped L-moments using ITS on the fitted Kappa distribution
	bootstrap_list <- mclapply(1:n_sim, function(i) {
		p <- runif(length(ams))	
		x <- quakap(p, params)
		moments <- sample_lm(x)
		c(moments$lm$t4, moments$log_lm$t4)
	})

	sim_t4 <- sapply(bootstrap_list, function(x) x[1])
	sim_log_t4 <- sapply(bootstrap_list, function(x) x[2])

	# Compute bias of tau4 estimates
	b4 <- sum(sim_t4 - slm$lm$t4) / n_sim
	log_b4 <- sum(sim_log_t4 - slm$log_lm$t4) / n_sim

	# Compute standard deviation of tau4 estimates
	s4 <- (sum((sim_t4 - slm$lm$t4)^2 - b4^2) / (n_sim - 1))^(1/2)
	log_s4 <- (sum((sim_log_t4 - slm$log_lm$t4)^2 - log_b4^2) / (n_sim - 1))^(1/2)

	# Helper function to calculate z-score for a distribution
	get_z_distance <- function(df, moments, bias, std) {
		tau4 <- suppressWarnings(approx(df$t3, df$t4, moments$t3)$y)
		kappa <- suppressWarnings(approx(df$t3, df$k, moments$t3)$y)
		z <- (tau4 - moments$t4 + bias) / std
		list(t3 = moments$t3, t4 = tau4, k = kappa, metric = z)
	}

 	# Generate a list containing the distances for each distribution
	distance <- list(
		GEV = get_z_distance(dlm$GEV, slm$lm, b4, s4),
		GLO = get_z_distance(dlm$GLO, slm$lm, b4, s4),
		PE3 = get_z_distance(dlm$PE3, slm$lm, b4, s4),
		LP3 = get_z_distance(dlm$PE3, slm$log_lm, log_b4, log_s4),
		GNO = get_z_distance(dlm$GNO, slm$lm, b4, s4),
		WEI = get_z_distance(dlm$WEI, slm$lm, b4, s4),
		GPA = get_z_distance(dlm$GPA, slm$lm, b4, s4)
	)

	# Get the distribution with the best fit
	metrics <- sapply(distance, function(d) d$metric)
	recommendation <- names(metrics)[which.min(metrics)]

	# Return the results as a list
	bootstrap <- mget(c("b4", "log_b4", "s4", "log_s4"))
	mget(c("params", "bootstrap", "distance", "recommendation"))

}
