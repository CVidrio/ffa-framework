test_that("trend detection on dataset 2", {
	options <- validate.config(file.path(renv::project(), "config.yml"))
	df <- load.data("local", csv_files = "Application_2.csv")[[1]]
	result <- trend.detection(df$max, df$year, options)
	expect_equal(is.list(result), TRUE)
})


