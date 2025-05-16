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
source("helpers/load-data.R")
source("helpers/validate-config.R")


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


# Define plotting arguments globally
plot_args = list(path = img_path, width = 10, height = 8, bg = "white")

# [1] Apply the Pettitt test
eda01 <- function() {
	message("\n--- CHANGE POINT ANALYSIS ---\n")
	message("Applying the Pettitt test for abrupt change points...\n")

	# Run the Pettitt test, generate a plot, and save it 
	results <- pettitt_test(df_clean$max, df_clean$year, alpha)
	pettitt_plot <- pettitt_plot(df_clean, results, show_trend)
	do.call(ggsave, c(list("pettitt-test.png", plot = pettitt_plot), plot_args))

	# Return the results and go to the MKS test
	return (list(location = 2, results = results))

}

# [2] Apply the MKS test
eda02 <- function() {
	message("\nApplying the MKS test for abrupt change points...\n")

	# Run the MKS test, generate a plot, and save it 
	results <- mks_test(df_clean$max, df_clean$year, alpha)
	mks_plot <- mks_plot(df_clean, results, show_trend)
	do.call(ggsave, c(list("mks -test.png", plot = mks_plot), plot_args))

	# Return the results and go to the decision point
	return (list(location = 3, results = results))

}

# [3] Decision point for the [1] Pettit test and [2] MKS test
eda03 <- function(results_list) {

	# Get the results of the Pettitt test and MKS test
	pettitt_results <- results_list[["1"]]
	mks_results <- results_list[["2"]]
	 
	# Determine the next step in the flowchart
	if (!pettitt_results$reject && !mks_results$reject) {

		# If no change points were found, do nothing and go to [6] (MK test)
		msg <- "No change points were found so the data will not be split."
		message(glue("\n{msg}\n"))
		return (list(location = 8, results = msg))

	} else {

		# Prompt the user to accept the change points
		pettitt_option <- "  (2) Accept change points from Pettitt test."
		mks_option <- "  (3) Accept change points from MKS test."

		option_message <- c(
			"\nSelect an option:", 
			"  (1) Ignore change points.",
			if (mks_results$reject) mks_option else NULL,
			if (pettitt_results$reject) pettitt_option else NULL
		)

		message(paste(option_message, collapase = "\n"))
		cat("Enter a number: ")
		option <- readLines(file("stdin"), 1)

		# Go to the next step in the flowchart
		if (option == 1) {
			msg <- "Change points ignored."
			return (list(location = 8, results = msg))
		} else if (option == 2) {
			return (list(location = 4))
		} else if (option == 3) {
			return (list(location = 6))
		} else {
			stop("Invalid option. Please try again.")
		}

	}
	
}

# [4] Run the Pettitt test on a split dataset (TBD)
eda04 <- function() {

}

# [5] Decision point for secondary Pettitt test (TBD)
eda05 <- function() {

}

# [6] Run the MKS test on a split dataset (TBD)
eda06 <- function() {

}

# [7] Decision point for secondary MKS test (TBD)
eda07 <- function() {

}
 
# [8] Apply Mann-Kendall test (on the AMS means)
eda08 <- function() {
	message("\n--- TREND IDENTIFICATION IN AMS MEANS ---\n")
	message("Applying the Mann-Kendall trend test...\n")

	# Get the results and go to the branching point
	results <- mk_test(df_clean$max, alpha)
	return (list(location = 9, results = results))
}

# [9] Branching point for [8] Mann-Kendall test
eda09 <- function(mks_results) {

	# Get the results of the Mann-Kendall test
	mk_results <- results_list[["8"]]
	
	# Handle the branching point
	if (mk_results$reject) {
		msg <- "Monotonic trend found. Testing for serial correlation."
		return (list(location = 10, results = msg))  
	} else {
		msg <- "No trend found. Testing the AMS variance for trends."
		return (list(location = 18, results = msg)) 
	}
}

# [10] Apply the Spearman test for serial correlation.
eda10 <- function() {
	message("\nApplying the Spearman test for serial correlation...\n")

	# Get the results, generate a plot, and save it
	results <- spearman_test(df_clean$max, alpha)
	spearman_plot <- spearman_plot(df_clean, results, show_trend)
	do.call(ggsave, c(list("spearman-test.png", plot = spearman_plot), plot_args))

	# Go to the branching point
	return (list(location = 11, results = results))

}

# [11] Branching point for Spearman test.
eda11 <- function(results_list) {

	# Get the results of the Spearman test
	spearman_results <- results_list[["10"]]

	# Handle the branching point
	if (spearman_results$least_lag > 0) {
		msg <- "Serial correlation found. Confirming the monotonic trend."
		return (list(location = 12, results = msg)) 
	} else {
		msg <- "No serial correlation found. Estimating the monotonic trend."
		return (list(location = 17, results = msg)) 
	}
}

# [12] Apply the BB-MK test
eda12 <- function() {
	message("\nApplying BB-MK test for trend detection under serial correlation...\n")

	# Get the results, generate a plot, and save it
	results <- bbmk_test(df_clean$max, alpha)
	bbmk_plot <- bbmk_plot(df_clean, results, show_trend)
	do.call(ggsave, c(list("bbmk-test.png", plot = bbmk_plot), plot_args))

	# Go to the branching point
	return (list(location = 13, results = results ))

}

# [13] Branching point for the [12] BB-MK test.
eda13 <- function(results_list) {

	# Get the results of the BB-MK test
	bbmk_results <- results_list[["12"]]

	# Handle the branching point
	if (bbmk_results$reject > 0) {
		msg <- "Significant trend identified. Identifying the trend type."
		return (list(location = 14, results = msg)) 
	} else {
		msg <- "Trend was due to serial correlation. Testing the AMS variance for trends."
		return (list(location = 18, results = msg))  
	}
}

# [14] Apply the PP test
eda14 <- function() {
	message("\nApplying PP test for the presence of a unit root...\n")

	# Get the results and going to the KPSS test
	pp_results <- pp_test(df_clean$max, alpha)
	return (list(location = 15, results = results))  
}

# [15] Apply the KPSS test
eda15 <- function() {
	message("\nApplying KPSS test for the presence of a unit root...\n")

	# Get the results and go to the branching point
	kpss_results <- kpss_test(df_clean$max, alpha)
	return (list(location = 16, results = results))  
}

# [16] Branching point for [14] PP test and [15] KPSS test
eda16 <- function(results_list) {

	# Get the results of the PP test and KPSS test
	pp_results <- results_list[["14"]]
	kpss_results <- results_list[["15"]]

	# Handle the branching point
	if (!pp_results$reject && kpss_results$reject) {
		msg <- "The PP/KPSS tests have identified a stochastic trend (unit root)."
	} else if (pp_results$reject && !kpss_results$reject) {
		msg <- "The PP/KPSS tests have identified a deterministic trend (no unit root)."
	} else {
		msg <- "The PP/KPSS tests are inconclusive, indicating an unknown trend."
	}
	return (list(location = 17, results = msg))
}

# [17] Sen's trend estimator for AMS means.
eda17 <- function() {
	message("\nEstimating the trend in the AMS means using Sen's estimator...\n")

	# Get the results	
	results <- sens_estimator(df_clean$max, df_clean$year, alpha)
	m <- results$sens_slope
	b <- results$sens_intercept

	# Generate and save a plot
	sens_plot <- sens_plot(df_clean, results, "sens-mean", show_trend)
	do.call(ggsave, c(list("sens-mean-estimator.png", plot = sens_plot), plot_args))

	# Go to the White test
	return (list(location = 18, results = results))  

}

# [18] Apply the White test
eda18 <- function() {
	message("\n--- TREND IDENTIFICATION IN AMS VARIANCE ---\n")
	message("Applying the White test for heteroskedasticity...\n")
	
	# Get the results and go to the MW-MK test
	results <- white_test(df_clean$max, df_clean$year, alpha)
	return (list(location = 19, results = results))  

}

# [19] Apply the MW-MK test
eda19 <- function() {
	message("\nApplying the MW-MK test for trends in the AMS variance...\n")

	# Get the results and go to the branching point
	results <- mwmk_test(df_variance$std, alpha)
	return (list(location = 20, results = results)) 
}

# [20] Branching point for [18] White test and [19] MW-MK test
eda20 <- function(results_list) {

	# Get the results of the White test and MW-MK test
	white_results <- results_list[["18"]]
	mwmk_results <- results_list[["19"]]

	# Handle the branching point
	if (white_results$reject | mwmk_results$reject) {
		msg <- "Time-dependence identified in the AMS variance. Estimating the trend."
		return (list(location = 21, results = msg)) 
	} else {
		msg <- "No time-dependence identified in the AMS variance. Generating a report."
		return (list(location = NULL, results = msg))  
	}
}

# [21] Apply Sen's trend estimator and the Runs test on the AMS variance.
eda21 <- function() {
	message("\nEstimating the trend in the AMS variance using Sen's estimator...\n")

	# Get the results
	results <- sens_estimator(df_variance$std, df_variance$year, alpha)
	m <- results$sens_slope
	b <- results$sens_intercept

	# Generate plot and save to image directory
	sens_plot <- sens_plot(df_variance, results, "sens-variance", show_trend)
	do.call(ggsave, c(list("sens-variance-estimator.png", plot = sens_plot), plot_args))

	# Generate the report
	return (list(location = NULL, results = msg))
}


### EXECUTE FLOWCHART ###


# Current location in the flowchart
current_location <- 1

# List of locations visited
locations <- c()

# List of results from all tests
results_list <- list()

# Iterate through the flowchart until current_location is NULL
while (!is.null(current_location)) {

	# Get the function name for the current location (i.e. "eda02")
	index_str <- sprintf("%02d", current_location)
	func_name <- paste0("eda", index_str)

	# Past results_list to the flowchart item if it is a decision/branching point
	if (current_location %in% c(3, 5, 7, 9, 11, 13, 16, 20)) {
		state <- get(func_name)(results_list)
	} else {
		state <- get(func_name)()
	}

	# Update locations, results_list, and then current_location
	locations <- c(locations, current_location)
	results_list[[toString(current_location)]] <- state$results
	current_location <- state$location
}

message("\nEDA complete. Generating a report...\n")

# Define arguments for the report
report_args = list(
	results_list = results_list,
	locations = locations,
	output_dir = report_path,
	alpha = alpha,
	include_details = include_details,
	include_code = include_code
)

# Render the report using each item in report_format given
for (format in report_format) {
	render(
		input = "eda/report.Rmd",
		params = report_args,
		output_format = format,
		output_file = "eda-report",
		output_dir = report_path,
		quiet = TRUE
	)
}

# Remove Rplots.pdf if it was accidentally created
if (file.exists("Rplots.pdf")) invisible(file.remove("Rplots.pdf"))
