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
source("helpers/run-stats.R")
source("helpers/load-data.R")
source("helpers/validate-config.R")
source("helpers/validate-split.R")
source("helpers/validate-name.R")


### PARSING COMMANE LINE OPTIONS ###


# Create command line options
option_list <- list(
  make_option(c("-n","--name"), type = "character", help = "Name of statistical test."),
  make_option(c("-s","--split"), type = "character", help = "Split points (optional)."),
  make_option(c("-c","--config"), type = "character", help = "YAML confiugration file.")
)

# Parse command line options
cli_args <- commandArgs(trailingOnly = TRUE)
opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

# Check for required test name argument
if (is.null(opt$name)) {
	print_help(opt_parser)
	stop("Missing required argument: --name")
} else {
	validate_name("stats", opt$name)
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

# Load data from the .csv file specified in the config
data <- load(data_folder, csv_file, window_length, window_step)

# Create report directory for this .csv file if it doesn't already exist
csv_name <- file_path_sans_ext(csv_file)
report_path <- glue("{report_folder}/{csv_name}")
if (!dir.exists(report_path)) dir.create(report_path)

# Generate an /img directory in report_path if it doesn't already exist
img_path <- glue("{report_path}/img")
if (!dir.exists(img_path)) dir.create(img_path)

# Parse, validate, and get the splits from the command line argument
splits <- validate_split(min(data$df$year), max(data$df$year), opt$split)


### STATISTICAL TEST, PLOTTING FUNCTION, AND REPORT ###


# Initialize an unnamed list for storing the results
result_list <- vector("list", length(splits) - 1)

# Use the helper function above to run the statistical test on all splits
for (i in 1:(length(splits) - 1)) {

	# Get start and end years
	start <- splits[i]
	end <- splits[i + 1] - 1

	# Run the statistical test and the results to results
	result <- run_stats(opt$name, data, start, end, img_path)
	result_list[[i]] <- c(result, list(start = start, end = end))
}
 
# If report generation is disabled, end the script here
if (!generate_report) {
	message("No report was generated.") 
	quit()
}

# Get the path to the .Rmd file and the name of the report
prefix <- ifelse(grepl("sens", opt$name), "sens", opt$name)
rmd_path <- glue("{prefix}/{prefix}-report.Rmd")
report_file <- glue("{opt$name}-report")

# Set parameters for rendering the report
report_params <- list(
	rmd_path = rmd_path,
	result_list = result_list,
	output_dir = report_path
)

# Handle special case for Sen's trend estimator
if (opt$name == "sens-mean") report_params$data_type <- "mean"
if (opt$name == "sens-variance") report_params$data_type <- "variance"

# Render the report using each item in report_format given
for (format in report_format) {
	render(
		input = "eda/stats-report.Rmd",
		params = report_params,
		output_format = format,
		output_file = report_file,
		output_dir = report_path,
		quiet = TRUE
	)
}

message(glue("\n\nReport(s) generated successfully."))

# Delete Rplots.pdf file if it was created (not sure why this happens)
if (file.exists("Rplots.pdf")) invisible(file.remove("Rplots.pdf"))
