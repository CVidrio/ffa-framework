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


# Create command line options
option_list <- list(
  make_option(c("-n","--name"), type="character", help="Name of test file to run."),
  make_option(c("-c","--config"), type="character", help="YAML confiugration file.")
)

# Parse given command line arguments
args <- commandArgs(trailingOnly = TRUE)
opt_parser <- OptionParser(option_list = option_list)
opt <- parse_args(opt_parser)


# Check for required config argument and then load the configuration file
if (is.null(opt$config)) {
	print_help(opt_parser)
	stop("Missing required argument: --config")
} else {
	config <- yaml::read_yaml(opt$config)
}


# Set the data_dir as an option
options(data_dir = config$data_dir)

# Run the given test (or all the tests if -n is null)
if (!is.null(opt$name)) {
	testthat::test_file(glue("tests/test-{opt$name}.R"))
} else {
	testthat::test_dir("tests")
}
