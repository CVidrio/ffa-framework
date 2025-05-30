library(lmom)

# Parameter estimation using the method of L-moments
l_moments <- function(ams, distribution) {
	distribution$estimate(ams)
}
