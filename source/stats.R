# Import libraries
library(yaml)
library(optparse)
library(glue)
library(patchwork)
library(ggplot2)
library(tools)

# Source helper functions
source("helpers/load-data.R")
source("helpers/validate-config.R")


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


### RUNNING THE STATISTICAL FUNCTION ###


# Throw an error if opt$name is 'sens' instead of 'sens-mean' or 'sens-variance'.
if (opt$name == "sens") {
	stop("Error: Please use 'sens-mean' or 'sens-variance' instead of 'sens'.")
} 

# Set the default function_path and function_name
function_path <- glue("stats/{opt$name}/{opt$name}-test.R")
function_name <- glue("{opt$name}_test")

# Override for Sen's trend estimator, since it is not a statistical test
if (opt$name %in% c("sens-mean", "sens-variance")) {
	function_path <- "stats/sens/sens-estimator.R"
	function_name <- "sens_estimator"
}

# Throw an error and quit if function_path does not exist
if (!file.exists(function_path)) {
	stop(glue("Error: /stats/{opt$name} does not have a testing script."))
} 

# Otherwise source the function
source(function_path)

# Pass the correct arguments for each statistical function
args <- list(
	"bbmk"          = list(ams = df_clean$max, alpha = alpha, reps = bbmk_repetitions),
	"kpss"          = list(ams = df_clean$max, alpha = alpha),
	"mk"            = list(data = df_clean$max, alpha = alpha),
	"mks"           = list(ams = df_clean$max, year = df_clean$year, alpha = alpha),
	"mwmk"          = list(std = df_variance$std, alpha = alpha),
	"pettitt"       = list(ams = df_clean$max, alpha = alpha),
	"pp"            = list(ams = df_clean$max, alpha = alpha),
	"spearman"      = list(ams = df_clean$max, alpha = alpha),
	"white"         = list(ams = df_clean$max, year = df_clean$year, alpha = alpha),
	"sens-mean"     = list(data = df_clean$max, year = df_clean$year),
	"sens-variance" = list(data = df_variance$std, year = df_variance$year)
)

result <- do.call(get(function_name), args[[opt$name]])
message(glue("Statistical function {opt$name} executed successfully."))


### PLOT GENERATION (IF APPLICABLE) ###


# Set the default plot settings
plot_path <- glue("stats/{opt$name}/{opt$name}-plot.R")
plot_func <- glue("{opt$name}_plot")
plot_name <- glue("{opt$name}-test.png")
df_plot <- df_clean

# Handle Sen's estimator edge cases again
if (opt$name == "sens-mean" | opt$name == "sens-variance") {

	# Set df_plot to df_variance if we ran Sen's trend estimator on the variance  
	if (opt$name == "sens-variance") df_plot <- df_variance

	# Run the plotting function
	source("stats/sens/sens-plot.R")
	plot <- get("sens_plot")(df_plot, result, opt$name, show_trend)

	# Override the default plot_name
	plot_name <- glue("{opt$name}-estimator.png")

} else if (file.exists(plot_path)) {

	# Handle the other plots
	source(plot_path)
	plot <- get(plot_func)(df_plot, result, show_trend)

} else {

	# Notify the user that their chosen test does not generate a plot
	message(glue("Statistical function {opt$name} does not have a plotting script."))
	quit()

}

# Generate an /img directory in report_path if it doesn't already exist
img_path <- glue("{report_path}/img")
if (!dir.exists(img_path)) dir.create(img_path)

# Save the plot to the image directory
ggsave(plot_name, plot = plot, path = img_path, width = 10, height = 8, bg = "white")
print(glue("Figure {plot_name} generated successfully."))

# Delete Rplots.pdf file if it was created (not sure why this happens)
if (file.exists("Rplots.pdf")) invisible(file.remove("Rplots.pdf"))


### REPORT GENERATION (IF APPLICABLE) ###




