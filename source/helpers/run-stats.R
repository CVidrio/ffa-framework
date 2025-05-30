# Runs a statistical function given the following arguments:
# - name: The name of the statistical function
# - data: A list of dataframes (df, df_clean, df_variance)
# - start: The first year in the split
# - end: The last year in the split
# - img_path: A path to save the image
run_stats <- function(name, data, start, end, img_path, quiet = TRUE) {

	# Print an informational messsage
	if (!quiet) message(glue("\n\nRunning '{name}' on data from {start} to {end}.\n\n"))

	# Set the prefix (folder name) and suffix ('test' or 'estimator')
	prefix <- ifelse(grepl("sens", name), "sens", name)
	suffix <- ifelse(grepl("sens", name), "estimator", "test")

	# Get the paths of the files containing the test and plot functions
	test_path <- glue("eda/{prefix}/{prefix}-{suffix}.R")
	plot_path <- glue("eda/{prefix}/{prefix}-plot.R")

	# Get the names of the test function and plot function
	test_function <- glue("{prefix}_{suffix}")
	plot_function <- glue("{prefix}_plot")

	# Subset the dataframes on the start and end arguments
	sb_mean <- subset(data$df_clean, year >= start & year <= end)
	sb_variance <- subset(data$df_variance, year >= start & year <= end)

	# Execute the statistical test
	test_args <- list(
		"bbmk"          = list(sb_mean$max, alpha = alpha, n_sim = bbmk_repetitions),
		"kpss"          = list(sb_mean$max, alpha = alpha),
		"mk"            = list(sb_mean$max, alpha = alpha),
		"mks"           = list(sb_mean$max, sb_mean$year, alpha = alpha),
		"mwmk"          = list(sb_variance$std, alpha = alpha),
		"pettitt"       = list(sb_mean$max, sb_mean$year, alpha = alpha),
		"pp"            = list(sb_mean$max, alpha = alpha),
		"spearman"      = list(sb_mean$max, alpha = alpha),
		"white"         = list(sb_mean$max, sb_mean$year, alpha = alpha),
		"sens-mean"     = list(sb_mean$max, sb_mean$year, alpha = alpha),
		"sens-variance" = list(sb_variance$std, sb_variance$year, alpha = alpha)
	)
	
	# Run the statistical test
	source(test_path)
	args <- c(list(quiet = quiet), test_args[[name]])
	result <- do.call(get(test_function), args)

	# Define arguments for plotting function, handling edge case for Sen's estimator
	plot_args <- if (name == "sens-mean") {
		list(sb_mean, result, name, show_trend)
	} else if (name == "sens-variance") {
		list(sb_variance, result, name, show_trend)
	} else {
		list(sb_mean, result, show_trend)
	}

	# Generate and save the plot to disk if a plotting function exists
	if (!file.exists(plot_path)) return (result)

	# Source the plot function and generate the figure
	source(plot_path)
	img <- do.call(get(plot_function), plot_args)

	# Save the plot to disk
	name <- glue("{name}-{suffix}-{start}-{end}.png")
	ggsave(name, plot = img, path = img_path, width = 10, height = 8, bg = "white")
	if (!quiet) message(glue("\n\nFigure {name} generated successfully."))

	# Return the result
	result

} 
