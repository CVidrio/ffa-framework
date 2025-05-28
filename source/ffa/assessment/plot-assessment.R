library(ggplot2)
library(glue) 

# Source the plot theme (working directory is /source)
source("helpers/plot-theme.R")

plot_assessment <- function(ams, assessment) {

	# Load the assessment results into the environment
	list2env(assessment, env = environment())

	# Create a dataframe for the plot
	x <- ams[order(ams, decreasing = TRUE)]   
	df <- data.frame(x = x, y = x, estimates = estimates) 

	# Get labels for the plot
	x_label <- expression(Model ~ Quantiles ~ m^3/s)
	y_label <- expression(Observed ~ Quantiles ~ m^3/s)

	# Generate the plot
	p1 <- ggplot(data = df) +
		geom_line(aes(x = x, y = y), linewidth = 1.1) + 
		geom_point(aes(x = x, y = estimates), color = "red", size = 3, alpha = 0.5) + 
		labs(x = x_label, y = y_label)

	# Add the theme and return
	add_theme(p1)

}

