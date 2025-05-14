library(ggplot2)
library(grid)

# Adds sensible axis scales and legend styling to a plot
add_theme <- function(p) {
	p +
	scale_x_continuous(breaks = scales::pretty_breaks(n = 10)) +
	scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) +
	theme_minimal() +
	theme(
		plot.title = element_text(size = 20, hjust = 0.5),
		plot.margin = margin(5, 15, 5, 15),
		axis.title = element_text(size = 16),
		axis.text = element_text(size = 12),
		panel.grid.minor = element_blank(),
		legend.title = element_text(hjust = 0.5),
		legend.background = element_rect(fill = "white", color = "black"),
		legend.box.background = element_rect(color = "black"),
		legend.direction = "vertical"
	)
}

# Adds nicely formatted annotation to the top right corner
add_annotation <- function(p, label) {

	grob <- textGrob(label)	
	width <- convertWidth(grobWidth(grob), "npc", valueOnly = TRUE)

	p + annotation_custom(
		grob = grobTree(
			rectGrob(
				x = 0.98 - (width / 2), y = 0.95, 
				hjust = 0.5, vjust = 0.5,
				width = grobWidth(grob) + unit(6, "pt"),
				height = grobHeight(grob) + unit(6, "pt"),
				gp = gpar(fill = "white", col = "black")
			), 
			textGrob(
				label, 
				x = 0.98 - (width / 2), y = 0.95, 
				hjust = 0.5, vjust = 0.5 ,
				gp = gpar(col = "black", fontsize = 10)
			)  
		),
		xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = Inf
	)

}
