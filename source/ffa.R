# Import libraries
library(glue)
library(tibble)
library(tools)
library(rmarkdown)
library(knitr)
library(optparse)
library(yaml)

# Source all statistical test and plotting functions
files <- list.files("ffa/", pattern = "\\.R$", recursive = TRUE, full.names = TRUE)
for (f in files) source(f)

# Source helper functions
source("helpers/load-data.R")
source("helpers/validate-config.R")

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

# Create the reports folder if it doesn't already exist
csv_name <- file_path_sans_ext(csv_files)
report_path <- glue("{report_folder}/{csv_name}")
if (!dir.exists(report_path)) dir.create(report_path)

# Generate an /img directory in report_path if it doesn't already exist
img_path <- glue("{report_path}/img")
if (!dir.exists(img_path)) dir.create(img_path)

# Load data from the given input file and remove leading/trailing NaNs
data <- load(data_folder, csv_files, window_length, window_step)


# Run distribution selection selection metric specified in config.yml
message(glue("\n\nRunning distribution selection with method '{selection_metric}'."))

ams <- data$df_clean$max
sml <- get_sample_lm(ams)
distributions <- get_distributions()

selection_results <- if (selection_metric == "L-distance") {
	l_distance(sml, distributions)		
} else if (selection_metric == "L-kurtosis") {
	l_kurtosis(sml, distributions)
} else if (selection_metric == "Z-statistic") {
	z_statistic(sml, distributions, ams)
}

# Save the distribution to a variable
distribution <- distributions[[ selection_results$recommendation ]]
message(glue(" - Selected distribution: {selection_results$recommendation}"))

# Generate a plot
lm_plot <- plot_lm(selection_metric, selection_results, sml, distributions)
name <- glue("{ tolower(selection_metric) }-selection.png")
ggsave(name, plot = lm_plot, path = img_path, width = 10, height = 8)

# Run parameter estimation
message(glue("\n\nRunning parameter estimation with method '{estimation_method}'."))

estimation_results <- if(estimation_method == "L-moments") {
	l_moments(ams, distribution)
} else if (estimation_method == "MLE") {
	NULL	
} else if (estimation_method == "GMLE") {
	NULL
}

# Print the fitted parameters, adjusting shape for GPA/GEV (see documentation)
p_vector <- estimation_results
if (selection_results$recommendation %in% c("GPA", "GEV")) p_vector[3] <- -p_vector[3]
p_text <- paste(round(p_vector, 4), collapse = ", ")
message(glue(" - Estimated parameters: {p_text}"))

# Run uncertainty quantification
message(glue("\n\nRunning uncertainty quantification with method '{uncertainty_method}'."))

uncertainty_results <- if(uncertainty_method == "S-bootstrap") {
	s_bootstrap(ams, distribution, estimation_method)
} else if (uncertainty_method == "RFPL") {
	NULL	
} else if (uncertainty_method == "RFGPL") {
	NULL
}

# Generate a plot
uncertainty_plot <- plot_uncertainty(uncertainty_results)
name <- glue("{ tolower(uncertainty_method) }-results.png")
ggsave(name, plot = uncertainty_plot, path = img_path, width = 10, height = 8)

# Run model assessment
assessment <- model_assessment(ams, distribution, estimation_results, uncertainty_results)

# Generate a plot
assessment_plot <- plot_assessment(ams, assessment)
name <- "assessment-results.png"
ggsave(name, plot = assessment_plot, path = img_path, width = 10, height = 8)

# Print the results of FFA
message("\nFFA Complete.")

# If report generation is disabled, go to next file
if (!generate_report) {
	message("No report was generated.") 
	quit()
}

# Define arguments for the report
report_args = list(
	selection_metric = selection_metric,
	selection_results = selection_results,
	estimation_method = estimation_method,
	estimation_results = estimation_results,
	uncertainty_method = uncertainty_method,
	uncertainty_results = uncertainty_results,
	assessment = assessment,
	output_dir = report_path
)

# Render the report using each item in report_format given
for (format in report_format) {
	render(
		input = "ffa/ffa-report.Rmd",
		params = report_args,
		output_format = format,
		output_file = "ffa-report",
		output_dir = report_path,
		quiet = TRUE
	)
}

# Print completion message
message("\nReport(s) generated successfully.")

