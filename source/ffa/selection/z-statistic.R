library(lmom)

# Load the Kappa distribution helper function
source("ffa/selection/kappa-params.R")

# Select a distribution using the l-distance method
#  - slm is a list of sample L-moments
#  - dlm is a list of list of distribution L-moments
z_statistic <- function(slm, dlm, ams, n_sim = 100000) {
	
	# Unpack the sample L-moments
	lm <- slm$lm
	log_lm <- slm$log_lm

	# Fit the Kappa distribution using the L-moments
	params <- kappa_params(1, lm$t2, lm$t3, lm$t4)
	log_params <- kappa_params(1, log_lm$t2, log_lm$t3, log_lm$t4)

	# Initialize lists of bootstrapped L-moments
	t4_sim <- vector("numeric", n_sim)
	log_t4_sim <- vector("numeric", n_sim)

	# Compute bootstrapped L-moments
	for (i in 1:n_sim) {

		# Use ITS to get a random sample from the fitted Kappa distribution
		p <- runif(length(ams))	
		x <- quakap(p, as.numeric(params))
		log_x <- quakap(p, as.numeric(log_params))

		# Compute the L-moments and add them to bootstrap and log_bootstrap
		t4_sim[i] <- sample_lm(x)$lm$t4
		log_t4_sim[i] <- sample_lm(log_x)$lm$t4

	}

	# Compute summary statistics for the bootstrap
	b4 <- sum(t4_sim - lm$t4) / n_sim
	log_b4 <- sum(log_t4_sim - log_lm$t4) / n_sim
	s4 <- (sum((t4_sim - lm$t4)^2 - b4^2) / (n_sim - 1))^(1/2)
	log_s4 <- (sum((log_t4_sim - log_lm$t4)^2 - log_b4^2) / (n_sim - 1))^(1/2)

	# Get the value of the distribution tau4 statistic when tau3 = t3, then compute z.
	# - df is a dataframe of points on the (tau3, tau4) curve for a distribution
	# - moments is a list containing the sample L-moments or Log L-moments
	# - b4_statistic is either b4 or log_b4  (and similarly for s4_statistic)
	get_z_distance <- function(df, moments, b4_statistic, s4_statistic) {
		tau4 <- suppressWarnings(approx(df$t3, df$t4, moments$t3)$y)
		kappa <- suppressWarnings(approx(df$t3, df$k, moments$t3)$y)
		z <- (tau4 - moments$t4 + b4_statistic) / s4_statistic
		list(t3 = moments$t3, t4 = tau4, k = kappa, metric = z)

	}

 	# Generate a list containing the distances for each distribution
	distance <- list(
		GEV = get_z_distance(dlm$GEV, lm, b4, s4),
		GLO = get_z_distance(dlm$GLO, lm, b4, s4),
		PE3 = get_z_distance(dlm$PE3, lm, b4, s4),
		LP3 = get_z_distance(dlm$PE3, log_lm, log_b4, log_s4),
		GNO = get_z_distance(dlm$GNO, lm, b4, s4),
		WEI = get_z_distance(dlm$WEI, lm, b4, s4),
		GPA = get_z_distance(dlm$GPA, lm, b4, s4)
	)

	# Get the distribution with the best fit
	vec <- unlist(distance)
	recommendation <- names(vec)[which.min(vec)]

	# Return the results as a list
	bootstrap <- mget(c("b4", "log_b4", "s4", "log_s4"))
	mget(c("params", "log_params", "bootstrap", "distance", "recommendation"))
}
