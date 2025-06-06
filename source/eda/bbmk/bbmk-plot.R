library(ggplot2)

# Source the plot theme (path is relative to /source)
source("helpers/plot-theme.R")

# Plot the results of the BB-MK test for abrupt changes in the mean
bbmk_plot <- function(df, results, show_trend) {

	# Load the results of the test into the environment
	list2env(results, envir = environment())

	# First subplot: Spearman's Rho Autocorrelation
	p1 <- ggplot() +
		geom_histogram(
			aes(x = s_bootstrap, color = "gray"), 
			fill = "lightgray",
			bins = 30
		)  +
		geom_vline(aes(xintercept = bounds, color = "red"), linewidth = 1.2) + 
		geom_vline(aes(xintercept = s_statistic, color = "black"), linewidth = 1.2) + 
		labs(
			title = "Block-Bootstrap Mann-Kendall Test",
			x = "S-Statistic",
			y = "Frequency",
			color = "Legend"
		) + 
		scale_color_manual(
			values = c("gray" = "gray", "black" = "black", "red" = "red"),
			breaks = c("gray", "black", "red"),
			labels = c("Bootstrapped Statistics", "S-Statistic", "Confidence Bounds"),
		)

	# Return the plot with added theme
	add_theme(p1)

}

