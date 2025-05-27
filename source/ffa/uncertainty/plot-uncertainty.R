library(ggplot2)
library(dplyr)
library(patchwork)
library(glue)

# Source the plot theme (working directory is /source)
source("helpers/plot-theme.R")

plot_uncertainty <- function(results, distribution) {

	# Load the distribution selection results into the environment
	list2env(results, env = environment())

	# Create a dataframe for the results
	df <- data.frame(
		t = results$t,
		ci_lower = results$ci_lower,
		ci_upper = results$ci_upper,
		estimates = results$estimates
	)

	# Define labels for the plot 
	x_label <- "Time (Years)"
	y_label <- expression("AMS (" * m^3/s * ")")
	title <- glue("Frequency Curve ({distribution})")

	# Define properties for the legend
	labels <- c("Confidence Bounds", "Estimates")
	styles <- c("dashed", "solid")

	# Generate the plot
	p1 <- ggplot(data = df, aes(x = t)) +
		geom_line(aes(y = ci_lower, linetype = "1"), color = "black", linewidth = 1) + 
		geom_line(aes(y = ci_upper, linetype = "1"), color = "black", linewidth = 1) + 
		geom_ribbon(aes(ymin = ci_lower, ymax = ci_upper), fill = "gray", alpha = 0.4) +
		geom_line(aes(y = estimates, linetype = "2"), color = "blue", linewidth = 1) +
		scale_linetype_manual(labels = labels, values = styles) +
		labs(x = x_label, y = y_label, title = title, linetype = NULL)

	# Add the theme and scale the x-axis
	p1 <- add_theme(p1) + scale_x_log10(breaks = df$t) 


	# Move the legend to the bottom
	p1 <- p1 + theme(legend.position = "bottom", legend.direction = "horizontal")

	# Mutate df so that it displays better
	df <- df[ , c("t", "estimates")] |> mutate(estimates = round(estimates, 2))
	names(df) <- c("Years", "Estimate")

	# Create a table
	table <- tableGrob(df, rows = NULL, theme = ttheme_minimal(base_size = 14))

	# Add the summary table and a title
	(wrap_elements(full = p1) + wrap_elements(full = table)) +
		plot_layout(widths = c(0.8, 0.2), guides = "collect")

}

