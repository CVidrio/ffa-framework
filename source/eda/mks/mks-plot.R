library(ggplot2)
library(patchwork)

# Source the plot theme (working directory is /source)
source("helpers/plot-theme.R")


# Plot the results of the MKS test
mks_plot <- function(df_clean, result, show_trend) {

	# Load the values of result into the environment
	list2env(result, env = environment())

	# Create a dataframe for the bounds
	bound_df <- data.frame(y = c(-bound, bound))

	# Add the test statistics to df_clean
	df_clean$s_prog = s_prog
	df_clean$s_regr = s_regr

	# Define labels for the plot 
	ut_label <- "Normalized Trend Statistic"
	flow_label <- expression(AMS ~ m^3/s)
	series_labels <- c("Progressive Series", "Regressive Series")

	# Plot the normalized trend statistics and confidence bands
	p1 <- ggplot(df_clean, aes(x = year)) +
		geom_line(aes(color = "black", y = s_prog), linewidth = 1.2) +
		geom_line(aes(color = "gray",  y = s_regr), linewidth = 1.2) +
		geom_hline(
			data = bound_df,
			aes(yintercept = y, color = "red"),
			linewidth = 1.2,
			linetype = "dashed",
		) +
		geom_point(
			data = change_df,
			aes(y = statistic, color = "blue"), 
			size = 4
		) +
		labs(
			title = "Mann-Kendall-Sneyers Test",
			x = "Year",
			y = ut_label,
			color = "Legend"
		) +
		scale_color_manual(
			values = c("black" = "black","gray" = "gray","blue" = "blue","red" = "red"),
			breaks = c("black", "gray", "red", "blue"),
			labels = c(series_labels, "Confidence Bounds", "Potential Trend Change")
		)

	# Plot the change points on the original dataset
	p2 <- ggplot(df_clean, aes(x = year, y = max)) +
		geom_point(aes(color = "black"), size = 2.25) +
		(if (show_trend) geom_line(color = "black", linewidth = 1.1) else NULL) +
		geom_point(data = change_df, aes(y = max, color = "blue"), size = 4) +
		labs(x = "Year", y = flow_label, color = "Legend") +
		scale_color_manual(
			values = c("black" = "black", "blue" = "blue"),
			breaks = c("black", "blue"),
			labels = c(flow_label, "Potential Trend Change")
		)	

	# Stack plots on top of each other and return
	add_theme(p1) / add_theme(p2)
	
}

