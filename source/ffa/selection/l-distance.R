library(lmom)

# Select a distribution using the l-distance method
#  - sample_moments_list is a list of sample L-moments
#  - distributions is a list of lists with distribution information
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
