library(ggplot2)
library(glue)

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
		labs(x = x_label, y = y_label, linetype = "Legend")

	# Add the theme without plot-theme.R (since there is a different scale) and return
	p1 <- p1 + 
		scale_x_log10(breaks = df$t) +
		theme_minimal() +
		theme(
			plot.background = element_rect(fill = "white", color = NA),
			plot.margin = margin(5, 15, 5, 15),
			axis.title = element_text(size = 16),
			axis.text = element_text(size = 12),
			panel.grid.minor = element_blank(),
			legend.title = element_text(hjust = 0.5),
			legend.background = element_rect(fill = "white", color = "black"),
			legend.box.background = element_rect(color = "black"),
			legend.direction = "vertical"
		)


	return(p1)

}

