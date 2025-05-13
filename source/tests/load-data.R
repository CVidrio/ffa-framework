library(yaml) 
library(glue)

# Helper function to load a data file
load <- function(file_name) {
	
	# Load the config file into the environment
	config <- yaml::read_yaml("../config.yml")
	list2env(config, envir = environment())

	# Load data from the given input file and remove null values
	df <- read.csv(glue("{data_dir}/{file_name}"))
	df <- df[!is.na(df$max), ]

}

