library(lmom)

# Select a distribution using the l-distance method
#  - slm is a list of sample L-moments
#  - dlm is a list of list of distribution L-moments
l_kurtosis <- function(slm, dlm) {
	
	# Vectorized helper function for computing the y-distance between slm and dlm
	# - df is a dataframe of points on the (tau3, tau4) curve for a distribution
	# - moments is a list containing the sample L-moments or Log L-moments
	get_y_distance <- function(df, moments) {
		tau4 <- suppressWarnings(approx(df$t3, df$t4, moments$t3)$y)
		kappa <- suppressWarnings(approx(df$t3, df$k, moments$t3)$y)
		metric <- abs(moments$t4 - tau4)
		list(t3 = moments$t3, t4 = tau4, k = kappa, metric = metric)
	}
	
	# Generate a list containing the distances for each 3-parameter distribution
	distance <- list(
		GEV = get_y_distance(dlm$GEV, slm$lm),
		GLO = get_y_distance(dlm$GLO, slm$lm),
		PE3 = get_y_distance(dlm$PE3, slm$lm),
		LP3 = get_y_distance(dlm$PE3, slm$log_lm),
		GNO = get_y_distance(dlm$GNO, slm$lm),
		WEI = get_y_distance(dlm$WEI, slm$lm),
		GPA = get_y_distance(dlm$GPA, slm$lm)
	)

	# Get the distribution with the best fit
	values <- sapply(distance, function(x) x$metric)
	recommendation <- names(distance)[[ which.min(values) ]]
	
	# Return the results as a list
	mget(c("distance", "recommendation"))	

}
