frequency.analysis <- function(data, years, options, signature, start = NULL, end = NULL) {

	# Set start and end years if not defined
	if (is.null(start)) start <- min(years)
	if (is.null(end)) end <- max(years)

	# Subset data and years based on start and end
	idx <- which(years >= start & years < end)
	data <- data[idx]
	years <- years[idx]

	# Compute the decomposed dataset
	decomposed <- ams.decomposition(data, years, signature)

	# Define list for storing the results
	results <- list(start = start, end = end)

	# Run distribution selection
	results$selection <- switch(
		options$distribution_selection,
		"L-distance" = ld.selection(decomposed),
		"L-kurtosis" = lk.selection(decomposed),
		"Z-statistiC" = z.selection(decomposed, options$z_samples),
		"Preset" = list(method = "preset", recommendation = options$distribution_name)
	)

	# Get the probability model 
	model <- paste0(results$selection$recommendation, signature)

	# Run parameter estimation
	if (is.null(signature)) {
		estimation_method <- options$s_estimation
	} else {
		estimation_method <- options$ns_estimation
	}

	results$estimation <- switch(
		estimation_method,
		"L-moments" = list(params = pelxxx(model, data)),
		"MLE" = mle.estimation(data, years, model),
		"GMLE" = mle.estimation(data, years, model, options$gev_prior)
	)

	# Run uncertainty quantification
	if (is.null(signature)) {
		uncertainty_method <- options$s_uncertainty
	} else {
		uncertainty_method <- options$ns_uncertainty
	}

	results$uncertainty <- switch(
		uncertainty_method,
		"S-bootstrap" = sb.uncertainty(data, years, model, estimation_method),
		"RFPL" = rfpl.uncertainty(data, years, model),
		"RFGPL" = rfpl.uncertainty(data, years, model, options$gev_prior)
	)

	# Run model assessment
	results$assessment <- model.assessment(
		data,
		years,
		model,
		results$estimation$params,
		results$uncertainty
	)

	results

}
