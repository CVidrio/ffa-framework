library(glue)

# This function validates the opt$name command line argument
# - opt_name is the string passed to the --name argument
# - mode is either "tests" (for tests.R)  or "stats" (for stats.R)
#
# validate_name throws an error if the name is invalid.

validate_name <- function(mode, opt_name) {

	# If mode is invalid, return immediately
	if (mode != "stats" & mode != "tests") {
		stop("Argument 'mode' to validate_name must be 'tests' or 'stats'.")
	}
	
	# List of valid statistical names 
	stat_names <- c(
		"bbmk",
		"kpss",
		"mk",
		"mks",
		"mwmk",
		"pettitt",
		"pp",
		"spearman",
		"white",
		"sens-mean",
		"sens-variance"
	)

	if (mode == "stats" & !(opt_name %in% stat_names)) {
		stat_names_text <- paste("\n - ", stat_names, collapse = "")
		stop(glue("Invalid argument --name. Valid options: {stat_names_text}")) 
	}

	# List of valid test names 
	test_names <- c(
		"bbmk",
		"mk",
		"mks",
		"mwmk",
		"pettitt",
		"sens-mean",
		"sens-variance",
		"spearman", 
		"validate-config",
		"validate-name",
		"validate-split",
		"white",
		"sample-lm",
		"l-distance",
		"l-kurtosis",
		"z-statistic",
		"l-moments",
		"s-bootstrap",
		"model-assessment"
	)

	if (mode == "tests" & !(opt_name %in% test_names)) {
		test_names_text <- paste("\n - ", test_names, collapse = "")
		stop(glue("Invalid argument --name. Valid options: {test_names_text}")) 
	}
}

