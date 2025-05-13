# Loading tseries generates unnecessary warning messages
suppressPackageStartupMessages(library(aTSA))

# Conduct the Phillips-Perron unit root test
pp_test <- function(df, alpha) {

	# NOTE: The implementation of the Phillips-Perron test in the tseries package
	# interpolates the p-value using a table from Banerjee et al. (1993). The 
	# minimum p-value in this table is 0.01, so this test requires that alpha >= 0.01.
	if (alpha < 0.01) {
		cat("Warning: Do not run the Phillips-Perron test with alpha < 0.01.")
	}

	# Run the Phillips-Perron test and return the p-value
	result <- pp.test(df$max, type="Z_tau")
	print(result)

}
