test_that("flood frequency analysis on data set 1", {
	options <- validate.config(file.path(renv::project(), "config.yml"))
	df <- load.data("local", csv_files = "Application_1.csv")[[1]]
	result <- frequency.analysis(df$max, df$year, options, NULL)
	expect_equal(is.list(result), TRUE)
})


