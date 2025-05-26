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
message(glue("Running distribution selection with method '{selection_metric}'."))

ams <- data$df$max
sml <- sample_lm(ams)
dml <- distribution_lm()

selection_results <- if (selection_metric == "L-distance") {
	l_distance(sml, dml)		
} else if (selection_metric == "L-kurtosis") {
	l_kurtosis(sml, dml)
} else if (selection_metric == "Z-statistic") {
	z_statistic(sml, dml, ams)
}

# Generate a plot
lm_plot <- plot_lm(selection_metric, selection_results, sml, dml)
name <- glue("{ tolower(selection_metric) }-selection.png")
ggsave(name, plot = lm_plot, path = img_path, width = 10, height = 8, bg = "white")

# Run parameter estimation
estimation_results <- if(estimation_method == "L-moments") {
	l_moments(sml)
} else if (estimation_method == "MLE") {
	NULL	
} else if (estimation_method == "GMLE") {
	NULL
}

# Run uncertainty quantification
uncertainty_results <- if(uncertainty_method == "S-bootstrap") {
	s_bootstrap(sml)
} else if (uncertainty_method == "RFPL") {
	NULL	
} else if (uncertainty_method == "RFGPL") {
	NULL
}



