# Trend detection function
trend.detection <- function(data, years, options, start = NULL, end = NULL) {

	# Set start and end years if not defined
	if (is.null(start)) start <- min(years)
	if (is.null(end)) end <- max(years)

	# Subset data and years based on start and end
	idx <- which(years >= start & years < end)
	data <- data[idx]
	years <- years[idx]

	# Define list for storing the results
	results <- list(start = start, end = end)

	# MK (1): go to Spearman (2) if there is a trend, White (8) if not.
	trend01 <- function() {
		results$mk <<- mk.test(data, options$significance_level)
		if (results$mk$reject) 2 else 8
	} 

	# Spearman (2): go to BB-MK (3) if there is serial correlation, Sen's means (6) if not.
	trend02 <- function() {
		results$spearman <<- spearman.test(data, options$significance_level)
		if (results$spearman$reject) 3 else 6
	} 

	# BB-MK (3): go to PP (4) if there is a trend, White (8) if not.
	trend03 <- function() {
		results$bbmk <<- bbmk.test(data, options$significance_level, options$bbmk_samples)
		if (results$bbmk$reject) 4 else 8
	} 

	# PP (4): go to KPSS (5) regardless of the result
	trend04 <- function() {
		results$pp <<- pp.test(data, options$significance_level)
		return (5)
	}

	# KPSS (5): go to Sen's (6) regardless of the result
	trend05 <- function() {
		results$kpss <<- kpss.test(data, options$significance_level)
		return (6)
	}

	# Sen's means (6): go to Runs means (7) regardless of the result
	trend06 <- function() {
		results$sens_mean <<- sens.trend(data, years)
		return (7)
	}

	# Runs means (7): go to White (8) regardless of the result
	trend07 <- function() {
		residuals <- results$sens_mean$residuals 
		results$runs_mean <<- runs.test(residuals, options$significance_level)
		return (8)
	}

	# White (8): go to MW-MK (9) regardless of the result
	trend08 <- function() {
		results$white <<- white.test(data, years, options$significance_level)
		return (9)
	}

	# MW-MK (9): go to Sen's variance (10) if there is non-stationarity, end (NULL) if not.
	trend09 <- function() {
		mw <- mw.variance(data, years)
		results$mwmk <<- mk.test(mw$std, options$significance_level)
		if (results$white$reject || results$mwmk$reject) 10 else NULL
	}

	# Sen's variance (10): go to Runs variance (11) regardless of the result
	trend10 <- function() {
		mw <- mw.variance(data, years)
		results$sens_variance <<- sens.trend(mw$std, mw$years)
		return (11)	
	}

	# Runs variance (11): go to end (NULL) regardless of the results
	trend11 <- function() {
		residuals <- results$sens_variance$residuals
		results$runs_variance <<- runs.test(residuals, options$significance_level)
		return (NULL)	
	}

	# Iterate through the flowchart
	location <- 1
	while (!is.null(location)) {
		fname <- sprintf("trend%02d", location)
		location <- get(fname)()
	} 

	results

}
