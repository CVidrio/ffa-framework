library(testthat)
library(optparse)
library(glue)
library(yaml)

# Source statistical tests
source("eda/pettitt/pettitt-test.R")
source("eda/mks/mks-test.R")
source("eda/mk/mk-test.R")
source("eda/spearman/spearman-test.R")
source("eda/bbmk/bbmk-test.R")
source("eda/white/white-test.R")
source("eda/mwmk/mwmk-test.R")
source("eda/sens/sens-estimator.R")

# Source distribution functions
source("ffa/get-distributions.R")

# Source selection functions
source("ffa/selection/l-distance.R")
source("ffa/selection/l-kurtosis.R")
source("ffa/selection/z-statistic.R")
source("ffa/selection/get-sample-lm.R")

# Source estimation functions
source("ffa/estimation/l-moments.R")

# Source uncertainty functions
source("ffa/uncertainty/s-bootstrap.R")

# Source model sasessment function
source("ffa/assessment//model-assessment.R")

# Source helper functions
source("helpers/load-data.R")
source("helpers/validate-config.R")
source("helpers/validate-split.R")
source("helpers/validate-name.R")


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
config <- validate_config(config)

# Set the data_folder as an option
options(data_folder = config$data_folder)

# Run the given test (or all the tests if -n is null)
if (!is.null(opt$name)) {
	validate_name("tests", opt$name)
	testthat::test_file(glue("tests/test-{opt$name}.R"))
} else {
	testthat::test_dir("tests")
}
