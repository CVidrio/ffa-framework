# Validate the config.yml file and pass errors/warnings to the user
validate_config <- function(config) {

	# Define expected data types for each item in config.yml
	expected_types <- list(
		data_folder = c("character", "NULL"),
		csv_files = c("character", "NULL"),
		report_folder = c("character", "NULL"),
		mode = "character",
		split_points = c("integer", "NULL"),
		alpha = "numeric",
		bbmk_repetitions = "integer",
		window_length = "integer", 
		window_step = "integer", 
		show_trend = "logical",
		generate_report = "logical",
		report_format = "character",
		selection_metric = "character",
		plotting_position = "character"
	)

	# Validate data types in the configuration file
	for (key in names(expected_types)) {

		# Check that the key exists in the config list
		if (!key %in% names(config)) {
			stop(sprintf("Missing configuration key: '%s'.", key))
		}

		# Compare the data types between the configuration file and expected_types
		actual_value <- config[[key]]
		expected_type <- expected_types[[key]]

		# Check for type mismatch
		if (!any(inherits(actual_value, expected_type))) {
			stop(sprintf(
				"Type mismatch for '%s': expected '%s', got '%s'.",
				key,
				expected_type,
				class(actual_value)
			))
		}
	}

	# Set data_folder and report_folder based on the working directory if not already set
	if (length(config$data_folder) == 0) {
		config$data_folder <- file.path(renv::project(), "..", "data")
	}

	if (length(config$report_folder) == 0) {
		config$report_folder <- file.path(renv::project(), "..", "reports")
	}

	# Check that data_folder exists on the disk
	if (!dir.exists(config$data_folder)) {
		stop(sprintf("data_folder '%s' does not exist.", config$data_folder))
	}

	# Check that all csv files exists in data_folder
	for (csv_file in config$csv_files) {
		csv_path <- glue("{config$data_folder}/{csv_file}")
		if (!file.exists(csv_path)) {
			stop(sprintf("csv_file '%s' does not exist.", csv_file))
		}
	}

	# Check that report_folder exists on the disk
	if (!dir.exists(config$report_folder)) {
		stop(sprintf("report_folder '%s' does not exist.", config$report_folder))
	}

	# Check that mode is one of "preset", "automatic", and "manual"
	if (!(config$mode %in% c("preset", "automatic", "manual"))) {
		stop("mode must be one of 'preset', 'automatic', or 'manual'.")
	}

	# Check that alpha is between 0.01 and 0.10
	if (config$alpha < 0.01 | config$alpha > 0.10) {
		stop("alpha must be between 0.01 and 0.10.")
	}

	# Check that each element report_format is valid
	valid_formats <- c("html_document", "md_document", "pdf_document")

	for (format in config$report_format) {
		if (!format %in% valid_formats) {
			stop(sprintf(
				"report_format '%s' is invalid.\nSupported formats: %s.",
				format, toString(valid_formats)
			))
		}
	}

	# Issue a warning if bbmk_repetitions is less than 10000
	if (config$bbmk_repetitions < 10000) {
		message("Warning: bbmk_repetitions should be at least 10000.")
	}

	# Issue a warning if window_step is greater than window_length
	if (config$window_step > config$window_length) {
		message("Warning: window_step should not be greater than window_length.")
	}

	# Check that the selection metric is valid
	valid_metrics <- c("L-distance", "L-kurtosis", "Z-statistic")

	if (!(config$selection_metric %in% valid_metrics)) {
		stop(sprintf(
			"selection_metric '%s' is invalid.\nSupported options: %s.",
			config$selection_metric, toString(valid_metrics)
		))
	}

	# Check that the estimation method is valid
	valid_estimation_methods <- c("L-moments", "MLE", "GMLE")

	if (!(config$estimation_method %in% valid_estimation_methods)) {
		stop(sprintf(
			"estimation_method '%s' is invalid.\nSupported options: %s.",
			config$estimation_method, toString(valid_estimation_methods)
		))
	}

	# Check that the uncertainty method is valid
	valid_uncertainty_methods <- c("S-bootstrap", "RFPL", "RFGPL")

	if (!(config$uncertainty_method %in% valid_uncertainty_methods)) {
		stop(sprintf(
			"uncertainty_method '%s' is invalid.\nSupported options: %s.",
			config$uncertainty_method, toString(valid_uncertainty_methods)
		))
	}

	# Check that the plotting position is valid
	valid_plotting_positions <- c("Weibull", "Blom", "Cunnane", "Gringorten", "Hazen")

	if (!(config$plotting_position %in% valid_plotting_positions)) {
		stop(sprintf(
			"plotting_position '%s' is invalid.\nSupported options: %s.",
			config$plotting_position, toString(valid_plotting_positions)
		))
	}

	config

}
