library(lmom)

# Select a distribution using the l-distance method
#  - ams is a vector of streamflow data without NA values
l_distance <- function(ams) {
	
	# Compute the L-moments and Log L-moments
	moments <- unname(samlmu(ams))
	log_moments <- unname(samlmu(log(ams)))

	# Get the L-moment ratios (t3, t4) and (t3_log, t4_log) 
	t3 <- moments[3]
	t4 <- moments[4]
	t3_log <- log_moments[3]
	t4_log <- log_moments[4]

	# Vectorized helper function for computing euclidian distances
	distance <- function(x1, y1, x2, y2) sqrt((x1 - x2)^2 + (y1 - y2)^2)

	# Another helper function for generating and comparing a vector of L-moments
	#  - f_lmr is the likelihood moment ratio function from the 'lmom' library
	#  - k_start and k_end define bounds on the kappa (shape) distribution parameter 
	#  - t3_data and t4_data are likelihood moment ratios derived from the data 
	get_minimum_distance <- function(f_lmr, k_start, k_end, t3_data, t4_data) {

		# Generate a sequence of parameter sets to pass to a 3-parameter distribution 
		params <- lapply(seq(k_start, k_end, 0.001), function(i) c(0, 1, i))

		# Get a vector of likelihood moment ratios for each parameterss set in params 
		lmr <- lapply(params, function(p) suppressWarnings(f_lmr(p, nmom = 4)))
		t3_dist <- unname(sapply(lmr, `[`, 3))
		t4_dist <- unname(sapply(lmr, `[`, 4))
			
		# Return the minimum distance between distribution LMRs and sample LMR
		min(distance(t3_dist, t4_dist, t3_data, t4_data), na.rm = TRUE)

	}

	# Generate a list containing the distances for each distribution
	distance <- list(
		GEV = get_minimum_distance(lmrgev, -0.999, 9, t3, t4),
		GUM = distance(0.1699, 0.1504, t3, t4),
		NOR = distance(0, 0.1226, t3, t4),
		LNO = distance(0, 0.1226, t3_log, t4_log),
		GLO = get_minimum_distance(lmrglo, -0.999, 0.999, t3, t4),
		PE3 = get_minimum_distance(lmrpe3, -1, 10, t3, t4),
		LP3 = get_minimum_distance(lmrpe3, -1, 10, t3_log, t4_log),
		GNO = get_minimum_distance(lmrln3, 0.001, 10, t3, t4),
		WEI = get_minimum_distance(lmrwei, 0.001, 10, t3, t4),
		GPA = get_minimum_distance(lmrgpa, -1, 45, t3, t4)
	)
	
	# Return the results as a list
	mget(c("t3", "t3_log", "t4", "t4_log", "distance"))	

}
