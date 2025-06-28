library(tools)
library(glue)

# Load ffaframework library
suppressMessages(library(ffaframework))

# Source all helper functions
files <- list.files("source/helpers/", full.names = TRUE)
for (f in files) { source(f) }

# Temporary hack for testing
options <- validate.config("config.yml")

# Load data from the specified source
df <- load.data(options$data_source, options$csv_files, options$station_ids)[[1]]

# Get data and years from df
data <- df$max
years <- df$year

# Initialize a big list of results.
results <- list()


### CHANGE POINTS ###


# If split points are preset, skip this section.
if (options$split_selection != "Preset") {

	# Get change points.
	change_points <- change.points(data, years, options)
	results[[length(results) + 1]] <- change_points

	# If change points are found, either automatically split or prompt the user.
	# if (change_points$pettitt$reject && change_points$mks$reject) {
			
	# } else if (change_points$pettitt$reject) {

	# } else if (change_points$mks$reject) {

	# }

	# Run second round of change points. Then either split/prompt the user again.
	# for (point in split_points) {
	# 	secondary_change_points <- change.points()
	# }

}

# Temporary hack for testing
periods <- list(c(min(years), max(years) + 1))


### TREND DETECTION ###


# If run_eda: FALSE, skip this section 
if (options$run_eda) {

	# Initialize a list of signatures for each period
	signatures <- c()
	
	# Iterate through the homogeneous periods
	for (period in periods) {

		# Run trend detection and add to results
		trend_detection <- trend.detection(
			data,
			years,
			options,
			period[1],
			period[2]
		)

		results[[length(results) + 1]] <- trend_detection

		# Add the signature for this period to the list
		if ("sens_variance" %in% names(trend_detection)) {
			signatures <- c(signatures, "11")
		} else if ("sens_mean" %in% names(trend_detection)) {
			signatures <- c(signatures, "10")
		} else {
			signatures <- c(signatures, list(NULL))
		}

	}

}


### FLOOD FRQUENCY ANALYSIS ###


# If run_ffa: FALSE, skip this section
if (options$run_ffa) {

	# Run frequency analysis on each homogeneous period
	for (i in 1:length(periods)) {

		# Run frequency analysis and add to results
		frequency_analysis <- frequency.analysis(
			data, 
			years,
			options,
			signatures[[i]],
			periods[[i]][1],
			periods[[i]][2]
		)

		results[[length(results) + 1]] <- frequency_analysis

	}

}


### IMAGE GENERATION ###


# Create the report directory if it doesn't exist
csv_name <- file_path_sans_ext(options$csv_files)
report_dir <- glue("reports/{csv_name}")
if (!dir.exists(report_dir)) dir.create(report_dir)

# Create the image directory if it doesn't exist
img_dir <- glue("{report_dir}/img")
if (!dir.exists(img_dir)) dir.create(img_dir)

# Iterate through the results
for (entry in results) {

	for (name in names(entry)) {

		result <- entry[[name]]

		# Get the model for the uncertainty plot
		if ("uncertainty" %in% names(entry)) {
			model <- entry$selection$recommendation
		}

		# Pass entry$item to plotting function
		plot <- switch(
			name,
			assessment = assessment.plot(data, result),
			bbmk = bbmk.plot(result),
			selection = lmom.plot(data, result),
			mks = mks.plot(data, years, result, options$show_trend),
			pettitt = pettitt.plot(data, years, result, options$show_trend),
			runs_mean = runs.plot(years, result, "mean"),
			runs_variance = runs.plot(years, result, "variance"),
			sens_mean = sens.plot(data, years, result, "mean", options$show_trend),
			sens_variance = sens.plot(data, years, result, "variance", options$show_trend),
			spearman = spearman.plot(result),
			uncertainty = uncertainty.plot(model, result)
		)

		# Save plot to a file
		img_name <- glue("{name}-{entry$start}-{entry$end}.png")
		img_path <- glue("{img_dir}/{img_name}")
		ggsave(img_path, plot = plot, height = 8, width = 10, dpi = 300)

	}
}


### REPORT GENERATION ###


# If report generation is disabled, stop.
if (!options$generate_report) stop()

# Generate a report
rmarkdown::render(
	"source/templates/report-master.Rmd",
	params = list(results = results, file = csv_name),
	output_format = "html_document",
	output_dir = report_dir,
	quiet = TRUE
)

# for (format in options$report_formats) {
# 	report <- switch(
# 		format,	
# 		"html" = report.html(results),
# 		"pdf" = report.pdf(results),
# 		"markdown" = report.pdf(results),
# 		"json" = report.json(results)
# 	)

# 	# Save report to a file

# }


