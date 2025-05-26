library(lmom)

# Select a distribution using the l-distance method
#  - slm is a list of sample L-moments
#  - dlm is a list of list of distribution L-moments
l_distance <- function(slm, dlm) {

	# Vectorized helper function for computing minimum distance between slm and dlm
	# - df is a dataframe of points on the (tau3, tau4) curve for a distribution
	# - moments is a list containing the sample L-moments or Log L-moments
	get_minimum_distance <- function(df, moments) { 
		df$metric <- sqrt((df$t3 - moments$t3)^2 + (df$t4 - moments$t4)^2)
		as.list(df[which.min(df$metric), ])
	}
	
	# Generate a list containing the distances for each distribution
	distance <- list(
		GEV = get_minimum_distance(dlm$GEV, slm$lm),
		GUM = get_minimum_distance(dlm$GUM, slm$lm),
		NOR = get_minimum_distance(dlm$NOR, slm$lm),
		LNO = get_minimum_distance(dlm$NOR, slm$log_lm),
		GLO = get_minimum_distance(dlm$GLO, slm$lm),
		PE3 = get_minimum_distance(dlm$PE3, slm$lm),
		LP3 = get_minimum_distance(dlm$PE3, slm$log_lm),
		GNO = get_minimum_distance(dlm$GNO, slm$lm),
		WEI = get_minimum_distance(dlm$WEI, slm$lm),
		GPA = get_minimum_distance(dlm$GPA, slm$lm)
	)

	# Get the distribution with the best fit
	values <- sapply(distance, function(x) x$metric)
	recommendation <- names(distance)[[ which.min(values) ]]

	# Return the results as a list
	mget(c("distance", "recommendation"))	

}
