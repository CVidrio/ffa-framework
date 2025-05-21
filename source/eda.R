# Import libraries
library(yaml)
library(optparse)
library(glue)
library(patchwork)
library(ggplot2)
library(tools)
library(rmarkdown)
library(knitr)

# Source all statistical test and plotting functions
files <- list.files("eda/", pattern = "\\.R$", recursive = TRUE, full.names = TRUE)
for (f in files) {
	source(f)
}

# Source helper functions
source("helpers/run-stats.R")
source("helpers/load-data.R")
source("helpers/validate-config.R")
source("helpers/validate-split.R")


### PARSING COMMANE LINE OPTIONS ###


# Create command line options
option_list <- list(
  make_option(c("-c","--config"), type="character", help="YAML confiugration file.")
)

# Parse given command line arguments
args <- commandArgs(trailingOnly = TRUE)
opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

# Check for config argument and set to default value of config.yml if it doesn't exist
config_path <- ifelse(is.null(opt$config), "config.yml", opt$config)

# Check that a file exists at config_path
if (!file.exists(config_path)) {
	print_help(opt_parser)
	stop("Invalid configuration file path.")
} 

# Load and validate the configuration file
config <- read_yaml(config_path)
validate_config(config)
invisible(list2env(config, envir = environment()))


### DIRECTORY SETUP ###


# Create a directory for storing reports for this csv_file
csv_name <- file_path_sans_ext(csv_file)
report_path <- glue("{report_folder}/{csv_name}")
if (!dir.exists(report_path)) dir.create(report_path)

# Load data from the given input file and remove leading/trailing NaNs
data <- load(data_folder, csv_file, window_length, window_step)
invisible(list2env(data, envir = environment()))

# Generate an /img directory in report_path if it doesn't already exist
img_path <- glue("{report_path}/img")
if (!dir.exists(img_path)) dir.create(img_path)


### DEFINE STEPS ###


# Helper function for generating the next state in the flowchart from a list of splits. 
# If splits is NULL, this function will generate a single next state at location.
get_next_states <- function(location, state, splits = NULL) {

	# Get a vector of start and end locations for the splits
	starts <- c(state$start, splits)
	ends <- c(splits - 1, state$end)

	# Generate the list of next states using a Map
	state_function <- function(s, e) list(location = location, start = s, end = e)
	next_states <- Map(state_function, starts, ends)

	# Return the current state and next_states in a list
	list(state = state, next_states = next_states)
}

# [1] Full Pettitt -> [2] Full MKS
eda01 <- function(state, history) {
	message("\nApplying the Pettitt test for abrupt change points...")
	state$results <- run_stats("pettitt", data, state$start, state$end, img_path)
	get_next_states(2, state)
}

# [2] Full MKS -> [3] Pettitt/MKS decision point
eda02 <- function(state, history) {
	message("\nApplying the MKS test for abrupt change points...")
	state$results <- run_stats("mks", data, state$start, state$end, img_path)
	get_next_states(3, state)
}

# [3] Pettitt/MKS decision point -> [4] Secondary Pettitt, [6] Secondary MKS, [8] MK
eda03 <- function(state, history) {

	# Get the results of the Pettitt test and MKS test
	pettitt_results <- history[[ length(history) - 1 ]]$results
	mks_results <- history[[ length(history) ]]$results
	 
	# If no change points were found, do nothing and go to [8] (MK test)
	if (!pettitt_results$reject && !mks_results$reject) {
		state$msg <-"No change points were found so the data will not be split."
		return (get_next_states(8, state))
	} 

	# If running in automatic mode, split based on the smallest p-value
	if (mode == "automatic" & mks_results$p_value < pettitt_results$p_value) {
		state$msg <- "Splitting on change points from the MKS test."
		return (get_next_states(4, state, mks_results$change_df$year))
	} else {
		state$msg <- "Splitting on change points from the Pettitt test."
		return (get_next_states(6, state, pettitt_results$change_year))
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
			state$msg <- "Change points ignored."
			return (get_next_states(8, state))
		} else if (option == 2 & pettitt_results$reject) {
			state$msg <- "Splitting on change points from the Pettitt test."
			return (get_next_states(6, state, pettitt_results$change_year))
		} else if (option == 3 & mks_results$reject) {
			state$msg <- "Splitting on change points from the MKS test."
			return (get_next_states(4, state, mks_results$change_df$year))
		} else {
			message("Invalid option. Please try again.")
		}
	}
}

# [4] Secondary Pettitt -> [5] Secondary Pettitt decision point
eda04 <- function(state, history) {
	message("\nApplying the Pettitt test for abrupt change points...")
	state$results <- run_stats("pettitt", data, state$start, state$end, img_path)
	get_next_states(5, state) 
}

# [5] Secondary Pettitt decision point -> [8] MK
eda05 <- function(state, history) {

	# Get the results of the secondary Pettitt test
	pettitt_results <- history[[ length(history) ]]$results
	 
	# If no change points were found, do nothing and go to [8] (MK test)
	if (!pettitt_results$reject) {
		state$msg <- "No change points were found so the data will not be split."
		return (get_next_states(8, state))
	}

	# If running in automatic mode, split based on the results of this test
	if (mode == "automatic") {
		state$msg <- "Splitting on change points identified by the Pettitt test."
		return (get_next_states(8, state, pettitt_results$change_year))
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
			state$msg <- "Change points ignored."
			return (get_next_states(8, state))
		} else if (option == 2) {
			state$msg <- "Splitting on change points identified by the Pettitt test."
			return (get_next_states(8, state, pettitt_results$change_year))
		} else {
			message("Invalid option. Please try again.")
		}
	}
}

# [6] Secondary MKS -> [7] Secondary MKS decision point
eda06 <- function(state, history) {
	message("\nApplying the MKS test for abrupt change points...")
	state$results <- run_stats("mks", data, state$start, state$end, img_path)
	get_next_states(7, state)
}

# [7] Secondary MKS decision point -> [8] MK
eda07 <- function(state, history) {

	# Get the results of the secondary Pettitt test
	mks_results <- history[[ length(history) ]]$results
	 	 
	# If no change points were found, do nothing and go to [8] (MK test)
	if (!mks_results$reject) {
		state$msg <- "No change points were found so the data will not be split."
		return (get_next_states(8, state))
	}

	# If running in automatic mode, split based on the results of this test
	if (mode == "automatic") {
		state$msg <- "Splitting on change points identified by the MKS test."
		return (get_next_states(8, state, mks_results$change_df$year))
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
			state$msg <- "Change points ignored."
			return (get_next_states(8, state))
		} else if (option == 2) {
			state$msg <- "Splitting on change points identified by the MKS test."
			return (get_next_states(8, state, mks_results$change_df$year))
		} else {
			message("Invalid option. Please try again.")
		}
	}
}
 
# [8] MK -> [9] MK branching point
eda08 <- function(state, history) {
	message("\nApplying the Mann-Kendall trend test...")
	state$results <- run_stats("mk", data, state$start, state$end, img_path)
	get_next_states(9, state)
}

# [9] MK branching point -> [10] Spearman, [18] White
eda09 <- function(state, history) {

	# Get the results of the Mann-Kendall test
	mk_results <- history[[ length(history) ]]$results
	
	# Handle the branching point
	if (mk_results$reject) {
		state$msg <- "Monotonic trend found. Testing for serial correlation."
		return (get_next_states(10, state))
	} else {
		state$msg <- "No trend found. Testing the AMS variance for trends."
		return (get_next_states(18, state))
	}
}

# [10] Spearman -> [11] Spearman branching point
eda10 <- function(state, history) {
	message("\nApplying the Spearman test for serial correlation...")
	state$results <- run_stats("spearman", data, state$start, state$end, img_path)
	get_next_states(11, state)
}

# [11] Spearman branching point -> [12] BB-MK, [17] Sen's estimator (means)
eda11 <- function(state, history) {

	# Get the results of the Spearman test
	spearman_results <- history[[ length(history) ]]$results

	# Handle the branching point
	if (spearman_results$least_lag > 0) {
		state$msg <- "Serial correlation found. Confirming the monotonic trend."
		return (get_next_states(12, state))
	} else {
		state$msg <- "No serial correlation found. Estimating the monotonic trend."
		return (get_next_states(17, state))
	}
}

# [12] BB-MK -> [13] BB-MK branching point 
eda12 <- function(state, history) {
	message("\nApplying BB-MK test for a monotonic trend under serial correlation...")
	state$results <- run_stats("bbmk", data, state$start, state$end, img_path)
	get_next_states(13, state)
}

# [13] BB-MK branching point -> [14] PP, [18] White
eda13 <- function(state, history) {

	# Get the results of the BB-MK test
	bbmk_results <- history[[ length(history) ]]$results

	# Handle the branching point
	if (bbmk_results$reject > 0) {
		state$msg <- "Significant trend identified. Identifying the trend type."
		return (get_next_states(14, state))
	} else {
		state$msg <- "Trend was caused by serial correlation."
		return (get_next_states(18, state))
	}
}

# [14] PP -> [15] KPSS
eda14 <- function(state, history) {
	message("\nApplying PP test for the presence of a unit root...")
	state$results <- run_stats("pp", data, state$start, state$end, img_path)
	get_next_states(15, state)
}

# [15] KPSS -> [16] PP/KPSS branching point
eda15 <- function(state, history) {
	message("\nApplying KPSS test for the presence of a unit root...")
	state$results <- run_stats("kpss", data, state$start, state$end, img_path)
	get_next_states(16, state)
}

# [16] PP/KPSS branching point -> [17] Sen's estimator (means)
eda16 <- function(state, history) {

	# Get the results of the PP test and KPSS test
	pp_results <- history[[ length(history) - 1]]$results
	kpss_results <- history[[ length(history) ]]$results

	# Handle the branching point
	state$msg <- if (!pp_results$reject && kpss_results$reject) {
		"The PP/KPSS tests have identified a stochastic trend (unit root)."
	} else if (pp_results$reject && !kpss_results$reject) {
		"The PP/KPSS tests have identified a deterministic trend (no unit root)."
	} else {
		"The PP/KPSS tests are inconclusive, indicating an unknown trend."
	}

	get_next_states(17, state)
}

# [17] Sen's estimator (means) -> [18] White
eda17 <- function(state, history) {
	message("\nEstimating the trend in the AMS means using Sen's estimator...")
	state$results <- run_stats("sens-mean", data, state$start, state$end, img_path)
	get_next_states(18, state)
}

# [18] White -> [19] MW-MK
eda18 <- function(state, history) {
	message("\nApplying the White test for heteroskedasticity...")
	state$results <- run_stats("white", data, state$start, state$end, img_path)
	get_next_states(19, state)
}

# [19] MW-MK -> [20] White/MW-MK branching point
eda19 <- function(state, history) {
	message("\nApplying the MW-MK test for trends in the AMS variance...")
	state$results <- run_stats("mwmk", data, state$start, state$end, img_path)
	get_next_states(20, state)
}

# [20] White/MW-MK branching point -> [21] Sen's estimator (variance), [END]
eda20 <- function(state, history) {

	# Get the results of the White test and MW-MK test
	white_results <- history[[ length(history) - 1 ]]$results
	mwmk_results <- history[[ length(history) ]]$results

	# Handle the branching point
	if (white_results$reject | mwmk_results$reject) {
		state$msg <- "Time-dependence identified in the AMS variance."
		return (get_next_states(21, state))
	} else {
		state$msg <- "No time-dependence identified in the AMS variance."
		return (list(state = state, next_states = vector(mode = "list", length = 0)))
	}
}

# [21] Sen's estimator (variance) -> [END]
eda21 <- function(state, history) {
	message("\nEstimating the trend in the AMS variance using Sen's estimator...")
	state$results <- run_stats("sens-variance", data, state$start, state$end, img_path)
	list(state = state, next_states = vector(mode = "list", length = 0))
}


### EXECUTE FLOWCHART ###


# List of visited states, indexed by "start_year,end_year"
results <- list()

# A one-dimensional list of visited states, in order
ordered_results <- list()

# Queue of states to be visited in the future
queue <- list()

# Initialize the queue based on the given mode
min_year <- min(df$year)
max_year <- max(df$year)

if (mode == "preset") {

	# Validate the splits given in config.yml
	splits <- validate_split(min_year, max_year, paste(split, collapse = ","))

	# Iterate through the list of starting states and add them to the queue
	for (i in 1:(length(splits) - 1)) {
		name <- paste(c(splits[i], splits[i + 1] - 1), collapse = ",")
		queue[[name]] = c(8)
	}

} else {

	# Initialize queue by feeding the entire df to eda01()
	name <- paste(c(min_year, max_year), collapse = ",")
	queue[[name]] = c(1)
	
} 

# Run until the queue is empty
while (length(queue) > 0) {

	# Get the minimum key in the queue
	key <- sort(names(queue))[1]
	subqueue <- queue[[key]]
	years <- as.integer(strsplit(key, ",")[[1]])

	# Pop the location off of the subqueue
	location <- subqueue[1]
	subqueue <- subqueue[-1]

	# If the subqueue is now empty, remove it from the queue
	if (length(subqueue) == 0) queue[[key]] <- NULL

	# Set the state and get the correct function function name. 
	state <- list(location = location, start = years[1], end = years[2])
	fname <- paste0("eda", sprintf("%02d", location))

	# Pass results[[key]] since decision points only require tests on the active split.
	updated <- get(fname)(state, results[[key]])

	# Add all states in next_states to the queue
	for (ns in updated$next_states) {
		name <- glue("{ns$start},{ns$end}")
		queue[[name]] <- c(queue[[name]], ns$location)
	} 
	
	# Add the results of this step to the results
	results[[key]] <- c(results[[key]], list(updated$state))
	ordered_results <- c(ordered_results, list(updated$state))

	# If this step emitted a message, print it
	if (!is.null(updated$state$msg)) message(glue("\n\n{updated$state$msg}"))

}

# Define arguments for the report
report_args = list(result_list = ordered_results, output_dir = report_path)

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

message("\nReport(s) generated successfully.")

# Remove Rplots.pdf if it was accidentally created
if (file.exists("Rplots.pdf")) invisible(file.remove("Rplots.pdf"))
