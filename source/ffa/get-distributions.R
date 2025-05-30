library(lmom)

# Get the distribution information for all candidate distributions
#  - quantile: The quantile function for the distribution
#  - estimate: The parameter estimation function for the distribution
#  - moments: A dataframe of L-moments (see lm_curve function below)
#  - n_params: The number of parameters the distribution has
#  - log: Boolean, whether the distribution uses log(data) or not
get_distributions <- function() {

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
	gev_lm <- lm_curve(lmrgev, -0.999, 9)

	# Generate a list containing information about each distribution
	GEV = list(
		quantile = quagev,
		estimate = function(x) unname(pelgev(samlmu(x))),
		moments = data.frame(t3 = gev_lm$t3, t4 = gev_lm$t4),
		n_params = 3,
		log = FALSE
	)
	
	GUM = list(
		quantile = quagum,
		estimate = function(x) unname(pelgum(samlmu(x))),
		moments = data.frame(t3 = 0.1699, t4 = 0.1504),
		n_params = 2,
		log = FALSE
	)

	NOR = list(
		quantile = quanor,
		estimate = function(x) unname(pelnor(samlmu(x))),
		moments = data.frame(t3 = 0, t4 = 0.1226),
		n_params = 2,
		log = FALSE
	)

	LNO = list(
		quantile = qualn3,
		estimate = function(x) unname(pelln3(samlmu(x), bound = 0)),
		moments = data.frame(t3 = 0, t4 = 0.1226),
		n_params = 2,
		log = TRUE
	)

	GLO = list(
		quantile = quaglo,
		estimate = function(x) unname(pelglo(samlmu(x))),
		moments = lm_curve(lmrglo, -0.999, 0.999),
		n_params = 3,
		log = FALSE
	)

	PE3 = list(
		quantile = quape3,
		estimate = function(x) unname(pelpe3(samlmu(x))),
		moments = lm_curve(lmrpe3, -10, 10),
		n_params = 3,
		log = FALSE
	)

	LP3 = list(
		quantile = function(x, params) exp(quape3(x, params)),
		estimate = function(x) unname(pelpe3(samlmu(log(x)))),
		moments = lm_curve(lmrpe3, -10, 10),
		n_params = 3,
		log = TRUE
	)

	GNO = list(
		quantile = quagno,
		estimate = function(x) unname(pelgno(samlmu(x))),
		moments = lm_curve(lmrgno, -4, 4),
		n_params = 3,
		log = FALSE
	)

	WEI = list(
		quantile = quawei,
		estimate = function(x) unname(pelwei(samlmu(x), bound = 0)),
		moments = data.frame(t3 = -gev_lm$t3, t4 = gev_lm$t4),
		n_params = 3,
		log = FALSE
	)

	GPA = list(
		quantile = quagpa,
		estimate = function(x) unname(pelgpa(samlmu(x))),
		moments = lm_curve(lmrgpa, -1, 45),
		n_params = 3,
		log = FALSE
	)

	mget(c("GEV", "GUM", "NOR", "LNO", "GLO", "PE3", "LP3", "GNO", "WEI", "GPA"))
}

