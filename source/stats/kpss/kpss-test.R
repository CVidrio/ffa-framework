# Loading tseries generates unnecessary warning messages
suppressPackageStartupMessages(library(aTSA))

# Conduct the KPSS unit root test
kpss_test <- function(df, alpha) {

	# NOTE: The implementation of the KPSS test in the tseries package interpolates 
	# the p-value using a table from Kwiatkowski et al. (1992). The  minimum p-value 
	# in this table is 0.01, so this test requires that alpha >= 0.01.
	if (alpha < 0.01) {
		cat("Warning: Do not run the KPSS test with alpha < 0.01.")
	}

	# Run the KPSS test and return the p-value
	result <- kpss.test(df$max)
	print(result)

}

