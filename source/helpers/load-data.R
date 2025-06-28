load.data <- function(data_source, csv_files = NULL, station_ids = NULL) {

	# Helper function to load a CSV file
	load.csv <- function(csv_file) {

		# Read and load the data file
		csv_path <- file.path(renv::project(), "data", csv_file)
		df <- read.csv(csv_path)

		# Remove NaN values
		df[!is.na(df$max), ]

	}

	# Helper function to make an API call
	load.geomet <- function(station_id) {
		
		# Set GeoMet API URL
		url <- "https://api.weather.gc.ca/collections/hydrometric-annual-statistics/items"

		# Set query parameters
		params <- list(
			limit = 200,
			skipGeometry = TRUE,
			DATA_TYPE_EN = "Discharge",
			STATION_NUMBER = station_id
		)

		# Make a GET request and parse the content as JSON
		response <- GET(url, query = params)
		content <- content(response, as = "parsed", type = "application/json")

		# Extract the streamflow data and years
		ams <- sapply(content$features, function(x) x$properties$MAX_VALUE)	
		dates <- sapply(content$features, function(x) x$properties$MAX_DATE)
		years <- as.integer(substr(dates, 1, 4))			

		# Create a dataframe without NaN values
		data.frame(year = years, max = ams)

	}

	# Get the correct loading function and list of sources
	if (data_source == "Local") {
		loader <- load.csv
		sources <- csv_files
	} else {
		loader <- load.geomet
		sources <- station_ids
	}

	# Load data from each source
	lapply(sources, loader)

}
