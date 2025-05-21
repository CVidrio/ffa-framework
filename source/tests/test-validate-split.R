library(testthat)
library(glue)

test_that("Ensure validate-split does not throw an error on valid split argument.", {
	expect_no_error(validate_split(1900, 2000, '1950'))
})

test_that("Ensure validate-split properly handles whitespace.", {
	expect_no_error(validate_split(1900, 2000, ' 1950, 1970 '))
})

test_that("Ensure validate-split does not throw an error on NULL split argument.", {
	expect_no_error(validate_split(1900, 2000, NULL))
})

test_that("Ensure validate-split catches non-numeric split argument.", {
	expect_error(
		validate_split(1900, 2000, '19A0'),
		regexp = "Argument --split contains non-numeric characters."
	)
})

test_that("Ensure that validate-split catches split below min_year.", {
	expect_error(
		validate_split(1900, 2000, '1800, 1950'),
		regexp = "One or more split points are outside the valid range"
	)
})

test_that("Ensure that validate-split catches split above max_year.", {
	expect_error(
		validate_split(1900, 2000, '1920, 2030'),
		regexp = "One or more split points are outside the valid range"
	)
})
