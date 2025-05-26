test_that("Ensure validate-split does not throw an error on valid split argument.", {
	expect_no_error(validate_split(1900, 2000, c(1950)))
})


test_that("Ensure validate-split properly handles multiple splits.", {
	expect_no_error(validate_split(1900, 2000, c(1940, 1960)))
})


test_that("Ensure validate-split does not throw an error on empty split argument.", {
	expect_no_error(validate_split(1900, 2000, integer(0)))
})


test_that("Ensure that validate-split catches split below min_year.", {
	expect_error(
		validate_split(1900, 2000, c(1850, 1950)),
		regexp = "One or more split points are outside the valid range"
	)
})


test_that("Ensure that validate-split catches split above max_year.", {
	expect_error(
		validate_split(1900, 2000, c(1950, 2050)),
		regexp = "One or more split points are outside the valid range"
	)
})
