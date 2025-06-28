test_that("change points on dataset 2", {

	options <- validate.config(file.path(renv::project(), "config.yml"))
	df <- load.data("local", csv_files = "Application_2.csv")[[1]]
	result <- change.points(df$max, df$year, options)
	expect_equal(is.list(result), TRUE)

})

