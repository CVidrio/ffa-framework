library(glue)

# This function validates the opt$split command line argument
# - min_year is the minimum year in the dataframe
# - max_year is the maximum year in the dataframe
# - opt_split is the string passed to the --split argument
#
# validate_split returns splits, which is a list of years
# - splits contains 2 + length(opt_split) entries
# - If opt_split is NULL, splits is c(min_year, max_year + 1)

validate_split <- function(min_year, max_year, opt_split) {

	# Get the min and max year in df and get the splits
	splits <- integer(0)

	# Check for split argument and parse the list of years if it exists
	if (!is.null(opt_split)) {

		# Split and trim whitespace
		years <- trimws(strsplit(opt_split, ",")[[1]])

		# Check for non-numeric values
		if (any(!grepl("^[0-9]+$", years))) {
			stop("Argument --split contains non-numeric characters.")
		}

		# Convert to integers
		splits <- as.integer(years)

		# Check for invalid year range
		if (any(splits <= min_year | splits >= max_year)) {
			year_range <- glue("({min_year}-{max_year})")
			stop("One or more split points are outside the valid range {year_range}.")
		}
	}

	# Add min_year to splits. Add 1 to max_year for convenient indexing.
	c(min_year, splits, max_year + 1)

}
