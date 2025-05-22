# Import libraries
library(glue)
library(tibble)
library(tools)
library(rmarkdown)
library(knitr)
library(optparse)
library(yaml)

# Silence dplyr import
suppressPackageStartupMessages(library(dplyr))

# Source all statistical test and plotting functions
files <- list.files("eda/", pattern = "\\.R$", recursive = TRUE, full.names = TRUE)
for (f in files) source(f)

# Source helper functions
source("helpers/run-stats.R")
source("helpers/load-data.R")
source("helpers/validate-config.R")
source("helpers/validate-split.R")


# Create command line options
option_list <- list(
  make_option(c("-c","--config"), type = "character", help = "YAML confiugration file.")
)

# Parse given command line arguments
args <- commandArgs(trailingOnly = TRUE)
opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

# Check for config argument and set to default value of config.yml if it doesn't exist
config_path <- ifelse(is.null(opt$config), "config.yml", opt$config)

# Check that a file exists at config_path
if (!file.exists(config_path)) stop("Invalid configuration file path.")

# Load and validate the configuration file
config <- read_yaml(config_path)
config <- validate_config(config)
invisible(list2env(config, envir = environment()))


# Helper function for generating the next state in the flowchart from a list of splits. 
# NOTE: If splits is NULL, this function will generate a single next state at location.
# NOTE: If location is NULL, this function will return an empty dataframe for next_states.
get_next_states <- function(state, location = NULL, splits = NULL, msg = NULL) {

	# If there is a message, print it and then add it to results
	if (!is.null(msg)) {
		# message(glue("\n\n{msg}"))
		state$results <- list(message = msg)
	}

	# Wrap state$results in a list, mark current state as complete
	state$results <- list(state$results)
	state$complete <- TRUE 

	# If location is NULL, return with next_states = NULL 
	if (is.null(location)) return (list(state = state, next_states = NULL))

	# Generate a tibble of next states with size length(splits) + 1
	n <- length(splits)
	next_states <- tibble(
		location = rep(location, n + 1),
		start = c(state$start, splits),
		end = c(splits - 1, state$end),
		results = vector("list", n + 1),
		complete = rep(FALSE, n + 1)
	)

	# Return the current state and next_states in a list
	list(state = state, next_states = next_states)
}

# [1] Full Pettitt -> [2] Full MKS
eda01 <- function(data, state, steps, img_path) {
	state$results <- run_stats("pettitt", data, state$start, state$end, img_path, FALSE)
	get_next_states(state, 2)
}

# [2] Full MKS -> [3] Pettitt/MKS decision point
eda02 <- function(data, state, steps, img_path) {
	state$results <- run_stats("mks", data, state$start, state$end, img_path, FALSE)
	get_next_states(state, 3)
}

# [3] Pettitt/MKS decision point -> [4] Secondary Pettitt, [6] Secondary MKS, [8] MK
eda03 <- function(data, state, steps, img_path) {

	# Get the results of the Pettitt test and MKS test
	result_df <- filter(steps, start == state$start, end == state$end)
	pettitt_results <- filter(result_df, location == 1)[[1, "results"]][[1]]
	mks_results <- filter(result_df, location == 2)[[1, "results"]][[1]]

	 
	# If no change points were found, do nothing and go to [8] (MK test)
	if (!pettitt_results$reject && !mks_results$reject) {
		msg <-"No change points were found so the data will not be split."
		return (get_next_states(state, 8, msg = msg))
	} 

	# If running in automatic mode, split based on the smallest p-value
	if (mode == "automatic" & mks_results$p_value < pettitt_results$p_value) {
		msg <- "Splitting on change points from the MKS test."
		return (get_next_states(state, 4, mks_results$change_df$year, msg))
	} else if (mode == "automatic") {
		msg <- "Splitting on change points from the Pettitt test."
		return (get_next_states(state, 6, pettitt_results$change_year, msg))
	}

	# Prompt the user to accept the change points
	pettitt_option <- "  (2) Accept change points from Pettitt test."
	mks_option <- "  (3) Accept change points from MKS test."

	option_message <- c(
		"\nSelect an option:", 
		"  (1) Ignore change points.",
		if (pettitt_results$reject) pettitt_option else NULL,
		if (mks_results$reject) mks_option else NULL
	)

	message(paste(option_message, collapase = "\n"))
	message("NOTE: Remember to consider information about the site when splitting.\n")

	# Infinitely loop the option entry in case the user makes a mistake
	while (TRUE) {
		cat("Enter a number: ")
		option <- readLines(file("stdin"), 1)

		if (option == 1) {
			msg <- "Change points ignored."
			return (get_next_states(state, 8, msg = msg))
		} else if (option == 2 & pettitt_results$reject) {
			msg <- "Splitting on change points from the Pettitt test."
			return (get_next_states(state, 6, pettitt_results$change_year, msg))
		} else if (option == 3 & mks_results$reject) {
			msg <- "Splitting on change points from the MKS test."
			return (get_next_states(state, 4, mks_results$change_df$year, msg))
		}

		message("Invalid option. Please try again.")
	}
}

# [4] Secondary Pettitt -> [5] Secondary Pettitt decision point
eda04 <- function(data, state, steps, img_path) {
	state$results <- run_stats("pettitt", data, state$start, state$end, img_path, FALSE)
	get_next_states(state, 5) 
}

# [5] Secondary Pettitt decision point -> [8] MK
eda05 <- function(data, state, steps, img_path) {

	# Get the results of the secondary Pettitt test
	result_df <- filter(steps, start == state$start, end == state$end)
	pettitt_results <- filter(result_df, location == 4)[[1, "results"]][[1]]
	 
	# If no change points were found, do nothing and go to [8] (MK test)
	if (!pettitt_results$reject) {
		msg <- "No change points were found so the data will not be split."
		return (get_next_states(state, 8, msg = msg))
	}

	# If running in automatic mode, split based on the results of this test
	if (mode == "automatic") {
		msg <- "Splitting on change points identified by the Pettitt test."
		return (get_next_states(state, 8, pettitt_results$change_year, msg))
	}

	# Prompt the user to accept the change points
	option_message <- c(
		"\nSelect an option:", 
		"  (1) Ignore change points.",
		"  (2) Accept change points from Pettitt test."
	)

	message(paste(option_message, collapase = "\n"))
	message("NOTE: Remember to consider information about the site when splitting.\n")

	# Infinitely loop the option entry in case the user makes a mistake
	while (TRUE) {
		cat("Enter a number: ")
		option <- readLines(file("stdin"), 1)

		if (option == 1) {
			msg <- "Change points ignored."
			return (get_next_states(state, 8))
		} else if (option == 2) {
			msg <- "Splitting on change points identified by the Pettitt test."
			return (get_next_states(state, 8, pettitt_results$change_year))
		} 

		message("Invalid option. Please try again.")
	}
}

# [6] Secondary MKS -> [7] Secondary MKS decision point
eda06 <- function(data, state, steps, img_path) {
	state$results <- run_stats("mks", data, state$start, state$end, img_path, FALSE)
	get_next_states(state, 7)
}

# [7] Secondary MKS decision point -> [8] MK
eda07 <- function(data, state, steps, img_path) {

	# Get the results of the secondary Pettitt test
	result_df <- filter(steps, start == state$start, end == state$end)
	mks_results <- filter(result_df, location == 6)[[1, "results"]][[1]]
	 	 
	# If no change points were found, do nothing and go to [8] (MK test)
	if (!mks_results$reject) {
		msg <- "No change points were found so the data will not be split."
		return (get_next_states(state, 8, msg = msg))
	}

	# If running in automatic mode, split based on the results of this test
	if (mode == "automatic") {
		msg <- "Splitting on change points identified by the MKS test."
		return (get_next_states(state, 8, mks_results$change_df$year, msg))
	}

	# Prompt the user to accept the change points
	option_message <- c(
		"\nSelect an option:", 
		"  (1) Ignore change points.",
		"  (2) Accept change points from MKS test."
	)

	message(paste(option_message, collapase = "\n"))
	message("NOTE: Remember to consider information about the site when splitting.\n")

	# Infinitely loop the option entry in case the user makes a mistake
	while (TRUE) {
		cat("Enter a number: ")
		option <- readLines(file("stdin"), 1)

		if (option == 1) {
			msg <- "Change points ignored."
			return (get_next_states(state, 8, msg = msg))
		} else if (option == 2) {
			msg <- "Splitting on change points identified by the MKS test."
			return (get_next_states(state, 8, mks_results$change_df$year, msg))
		} 

		message("Invalid option. Please try again.")
	}
}
 
# [8] MK -> [9] MK branching point
eda08 <- function(data, state, steps, img_path) {
	state$results <- run_stats("mk", data, state$start, state$end, img_path)
	get_next_states(state, 9)
}

# [9] MK branching point -> [10] Spearman, [18] White
eda09 <- function(data, state, steps, img_path) {

	# Get the results of the Mann-Kendall test
	result_df <- filter(steps, start == state$start, end == state$end)
	mk_results <- filter(result_df, location == 8)[[1, "results"]][[1]]
	
	# Handle the branching point
	if (mk_results$reject) {
		msg <- "Monotonic trend found. Testing for serial correlation."
		return (get_next_states(state, 10, msg = msg))
	} else {
		msg <- "No trend found. Testing the AMS variance for trends."
		return (get_next_states(state, 18, msg = msg))
	}
}

# [10] Spearman -> [11] Spearman branching point
eda10 <- function(data, state, steps, img_path) {
	state$results <- run_stats("spearman", data, state$start, state$end, img_path)
	get_next_states(state, 11)
}

# [11] Spearman branching point -> [12] BB-MK, [17] Sen's estimator (means)
eda11 <- function(data, state, steps, img_path) {

	# Get the results of the Spearman test
	result_df <- filter(steps, start == state$start, end == state$end)
	spearman_results <- filter(result_df, location == 10)[[1, "results"]][[1]]

	# Handle the branching point
	if (spearman_results$least_lag > 0) {
		msg <- "Serial correlation found. Confirming the monotonic trend."
		return (get_next_states(state, 12, msg = msg))
	} else {
		msg <- "No serial correlation found. Estimating the monotonic trend."
		return (get_next_states(state, 17, msg = msg))
	}
}

# [12] BB-MK -> [13] BB-MK branching point 
eda12 <- function(data, state, steps, img_path) {
	state$results <- run_stats("bbmk", data, state$start, state$end, img_path)
	get_next_states(state, 13)
}

# [13] BB-MK branching point -> [14] PP, [18] White
eda13 <- function(data, state, steps, img_path) {

	# Get the results of the BB-MK test
	result_df <- filter(steps, start == state$start, end == state$end)
	bbmk_results <- filter(result_df, location == 12)[[1, "results"]][[1]]

	# Handle the branching point
	if (bbmk_results$reject > 0) {
		msg <- "Significant trend identified. Identifying the trend type."
		return (get_next_states(state, 14, msg = msg))
	} else {
		msg <- "Trend was caused by serial correlation."
		return (get_next_states(state, 18, msg = msg))
	}
}

# [14] PP -> [15] KPSS
eda14 <- function(data, state, steps, img_path) {
	state$results <- run_stats("pp", data, state$start, state$end, img_path)
	get_next_states(state, 15)
}

# [15] KPSS -> [16] PP/KPSS branching point
eda15 <- function(data, state, steps, img_path) {
	state$results <- run_stats("kpss", data, state$start, state$end, img_path)
	get_next_states(state, 16)
}

# [16] PP/KPSS branching point -> [17] Sen's estimator (means)
eda16 <- function(data, state, steps, img_path) {

	# Get the results of the PP test and KPSS test
	result_df <- filter(steps, start == state$start, end == state$end)
	pp_results <- filter(result_df, location == 14)[[1, "results"]][[1]]
	kpss_results <- filter(result_df, location == 15)[[1, "results"]][[1]]

	# Handle the branching point
	msg <- if (!pp_results$reject && kpss_results$reject) {
		"The PP/KPSS tests have identified a stochastic trend (unit root)."
	} else if (pp_results$reject && !kpss_results$reject) {
		"The PP/KPSS tests have identified a deterministic trend (no unit root)."
	} else {
		"The PP/KPSS tests are inconclusive, indicating an unknown trend."
	}

	get_next_states(state, 17, msg = msg)
}

# [17] Sen's estimator (means) -> [18] White
eda17 <- function(data, state, steps, img_path) {
	state$results <- run_stats("sens-mean", data, state$start, state$end, img_path)
	get_next_states(state, 18)
}

# [18] White -> [19] MW-MK
eda18 <- function(data, state, steps, img_path) {
	state$results <- run_stats("white", data, state$start, state$end, img_path)
	get_next_states(state, 19)
}

# [19] MW-MK -> [20] White/MW-MK branching point
eda19 <- function(data, state, steps, img_path) {
	state$results <- run_stats("mwmk", data, state$start, state$end, img_path)
	get_next_states(state, 20)
}

# [20] White/MW-MK branching point -> [21] Sen's estimator (variance), [END]
eda20 <- function(data, state, steps, img_path) {

	# Get the results of the White test and MW-MK test
	result_df <- filter(steps, start == state$start, end == state$end)
	white_results <- filter(result_df, location == 18)[[1, "results"]][[1]]
	mwmk_results <- filter(result_df, location == 19)[[1, "results"]][[1]]

	# Handle the branching point
	if (white_results$reject | mwmk_results$reject) {
		msg <- "Time-dependence identified in the AMS variance."
		return (get_next_states(state, 21, msg = msg))
	} else {
		msg <- "No time-dependence identified in the AMS variance."
		return (get_next_states(state, msg = msg))
	}
}

# [21] Sen's estimator (variance) -> [END]
eda21 <- function(data, state, steps, img_path) {
	state$results <- run_stats("sens-variance", data, state$start, state$end, img_path)
	return (get_next_states(state))
}


# If csv_files is empty, get every file in data_folder 
if (length(csv_files) == 0) csv_files <- list.files(path = data_folder)

# Orchestrate EDA on each .csv file 
for (csv_file in csv_files) {

	# Create the reports folder if it doesn't already exist
	csv_name <- file_path_sans_ext(csv_file)
	report_path <- glue("{report_folder}/{csv_name}")
	if (!dir.exists(report_path)) dir.create(report_path)

	# Generate an /img directory in report_path if it doesn't already exist
	img_path <- glue("{report_path}/img")
	if (!dir.exists(img_path)) dir.create(img_path)

	# Load data from the given input file and remove leading/trailing NaNs
	data <- load(data_folder, csv_file, window_length, window_step)

	# Set the initial state
	state <- list(start = min(data$df$year), end = max(data$df$year))

	# In preset mode, split the data and begin at [8] MK test.
	if (mode == "preset") {
		splits <- validate_split(state$start, state$end, split_points)
		steps <- get_next_states(state, 8, splits)$next_states
	} else {
		steps <- get_next_states(state, 1)$next_states
	} 

	# Run until there are no incomplete steps 
	while (any(!steps$complete)) {

		# Get the index and row of the first incomplete step
		index <- which(!steps$complete)[1]
		state <- as.list(steps[index, ])

		# Call the flowchart step function 
		fname <- paste0("eda", sprintf("%02d", state$location))
		updated <- get(fname)(data, state, steps, img_path)

		# Update current step and then add new steps 
		steps[index, ] <- updated$state
		steps <- rbind(steps, updated$next_states)

		# Sort steps in lexigraphical order 
		steps <- arrange(steps, start, desc(end), location)

	}

	# Create a dataframe for storing the identified trends
	trends <- steps |>
		group_by(start, end) |>
		filter(any(location == 8)) |>
		summarise(
			mean = any(location == 17),
			variance = any(location == 21),
			recommendation = ifelse(mean | variance, "NS-FFA", "S-FFA"),
			.groups = "drop"
		)

	# Print the results of trend identification
	message("\nEDA Complete.")
	for (s in purrr::pmap(trends, list)) {
		message(glue("\n\nSplit {s$start}-{s$end}:"))
		message(glue(" - Trend in AMS mean: {s$mean}"))
		message(glue(" - Trend in AMS variance: {s$variance}"))
		message(glue(" - Recomendation: {s$recommendation}"))
	}

	# If report generation is disabled, go to next file
	if (!generate_report) {
		message("No report was generated.") 
		next
	}

	# Define arguments for the report
	report_args = list(steps = steps, trends = trends, output_dir = report_path)

	# Render the report using each item in report_format given
	for (format in report_format) {
		render(
			input = "eda/eda-report.Rmd",
			params = report_args,
			output_format = format,
			output_file = "eda-report",
			output_dir = report_path,
			quiet = TRUE
		)
	}

	# Print completion message
	message("\nReport(s) generated successfully.")
}

# Remove Rplots.pdf if it was accidentally created
if (file.exists("Rplots.pdf")) invisible(file.remove("Rplots.pdf"))
