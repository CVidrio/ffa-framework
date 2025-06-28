library(testthat)
library(glue)
library(optparse)
library(httr)

# Load ffaframework library
suppressMessages(library(ffaframework))

# Source all helper functions
files <- list.files("source/helpers/", full.names = TRUE)
for (f in files) { source(f) }

# Create command line options
option_list <- list(
  make_option(c("-n","--name"), type="character", help="Name of test file to run."),
  make_option(c("-c","--config"), type="character", help="YAML confiugration file.")
)

# Parse given command line arguments
args <- commandArgs(trailingOnly = TRUE)
parser <- OptionParser(option_list = option_list)
opt <- parse_args(parser)

# Check for config argument and set to default value of config.yml if it doesn't exist
config.file <- ifelse(is.null(opt$config), "config.yml", opt$config)

# Run the given test (or all the tests if -n is null)
if (!is.null(opt$name)) {
	testthat::test_file(paste0("source/tests/test-", opt$name, ".R"))
} else {
	testthat::test_dir("source/tests")
}
