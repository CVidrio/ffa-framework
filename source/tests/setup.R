# Get the data path from the environment options
data_path <- getOption("data_folder", default = "../../data")

# Load CSV files in the data path
data1 <- load(data_path, "Application_1.csv")
data2 <- load(data_path, "Application_2.csv")
data3_1 <- load(data_path, "Application_3.1.csv")
data3_2 <- load(data_path, "Application_3.2.csv")
data3_3 <- load(data_path, "Application_3.3.csv")

# Basic configuration file list without errors
config <- list(
	data_folder = "~/Code/ffa-framework/data",
	csv_files = as.character(c("Application_1.csv", "Application_2.csv")),
	report_folder = "~/Code/ffa-framework/reports",
	mode = "manual",
	split_points = as.integer(c(1950, 1980)),
	alpha = 0.05,
	bbmk_repetitions = as.integer(10000),
	window_length = as.integer(10),
	window_step = as.integer(5),
	show_trend = TRUE,
	generate_report = TRUE,
	report_format = c("md_document", "html_document")
)

