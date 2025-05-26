library(lmom)

# Get the (log) L-moments and (log) L-moment ratios for all candidate distributions
distribution_lm <- function() {

	# Helper function for getting a curve of L-moments (3-parameter distributions only)
	lm_curve <- function(lm_function, k_start, k_end) {

		# Generate a sequence of parameter sets to pass to a 3-parameter distribution 
		k_seq <- seq(k_start, k_end, 0.001)
		params <- lapply(k_seq, function(i) c(0, 1, i))

		# Get a vector of likelihood moment ratios for each parameterss set in params 
		lmr <- lapply(params, function(p) suppressWarnings(lm_function(p, nmom = 4)))
			
		# Return the t3 and t4 values as a dataframe
		data.frame(t3 = sapply(lmr, `[`, 3), t4 = sapply(lmr, `[`, 4), k = k_seq)

	}

	# Save the GEV curve as a variable so it can be used to compute GEV and WEI 
	gev <- lm_curve(lmrgev, -0.999, 9)

	# Return a list containing the distances for each distribution
	list(
		GEV = gev,
		GUM = data.frame(t3 = 0.1699, t4 = 0.1504),
		NOR = data.frame(t3 = 0, t4 = 0.1226),
		GLO = lm_curve(lmrglo, -0.999, 0.999),
		PE3 = lm_curve(lmrpe3, -10, 10),
		GNO = lm_curve(lmrgno, -4, 4),
		WEI = data.frame(t3 = -gev$t3, t4 = gev$t4),
		GPA = lm_curve(lmrgpa, -1, 45)
	)

}

