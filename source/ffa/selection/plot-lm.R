library(ggplot2)
library(ggmagnify)
library(glue) 

# Source the plot theme (working directory is /source)
source("helpers/plot-theme.R")

plot_lm <- function(metric, results, slm, distributions) {

	# Load the distribution selection results into the environment
	list2env(results, env = environment())

	# Create a dataframe for the sample L-moments
	lm <- data.frame(x = slm$lm$t3, y = slm$lm$t4)
	log_lm <- data.frame(x = slm$log_lm$t3, y = slm$log_lm$t4) 

	# Convert each moment list in distributions into a dataframe
	dlm <- lapply(distributions, function(d) {
		as.data.frame(d$moments, col.names = c("x", "y")) |> 
		setNames(c("x", "y")) |>
		subset(x >= -1 & x <= 1)
	})

	# Initilaize the legend information
	labels <- c("Sample", "Log-Sample", "GEV/GUM", "GLO", "GNO/NOR/LNO", "PE3/LP3", "WEI", "GPA")
	colors <- c("#000000", "#000000", "#e69f00", "#56b4e9", "#009e73", "#0072b2", "#d55e00", "#cc79a7")
	shapes <- c(24, 15, 16, NA, 16, NA, NA, NA)

	# Define labels for the plot 
	x_label <- expression("L-skewness (" * tau[3] * ")")
	y_label <- expression("L-kurtosis (" * tau[4] * ")")

	# Generate the plot
	p1 <- ggplot(mapping = aes(x, y)) +
		geom_line(data = dlm$GEV, aes(color = "3"), linewidth = 1) + 
		geom_line(data = dlm$GLO, aes(color = "4"), linewidth = 1) + 
		geom_line(data = dlm$GNO, aes(color = "5"), linewidth = 1) + 
		geom_line(data = dlm$PE3, aes(color = "6"), linewidth = 1) + 
		geom_line(data = dlm$WEI, aes(color = "7"), linewidth = 1) + 
		geom_line(data = dlm$GPA, aes(color = "8"), linewidth = 1) +
		geom_point(data = dlm$GUM, aes(color = "3"), shape = 16, size = 4) + 
		geom_point(data = dlm$NOR, aes(color = "5"), shape = 16, size = 4) +
		geom_point(data = lm, aes(color = "1"), shape = 24, size = 5, fill = "black") +
		geom_point(data = log_lm, aes(color = "2"), shape = 15, size = 5) +
		scale_color_manual(labels = labels, values = colors) +
		guides(color = guide_legend(override.aes = list(shape = shapes))) +
		labs(x = x_label, y = y_label, color = "Legend") +
		coord_fixed(ratio = 2, xlim = c(-0.7, 0.7), ylim = c(0, 0.7))

	# Add the theme
	p1 <- add_theme(p1)

	# If the metric is l-distance or l-kurtosis, draw a line to show the distance
	if (metric == "L-distance" | metric == "L-kurtosis") {

		# Get the sample point with the shortest distance from a distribution
		point <- if (results$recommendation %in% c("LNO", "LP3")) log_lm else lm

		# Get the closest point on the (t3, t4) curve
		df <- results$distance[[ results$recommendation ]]

		# Dynamically set the radius of the magnified section
		r <- min(df$metric) * 3

		# Add a line and a magnified section to the plot
		p1 <- p1 + 
			geom_segment(data = point, aes(xend = df$t3, yend = df$t4)) +
			geom_magnify(
				data = point,
				from = c(point$x - r, point$x + r, point$y - r, point$y + r),
				to = c(-0.25, 0.25, 0.35, 0.60),
				shape = "ellipse"
			)

	} 

	# Return the plot
	return (p1)

}
