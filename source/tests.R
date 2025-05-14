library(testthat)
library(optparse)
library(glue)
library(yaml)

# Source statistical tests
source("stats/pettitt/pettitt-test.R")
source("stats/mks/mks-test.R")
source("stats/mk/mk-test.R")
source("stats/spearman/spearman-test.R")
source("stats/bbmk/bbmk-test.R")
source("stats/white/white-test.R")
source("stats/mwmk/mwmk-test.R")
source("stats/sens/sens-estimator.R")

# Source helper functions
source("helpers/load-data.R")
source("helpers/validate-config.R")


# Create command line options
option_list <- list(
  make_option(c("-n","--name"), type="character", help="Name of test file to run."),
  make_option(c("-c","--config"), type="character", help="YAML confiugration file.")
)

# Parse given command line arguments
args <- commandArgs(trailingOnly = TRUE)
opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)

# Check for config argument and set to default value of config.yml if it doesn't exist
config_path <- ifelse(is.null(opt$config), "config.yml", opt$config)

# Attetmpt to load from config_path, throwing an error if it doesn't work
if (!file.exists(config_path)) {
	print_help(opt_parser)
	stop("Invalid configuration file path.")
} 

# Load and validate the configuration file
config <- read_yaml(config_path)
validate_config(config)

# Set the data_folder as an option
options(data_folder = config$data_folder)

# Run the given test (or all the tests if -n is null)
if (!is.null(opt$name)) {
	testthat::test_file(glue("tests/test-{opt$name}.R"))
} else {
	testthat::test_dir("tests")
}
