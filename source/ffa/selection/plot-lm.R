library(ggplot2)
library(ggmagnify)
library(gridExtra)
library(glue) 
library(patchwork)

# Source the plot theme (working directory is /source)
source("helpers/plot-theme.R")

plot_lm <- function(metric, results, slm, dlm) {

	# Load the distribution selection results into the environment
	list2env(results, env = environment())

	# Create a dataframe for the sample L-moments
	lm <- data.frame(x = slm$lm$t3, y = slm$lm$t4)
	log_lm <- data.frame(x = slm$log_lm$t3, y = slm$log_lm$t4) 

	# Convert each matrix in dlm into a list
	dlm <- lapply(dlm, function(mat) {
	  as.data.frame(mat, col.names = c("x", "y")) |> setNames(c("x", "y"))
	})

	# Initilaize the color palette
	labels <- c("Sample", "Log-Sample", "GEV/GUM", "GLO", "GNO/NOR/LNO", "PE3/LP3", "WEI", "GPA")
	colors <- c("#000000", "#000000", "#e69f00", "#56b4e9", "#009e73", "#0072b2", "#d55e00", "#cc79a7")
	shapes <- c(24, 15, 16, NA, 16, NA, NA, NA)

	# Define labels for the plot 
	x_label <- expression("L-skewness (" * tau[3] * ")")
	y_label <- expression("L-kurtosis (" * tau[4] * ")")
	title <- glue("'{metric}' Distribution Selection")

	# Generate the plot
	p1 <- ggplot(mapping = aes(x, y)) +
		geom_line(data = dlm$GEV, aes(color = "3", shape = "3"), linewidth = 1) + 
		geom_line(data = dlm$GLO, aes(color = "4", shape = "4"), linewidth = 1) + 
		geom_line(data = dlm$GNO, aes(color = "5", shape = "5"), linewidth = 1) + 
		geom_line(data = dlm$PE3, aes(color = "6", shape = "6"), linewidth = 1) + 
		geom_line(data = dlm$WEI, aes(color = "7", shape = "7"), linewidth = 1) + 
		geom_line(data = dlm$GPA, aes(color = "8", shape = "8"), linewidth = 1) +
		geom_point(data = dlm$GUM, aes(color = "3", shape = "3"), size = 4) + 
		geom_point(data = dlm$NOR, aes(color = "5", shape = "5"), size = 4) +
		geom_point(data = lm, aes(color = "1", shape = "1"), size = 5, fill = "black") +
		geom_point(data = log_lm, aes(color = "2", shape = "2"), size = 5) +
		scale_color_manual(labels = labels, values = colors) +
		scale_shape_manual(labels = labels, values = shapes) +
		labs(x = x_label, y = y_label, title = title, color = NULL, shape = NULL) +
		coord_fixed(ratio = 2, xlim = c(-0.7, 0.7), ylim = c(0, 0.7))

	# Add the theme
	p1 <- add_theme(p1)

	# If the metric is l-distance or l-kurtosis, draw a line to show the distance
	if (metric == "L-distance" | metric == "L-kurtosis") {

		# Get the sample point with the shortest distance from a distribution
		point <- if (results$recommendation %in% c("LNO", "LP3")) log_lm else lm

		# Plot a line from the sample point to the distribution function
		df <- results$distance[[ results$recommendation ]]
		p1 <- p1 + geom_segment(data = point, aes(xend = df$t3, yend = df$t4))

		# Add a magnified section to the plot
		r <- min(df$metric) * 3
		p1 <- p1 + geom_magnify(
			data = point,
			from = c(point$x - r, point$x + r, point$y - r, point$y + r),
			to = c(-0.25, 0.25, 0.35, 0.60),
			shape = "ellipse"
		) 

	} 

	# Move the legend to the bottom
	p1 <- p1 + theme(legend.position = "bottom", legend.direction = "horizontal")

	# Create summary dataframe of the results 
	summary <- data.frame(
		Distribution = names(results$distance), 
		Metric = sapply(results$distance, function(x) round(x$metric, 4))
	) 

	# Order the summary dataframe by the metric
	summary <- summary[ order(abs(summary$Metric)), ]

	# Create a table
	table <- tableGrob(summary, rows = NULL, theme = ttheme_minimal(base_size = 14))

	# Add the summary table and a title
	(wrap_elements(full = p1) + wrap_elements(full = table)) +
		plot_layout(widths = c(0.75, 0.25), guides = "collect")

}
