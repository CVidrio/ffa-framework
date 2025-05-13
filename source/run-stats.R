# Import libraries
library(yaml)
library(optparse)
library(glue)
library(patchwork)
library(ggplot2)
library(tools)

# Helper function for loading data
source("load-data.R")


### PARSING COMMANE LINE OPTIONS ###


# Create command line options
option_list <- list(
  make_option(c("-n","--name"), type="character", help="Name of statistical test."),
  make_option(c("-c","--config"), type="character", help="YAML confiugration file.")
)

# Parse given command line arguments
args <- commandArgs(trailingOnly = TRUE)
opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)


# Check for required test name argument
if (is.null(opt$name)) {
	print_help(opt_parser)
	stop("Missing required argument: --name")
}

# Check for required config argument and then load the configuration file
if (is.null(opt$config)) {
	print_help(opt_parser)
	stop("Missing required argument: --config")
} else {
	config <- yaml::read_yaml(opt$config)
}


### DIRECTORY SETUP ###


# Create a directory for storing reports for this csv_file
csv_name <- file_path_sans_ext(config$csv_file)
report_path <- glue("{config$report_dir}/{csv_name}")
if (!dir.exists(report_path)) dir.create(report_path)

# Load data from the given input file and remove leading/trailing NaNs
data <- load(config$data_dir, config$csv_file, config$window_length, config$window_step)
df <- data$df
df_clean <- data$df_clean
df_variance <- data$df_variance


### RUNNING THE STATISTICAL FUNCTION ###


if (opt$name == "sens") {

	# Throw an error if opt$name is 'sens' instead of 'sens-mean' or 'sens-variance'.
	print(glue("Error: Please use 'sens-mean' or 'sens-variance' instead of 'sens'."))
	quit(status = 0)

} else if (opt$name %in% c("sens-mean", "sens-variance")) {

	# Sen's estimator is a special case because it is not a statistical test
	function_path <- "stats/sens/sens-estimator.R"
	function_name <- "sens_estimator"

} else {

	# Handle regular statistical tests which are located in {name}-test.R
	function_path <- glue("stats/{opt$name}/{opt$name}-test.R")
	function_name <- glue("{opt$name}_test")

}

# Throw an error and quit if function_path does not exist
if (!file.exists(function_path)) {
	print(glue("Error: /stats/{opt$name} does not have a testing script."))
	quit(status = 0)
} 

# Otherwise source the function
source(function_path)

# Pass the correct arguments for each statistical function
func <- get(function_name)
result <- if (opt$name == "bbmk") {
	func(df_clean$max, config$alpha, config$bbmk_repetitions)
} else if (opt$name == "kpss") {
	func(df_clean$max, config$alpha)
} else if (opt$name == "mk") {
	func(df_clean$max, config$alpha)
} else if (opt$name == "mks") {
	func(df_clean$max, df_clean$year, config$alpha)
} else if (opt$name == "mwmk") {
	func(df_variance$std, config$alpha)
} else if (opt$name == "pettitt") {
	func(df_clean$max, config$alpha)
} else if (opt$name == "pp") {
	func(df_clean$max, config$alpha)
} else if (opt$name == "sens-mean") {
	func(df_clean$max, df_clean$year) 
} else if (opt$name == "sens-variance") {
	func(df_variance$std, df_variance$year) 
} else if (opt$name == "spearman") {
	func(df_clean$max, config$alpha)
} else if (opt$name == "white") {
	func(df_clean$max, df_clean$year, config$alpha)
} 

print(glue("Statistical function {opt$name} executed successfully."))


### PLOT GENERATION (IF APPLICABLE) ###


# Handle Sen's estimator edge case again
if (opt$name %in% c('sens-mean', 'sens-variance')) {
	plot_path <- glue("stats/sens/sens-plot.R")
	plot_func <- glue("sens_plot")
	plot_name <- glue("{opt$name}-estimator.png")
} else {
	plot_path <- glue("stats/{opt$name}/{opt$name}-plot.R")
	plot_func <- glue("{opt$name}_plot")
	plot_name <- glue("{opt$name}-test.png")
}

if (file.exists(plot_path)) {

	source(plot_path)
	get(plot_func)(df_clean, result)

	# Save the plot to the report directory
	ggsave(plot_name, path = report_path, width = 10, height = 8, bg = "white")
	print(glue("Figure {plot_name} generated successfully."))

} else {

	# Notify the user that their chosen test does not generate a plot
	print(glue("Statistical function {opt$name} does not have a plotting script."))

}
