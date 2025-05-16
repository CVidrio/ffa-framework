library(ggplot2)
library(grid)

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

