test_that("Test that validate-name works with valid statistical test.", {
	expect_no_error(validate_name("stats", "mk"))
})


test_that("Test that validate-name works with valid testing file.", {
	expect_no_error(validate_name("tests", "sens-mean"))
})


test_that("Test that validate-name throws error on invalid statistical test.", {
	expect_error(
		validate_name("stats", "does-not-exist"),
		regexp = "Invalid argument --name."
	)
})


test_that("Test that validate-name throws error on invalid testing file.", {
	expect_error(
		validate_name("tests", "does-not-exist"),
		regexp = "Invalid argument --name."
	)
})


test_that("Test that validate-name throws error on invalid mode.", {
	expect_error(
		validate_name("does-not-exist", "bbmk"),
		regexp = "Argument 'mode' to validate_name must be 'tests' or 'stats'."
	)
})
