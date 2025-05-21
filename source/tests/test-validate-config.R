library(testthat)
library(glue)

# Correctness Tests 
test_that("Test that validate-config.R does not throw an error on correct config.yml.", {
	expect_no_error(validate_config(config))
})

test_that("Test that validate-config.R works with csv_files = NULL.", {
	config$csv_files <- character(0)
	expect_no_error(validate_config(config))
})

test_that("Test that validate-config.R works with split_points = NULL.", {
	config$split_points <- integer(0)
	expect_no_error(validate_config(config))
})


# Error Handling
test_that("Test that validate-config.R catches missing argument.", {
	config$bbmk_repetitions <- NULL
	expect_error(
		validate_config(config),
		regexp = "Missing configuration key: 'bbmk_repetitions'."
	)
})

test_that("Test that validate-config.R catches incorrect data type.", {
	config$csv_files <- as.integer(c(10, 100))
	expect_error(
		validate_config(config),
		regexp = "Type mismatch for 'csv_files'"
	)
})

test_that("Test that validate-config.R catches invalid data_folder.", {
	config$data_folder <- "~/this/folder/does/not/exist"
	expect_error(
		validate_config(config),
		regexp = glue("data_folder '{config$data_folder}' does not exist.")
	)
})

test_that("Test that validate-config.R catches invalid csv_file.", {
	config$csv_files <- c("does-not-exist.csv")
	expect_error(
		validate_config(config),
		regexp = glue("csv_file 'does-not-exist.csv' does not exist.")
	)
})

test_that("Test that validate-config.R catches invalid report_folder.", {
	config$report_folder <- "~/this/folder/does/not/exist" 
	expect_error(
		validate_config(config),
		regexp = glue("report_folder '{config$report_folder}' does not exist.")
	)
})

test_that("Test that validate-config.R catches invalid mode.", {
	config$mode <- "does-not-exist" 
	expect_error(
		validate_config(config),
		regexp = "mode must be one of 'preset', 'automatic', or 'manual'."
	)
})

test_that("Test that validate-config.R catches invalid (low) alpha.", {
	config$alpha <- 0.001
	expect_error(
		validate_config(config),
		regexp = "alpha must be between 0.01 and 0.10."
	)
})

test_that("Test that validate-config.R catches invalid (high) alpha.", {
	config$alpha <- 0.50  
	expect_error(
		validate_config(config),
		regexp = "alpha must be between 0.01 and 0.10."
	)
})

test_that("Test that validate-config.R catches invalid file type.", {
	config$report_format <- c("invalid_format")
	expect_error(
		validate_config(config),
		regexp = "report_format 'invalid_format' is invalid."
	)
})

test_that("Test that validate-config.R warns when bbmk_repetitions < 10000.", {
	config$bbmk_repetitions <- as.integer(9999)
	expect_message(
		validate_config(config), 
		regexp = "Warning: bbmk_repetitions should be at least 10000.",
	)
})

test_that("Test that validate-config.R warns when window_step > window_length.", {
	config$window_step <- as.integer(20)
	expect_message(
		validate_config(config), 
		regexp = "Warning: window_step should not be greater than window_length.",
	)
})
