library(testthat)

# Source the data loading file
source("tests/load-data.R")

# Source statistical tests
source("stats/pettitt/pettitt-test.R")
source("stats/mks/mks-test.R")
source("stats/mk/mk-test.R")
source("stats/spearman/spearman-test.R")
source("stats/bbmk/bbmk-test.R")

# Run all files in /tests using testthat
testthat::test_dir("tests")

