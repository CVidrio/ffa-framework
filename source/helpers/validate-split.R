library(glue)

# This function validates the opt$split command line argument
# - min_year is the minimum year in the dataframe
# - max_year is the maximum year in the dataframe
# - split_points is list of years specified in config.yml 
#
# validate_split returns splits, which is a list of years
# - splits contains 2 + length(split_points) entries
# - If split_points is NULL, splits is c(min_year, max_year + 1)

validate_split <- function(min_year, max_year, split_points) {

	splits <- integer(0)

	# Check for split argument and parse the list of years if it exists
	if (!is.null(split_points)) {

		# Check for non-numeric values
		if (any(!grepl("^[0-9]+$", split_points))) {
			stop("Argument --split contains non-numeric characters.")
		}

		# Convert to integers
		splits <- as.integer(split_points)

		# Check for invalid year range
		if (any(splits <= min_year | splits >= max_year)) {
			year_range <- glue("({min_year}-{max_year})")
			stop("One or more split points are outside the valid range {year_range}.")
		}
	}

	# Add min_year to splits. Add 1 to max_year for convenient indexing.
	c(min_year, splits, max_year + 1)

}
