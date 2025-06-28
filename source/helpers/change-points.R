# Change point detection function
change.points <- function(data, years, options, start = NULL, end = NULL) {

	# Set start and end years if not defined
	if (is.null(start)) start <- min(years)
	if (is.null(end)) end <- max(years) + 1

	# Subset data and years based on start and end
	idx <- which(years >= start & years < end)
	data <- data[idx]
	years <- years[idx]

	# Run the Pettitt and MKS tests
	pettitt_results <- pettitt.test(data, years, options$significance_level)
	mks_results <- mks.test(data, years, options$significance_level)

	# Return the results as a list
	list(start = start, end = end, pettitt = pettitt_results, mks = mks_results)

}


