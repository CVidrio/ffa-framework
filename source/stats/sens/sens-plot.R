library(ggplot2)
library(grid)
library(glue)

# Source the plot theme (path is relative to /source)
source("stats/plot-theme.R")

# Plot the results of Sen's trend estimator
sens_plot <- function(df, results, name, show_trend) {

	# Load the results of the test into the environment
	m <- results$sens_slope
	b <- results$sens_intercept
	p <- results$p_value

	# Set labels and data based on the name
	if (name == "sens-variance") {
		data <- df$std
		ams_label <- expression(AMS ~ Variance ~ m^3/s)
		title <- "Sen's Trend Estimator (AMS Variance)"
	} else {
		data <- df$max
		ams_label <- expression(AMS ~ m^3/s)
		title <- "Sen's Trend Estimator (AMS Mean)"
	}

	# Generate dataframes for the trend estimate, data, and residuals
	df_line <- data.frame(x = df$year, y = m * (df$year) + b)
	df_data <- data.frame(x = df$year, y = data)
	df_residuals <- data.frame(x = df$year, y = results$residuals)

	# Generate the equation and runs test label 
	eq_label <- glue("y = {round(m, 2)}x + {round(b, 2)}")
	runs_label <- glue("Runs p-value: {round(p, 3)}")

	# First subplot: Plot of Sen's trend estimator
	p1 <- ggplot(df_data, aes(x = x, y = y)) +
		geom_point(aes(color = "black"), size = 2.25) + 
		(if (show_trend) geom_line(color = "black", linewidth = 1.1) else NULL) +
		geom_line(data = df_line, aes(x = x, y = y, color = "blue"), linewidth = 1.2) + 
		labs(title = title, x = "Year", y = ams_label, color = "Legend") + 
		scale_color_manual(
			values = c("blue" = "blue", "black" = "black"),
			breaks = c("blue", "black"),
			labels = c("Estimated Trend", ams_label),
		) 

	# Add equation annotation
	p1 <- add_annotation(p1, eq_label)

	# First subplot: Plot of residuals
	p2 <- ggplot(df_residuals, aes(x = x, y = y)) +
		geom_point(color = "black", size = 2.25) + 
	    geom_hline(yintercept = 0, color = "red", linetype = "dashed", linewidth = 1.2) +
		labs(title = "Residual Plot", x = "Year", y = "Residual Value") 

	# Add equation annotation
	p2 <- add_annotation(p2, runs_label)

	# Return the plot with added theme
	add_theme(p1) / add_theme(p2)

}

 

