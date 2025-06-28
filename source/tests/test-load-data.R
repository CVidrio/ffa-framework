test_that("load works with both CSV and GeoMet data", {

	# CSV Data
	csv_data <- load.data("local", csv_files = c("Application_1.csv", "Application_2.csv"))
	expect_equal(length(csv_data), 2)

	csv_df1 <- csv_data[[1]]
	csv_df2 <- csv_data[[2]]
	expect_equal(nrow(csv_df1), 108)
	expect_equal(nrow(csv_df2), 91)

	# Geomet Data
	geomet_data <- load.data("geomet", station_ids = c("07BE001", "08NH021"))
	expect_equal(length(geomet_data), 2)

	geomet_df1 <- geomet_data[[1]]
	geomet_df2 <- geomet_data[[2]]
	geomet_df1 <- subset(geomet_df1, year <= 2020)
	geomet_df2 <- subset(geomet_df2, year <= 2018)
	expect_equal(nrow(geomet_df1), 108)
	expect_equal(nrow(geomet_df2), 91)

	# Comparision Test
	expect_equal(csv_df1$max, geomet_df1$max)
	expect_equal(csv_df1$year, geomet_df1$year)
	expect_equal(csv_df2$max, geomet_df2$max)
	expect_equal(csv_df2$year, geomet_df2$year)

})

