# Validate the config.yml file and pass errors/warnings to the user
validate_config <- function(config) {

	# Define expected data types for each item in config.yml
	expected_types <- list(
		data_folder = "character",
		csv_file = "character",
		report_folder = "character",
		alpha = "numeric",
		bbmk_repetitions = "integer",
		window_length = "integer", 
		window_step = "integer", 
		show_trend = "logical"
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
		if (!inherits(actual_value, expected_type)) {
			stop(sprintf(
				"Type mismatch for '%s': expected '%s', got '%s'.",
				key,
				expected_type,
				class(actual_value)
			))
		}
	}

	# Check that data_folder exists on the disk
	if (!dir.exists(config$data_folder)) {
		stop(sprintf("data_folder '%s' does not exist.", config$data_folder))
	}

	# Check that csv_file exists in data_folder
 	csv_path <- glue("{config$data_folder}/{config$csv_file}")
	if (!file.exists(csv_path)) {
		stop(sprintf("csv_file '%s' does not exist.", config$csv_file))
	}

	# Check that report_folder exists on the disk
	if (!dir.exists(config$report_folder)) {
		stop(sprintf("report_folder '%s' does not exist.", config$report_folder))
	}

	# Check that alpha is between 0.01 and 0.10
	if (config$alpha < 0.01 | config$alpha > 0.10) {
		stop(sprintf("alpha must be between 0.01 and 0.10."))
	}

	# Issue a warning if bbmk_repetitions is less than 10000
	if (config$bbmk_repetitions < 10000) {
		message("Warning: bbmk_repetitions should be at least 10000.")
	}

	# Issue a warning if window_step is greater than window_length
	if (config$window_step > config$window_length) {
		message("Warning: window_step should not be greater than window_length.")
	}

}
