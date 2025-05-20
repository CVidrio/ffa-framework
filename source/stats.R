# Import libraries
library(yaml)
library(optparse)
library(glue)
library(patchwork)
library(ggplot2)
library(tools)
library(rmarkdown)
library(knitr)

# Source helper functions
source("helpers/load-data.R")
source("helpers/validate-config.R")


### PARSING COMMANE LINE OPTIONS ###


# Create command line options
option_list <- list(
  make_option(c("-n","--name"), type="character", help="Name of statistical test."),
  make_option(c("-s","--split"), type="character", help="Split points (optional)."),
  make_option(c("-c","--config"), type="character", help="YAML confiugration file.")
)

# Parse command line options
cli_args <- commandArgs(trailingOnly = TRUE)
opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

# Check for required test name argument
if (is.null(opt$name)) {
	print_help(opt_parser)
	stop("Missing required argument: --name")
}

# Send a specific error message if the user passes "sens" sa a name
if (opt$name == "sens") {
	stop("Please use 'sens-mean' or 'sens-variance' instead of 'sens'.")
} 

# Check that the test name argument is valid
test_names <- c(
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

if (!(opt$name %in% test_names)) {
	test_names_text <- paste("\n - ", test_names, collapse = "")
	stop(glue("Invalid test name. Valid options: {test_names_text}")) 
}

# Check for config option and set to default value ("config.yml") if it doesn't exist
config_path <- ifelse(is.null(opt$config), "config.yml", opt$config)

# Check that a file exists at config_path
if (!file.exists(config_path)) {
	stop("Invalid configuration file path.")
} 

# Load and validate the configuration file
config <- read_yaml(config_path)
validate_config(config)
invisible(list2env(config, envir = environment()))

# Throw an error if the data file does not exist
csv_path <- glue("{data_folder}/{csv_file}")
if (!file.exists(csv_path)) {
	stop(glue("Data file {csv_path} does not exist."))
}

# Load data from the .csv file specified in the config
data <- load(data_folder, csv_file, window_length, window_step)
invisible(list2env(data, envir = environment()))

# Get the min and max year in df and initialize splits
min_year <- min(df$year)
max_year <- max(df$year)

# Check for split argument and parse the list of years if it exists
if (!is.null(opt$split)) {

	# Split and trim whitespace
  	years <- trimws(strsplit(opt$split, ",")[[1]])

	# Check for non-numeric values
	if (any(!grepl("^[0-9]+$", years))) {
		stop("Argument --split contains non-numeric characters.")
	}

	# Convert to integers
	splits <- as.integer(years)

	# Check for invalid year range
	if (any(splits <= min_year | splits >= max_year)) {
		year_range <- glue("({min_year}-{max_year})")
		stop("One or more split points are outside the valid range {year_range}.")
	}
}

# Add min_year to splits. Add 1 to max_year for convenient indexing.
splits <- c(min_year, splits, max_year + 1)

# Create report directory for this .csv file if it doesn't already exist
csv_name <- file_path_sans_ext(csv_file)
report_path <- glue("{report_folder}/{csv_name}")
if (!dir.exists(report_path)) dir.create(report_path)

# Generate an /img directory in report_path if it doesn't already exist
img_path <- glue("{report_path}/img")
if (!dir.exists(img_path)) dir.create(img_path)


### STATISTICAL TEST, PLOTTING FUNCTION, AND REPORT ###


# Set the prefix (folder name) and suffix ('test' or 'estimator')
prefix <- ifelse(grepl("sens", opt$name), "sens", opt$name)
suffix <- ifelse(grepl("sens", opt$name), "estimator", "test")

# Get the paths of the files containing the test, plot, and .Rmd file
test_path <- glue("eda/{prefix}/{prefix}-{suffix}.R")
plot_path <- glue("eda/{prefix}/{prefix}-plot.R")
rmd_path <- glue("eda/{prefix}/{prefix}-report.Rmd")

# Get the names of the test function and plot function
test_function <- glue("{prefix}_{suffix}")
plot_function <- glue("{prefix}_plot")

# Get the name of report file
report_file <- glue("{opt$name}-report")

# Helper function for running the statistical test and plotting function on a split df
run_test <- function(year_start, year_end) {

	# Print a message with information about this split
	message(glue("\n\nRunning '{opt$name}' on data from {year_start}-{year_end}.\n\n"))

	# Subset the dataframes on year_start and year_end
	sb_clean = subset(df_clean, year >= year_start & year <= year_end)
	sb_variance = subset(df_variance, year >= year_start & year <= year_end)

	# Pass the correct arguments for each statistical test
	test_args <- list(
		"bbmk"          = list(sb_clean$max, alpha = alpha, reps = bbmk_repetitions),
		"kpss"          = list(sb_clean$max, alpha = alpha),
		"mk"            = list(sb_clean$max, alpha = alpha),
		"mks"           = list(sb_clean$max, sb_clean$year, alpha = alpha),
		"mwmk"          = list(sb_variance$std, alpha = alpha),
		"pettitt"       = list(sb_clean$max, sb_clean$year, alpha = alpha),
		"pp"            = list(sb_clean$max, alpha = alpha),
		"spearman"      = list(sb_clean$max, alpha = alpha),
		"white"         = list(sb_clean$max, sb_clean$year, alpha = alpha),
		"sens-mean"     = list(sb_clean$max, sb_clean$year, alpha = alpha),
		"sens-variance" = list(sb_variance$std, sb_variance$year, alpha = alpha)
	)
		
	# Run the statistical test
	source(test_path)
	result <- do.call(get(test_function), test_args[[opt$name]])

	# Define arguments for plotting function, handling edge case for Sen's estimator
	plot_args <- if (opt$name == "sens-mean") {
		list(sb_clean, result, opt$name, show_trend)
	} else if (opt$name == "sens-variance") {
		list(sb_variance, result, opt$name, show_trend)
	} else {
		list(sb_clean, result, show_trend)
	}

	# Generate and save the plot to disk if a plotting function exists
	if (file.exists(plot_path)) {

		# Source the plot function and generate an image
		source(plot_path)
		img <- do.call(get(plot_function), plot_args)

		# Set the file name of the plot
		name <- glue("{opt$name}-{suffix}-{year_start}-{year_end}.png")

		# Save the plot to disk
		ggsave(name, plot = img, path = img_path, width = 10, height = 8, bg = "white")
		message(glue("\n\nFigure {name} generated successfully."))

	}

	return (result)
	
}

# Initialize an unnamed list for storing the results
test_list <- vector("list", length(splits) - 1)

# Use the helper function above to run the statistical test on all splits
for (i in 1:(length(splits) - 1)) {

	# Get start and end years
	year_start <- splits[i]
	year_end <- splits[i + 1] - 1

	# Run the statistical test and the results to test_list
	result <- run_test(year_start, year_end)
	test_list[[i]] <- c(list(year_start = year_start, year_end = year_end), result)

}
 
# If report generation is disabled, end the script here
if (!generate_report) {
	message("No report was generated.") 
	quit()
}

# Set parameters for rendering the report
report_params <- list(
	test_list = test_list,
	output_dir = report_path,
	alpha = alpha,
	include_description = include_description,
	include_details = include_details,
	include_code = include_code
)

# Handle special case for Sen's trend estimator
if (opt$name == "sens-mean") report_params$data_type <- "mean"
if (opt$name == "sens-variance") report_params$data_type <- "variance"

# Render the report using each item in report_format given
for (format in report_format) {
	render(
		input = rmd_path,
		params = report_params,
		output_format = format,
		output_file = glue("{opt$name}-report"),
		output_dir = report_path,
		quiet = TRUE
	)
}

message(glue("\n\nReport(s) generated successfully."))

# Delete Rplots.pdf file if it was created (not sure why this happens)
if (file.exists("Rplots.pdf")) invisible(file.remove("Rplots.pdf"))
