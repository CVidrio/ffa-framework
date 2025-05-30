library(lmom)

# Select a distribution using the l-distance method
#  - sample_moments is a list of sample L-moments
#  - distributions is a list of list of distribution details
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
