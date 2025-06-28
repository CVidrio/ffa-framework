# Function for validating a configuration file
validate.config <- function(file.path) {

    # Load dependencies and check that the file exists
    if (!requireNamespace("yaml", quietly = TRUE)) stop("package 'yaml' is required")
    if (!file.exists(file.path)) stop(glue("Configuration file does not exist: {file.path}"))

	# Load the configuration file 
    config <- yaml::read_yaml(file.path)
    keys <- names(config)

	# Specify the types and lengths for each option
	specification <- list(
        data_source = list(type = "character", size = 1),
        csv_files = list(type = c("character", "NULL")),
        station_ids = list(type = c("character", "NULL")),
        run_eda = list(type = "logical", size = 1),
        split_selection = list(type = "character", size = 1),
        split_points = list(type = c("integer", "NULL")),
        significance_level = list(type = "numeric", size = 1),
        bbmk_samples = list(type = "integer", size = 1),
        run_ffa = list(type = "logical", size = 1),
        ns_selection = list(type = "character", size = 1),
        ns_signature = list(type = c("character", "NULL"), size = c(0, 1)),
        z_samples = list(type = "integer", size = 1),
        distribution_selection = list(type = "character", size = 1),
        distribution_name = list(type = c("character", "NULL"), size = c(0, 1)),
        gev_prior = list(type = "numeric", size = 2),
        s_estimation = list(type = "character", size = 1),
        ns_estimation = list(type = "character", size = 1),
        return_periods = list(type = "integer"),
        sb_samples = list(type = "integer", size = 1),
        rfpl_tolerance = list(type = "numeric", size = 1),
        s_uncertainty = list(type = "character", size = 1),
        ns_uncertainty = list(type = "character", size = 1),
        pp_formula = list(type = "character", size = 1),
        show_trend = list(type = "logical", size = 1),
        anchor_year = list(type = c("integer", "NULL"), size = c(0, 1)),
        generate_report = list(type = "logical", size = 1),
        report_formats = list(type = "character")
    )

	# Values, ranges, and logical constraints
	constraints <- list(
		data_source = c("Local", "GeoMet"),
		split_selection = c("Automatic", "Manual", "Preset"),
		significance_level = c(0.01, 0.1),
		ns_selection = c("Automatic", "Manual", "Preset"),
		ns_signature = c("10", "11", NULL),
		distribution_selection = c("L-distance", "L-kurtosis", "Z-statistic", "Preset"),
		distribution_name = c("GUM", "NOR", "LNO", "GEV", "GLO", "GNO", "PE3", "LP3", "WEI"),
		gev_prior = c(0, Inf),
		s_estimation = c("L-moments", "MLE", "GMLE"),
		ns_estimation = c("MLE", "GMLE"),
		return_periods = c(2, Inf),
		s_uncertainty = c("S-bootstrap", "RFPL", "RFGPL"),
		ns_uncertainty = c("S-bootstrap", "RFPL", "RFGPL"),
		pp_formula = c("Weibull", "Blom", "Cunnane", "Gringorten", "Hazen"),
		report_formats = c("markdown", "pdf", "html", "json")
	)

    # Check for unknown fields
    unknown_keys <- setdiff(keys, names(specification))
    if (length(unknown_keys) > 0) {
		unknown_text <- paste(sQuote(unknown_keys), collapse = ", ")
		stop(glue("Unknown options: {unknown_text}"))
	}

    # Check required fields
    missing_keys <- setdiff(names(specification), keys)
    if (length(missing_keys) > 0) {
		missing_text <- paste(sQuote(missing_keys), collapse = ", ")
		stop(glue("Missing options: {missing_text}"))
	}

    # Validate each option in config
    for (key in names(config)) {

        value <- config[[key]]
        rule <- specification[[key]]
		constraint <- constraints[[key]]

		# Validate types
        if (!any(vapply(rule$type, function(t) inherits(value, t), logical(1)))) {
			observed <- class(value)
			expected <- paste(rule$type, collapse = '/')
        	stop(glue("Invalid type for '{key}': expected {expected} but got {observed}"))
        }

		# Validate lengths
        if (!is.null(rule$size) && all(length(value) != rule$size)) {
            stop(glue("'{key}' must have length {rule$size}, got {length(value)}"))
        }

		# Validate character constraints
		if (!is.null(constraint) && is.character(constraint)) {
			if (!all(value %in% constraint)) {
				valid_entries <- paste(sQuote(constraint), collapse = ", ")
				stop(glue("'{key}' must be one of {valid_entries}"))
			}
		}

		# Validate functional constraints
        if (!is.null(constraint) && is.numeric(constraint)) {
			if (!all(value >= constraint[1]) || !all(value <= constraint[2])) {
				stop(glue("'{key}' must be within ({constraint[1]}, {constraint[2]})"))
			}
        }

    }
    # Cross-field checks
	gmle_msg <- "requires distribution_selection: 'Preset' and distribution_name: 'GEV'"

    if (config$s_estimation == "GMLE") {
        if (config$distribution_selection != "Preset" || config$distribution_name != "GEV") {
            stop(glue("s_estimation: 'GMLE' {gmle_msg}"))
        }
    }

    if (config$ns_estimation == "GMLE") {
        if (config$distribution_selection != "Preset" || config$distribution_name != "GEV") {
            stop(glue("ns_estimation: 'GMLE' {gmle_mst}"))
        }
    }

    if (config$s_uncertainty == "RFPL" && config$s_estimation != "MLE") {
        stop("s_uncertainty: 'RFPL' requires s_estimation: 'MLE'")
    }

    if (config$ns_uncertainty == "RFGPL" && config$ns_estimation != "GMLE") {
        stop("ns_uncertainty: 'RFGPL' requires ns_estimation: 'GMLE'")
    }

		
    if (config$data_source == "Local") {
		for (file in config$csv_files) {
			if (!file.exists(file.path(renv::project(), "data", file))) {
				stop(glue("csv_file '{file}' does not exist"))
			}
		}
    }

    config

} 

