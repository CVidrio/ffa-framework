library(lmom)

# Get the (log) L-moments and (log) L-moment ratios
#  - ams is a vector of annual maximum streamflow data without NaN values
sample_l_moments <- function(ams) {

	# Compute the L-moments and Log L-moments
	lm <- as.list(suppressWarnings(samlmu(ams, ratios = FALSE)))
	log_lm <- as.list(suppressWarnings(samlmu(log(ams), ratios = FALSE)))

	# Remove underscores from the L-moment names
	names(lm) <- c("l1", "l2", "l3", "l4")
	names(log_lm) <- c("l1", "l2", "l3", "l4")
	
	# Compute the L-moment ratios
	lm$t2 <- lm$l2 / lm$l1
	lm$t3 <- lm$l3 / lm$l2
	lm$t4 <- lm$l4 / lm$l2

	# Compute the log L-moment ratios
	log_lm$t2 <- log_lm$l2 / log_lm$l1
	log_lm$t3 <- log_lm$l3 / log_lm$l2
	log_lm$t4 <- log_lm$l4 / log_lm$l2

	# Return the L-moments and L-moment ratios as a list
	mget(c("lm", "log_lm"))

}
