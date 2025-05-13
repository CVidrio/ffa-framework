library(glue)

# Helper function to load a data file
load <- function(data_dir, file_name, window_length = 10, window_step = 5) {

	# Read the data file
	df <- read.csv(glue("{data_dir}/{file_name}"))

	# Remove leading and trailing NaN values 
	idx <- which(!is.na(df$max))
	df <- df[min(idx):max(idx), ]

	# Convert year to a numeric column
	df$year <- as.numeric(df$year)

	# Create df_clean, which contains no NA values
	df_clean <- df[which(!is.na(df$max)), ]

	# Create df_variance, which contains the variances of the AMS data
	std_series <- c()
	year_series <- c()
	n <- nrow(df)
	i <- 1

	# Iterate through all the windows
	while ((i + window_length - 1) <= n) {

		# Get the window from the data frame, increment i
		window <- df[i:(i + window_length - 1), ]
		i <- i + window_step

		# Compute the standard deviation within the window, add it to std_series
		std <- sd(window$max, na.rm = TRUE)
		std_series <- c(std_series, std)

		# Compute the mean within the window, add it to year_series
		avg_year <- mean(window$year, na.rm = TRUE)
		year_series <- c(year_series, avg_year)
	}

	df_variance <- data.frame(year = year_series, std = std_series)

	# Return df, df_clean, and df_variance as a list
	mget(c("df", "df_clean", "df_variance"))

}

