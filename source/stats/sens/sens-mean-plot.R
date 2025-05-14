library(ggplot2)

# Source the plot theme (path is relative to /source)
source("stats/plot-theme.R")

# Plot the results of the Mann-Whitney-Pettitt test for abrupt changes in the mean
sens_mean_plot <- function(df, results) {

	# Load the results of the test into the environment
	m <- results$sens_slope
	b <- results$sens_intercept
	df_line <- data.frame(x = df$year, y = m * (df$year) + b)
	df_residuals <- data.frame(x = df$year, y = results$residuals)

	# Generate the AMS label with proper formatting
	ams_label <- expression(AMS ~ m^3/s)

	# First subplot: Plot of Sen's trend estimator
	p1 <- ggplot() +
		geom_point(data = df, aes(x = year, y = max, color = "black")) + 
		geom_line(data = df_line, aes(x = x, y = y, color = "blue"), linewidth = 1.2) + 
		labs(
			title = "Sen's Trend Estimator (AMS Mean)",
			x = "Year",
			y = ams_label,
			color = "Legend"
		) + 
		scale_color_manual(
			values = c("black" = "black", "blue" = "blue"),
			breaks = c("black", "blue"),
			labels = c(ams_label, "Estimated Trend"),
		)

	# First subplot: Plot of residuals
	p2 <- ggplot(df_residuals, aes(x = x, y = y)) +
		geom_point(color = "black") + 
	    geom_hline(yintercept = 0, color = "red", linetype = "dashed", linewidth = 1.2) +
		labs(
			title = "Residual Plot",
			x = "Year",
			y = "Residual Value"
		) 

	# Return the plot with added theme
	add_theme(p1) / add_theme(p2)

}

 

