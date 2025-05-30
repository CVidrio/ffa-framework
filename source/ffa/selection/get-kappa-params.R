# This function estimates the shape parameters (k and h) of the Kappa distribution
# Adapted from the deprecated HOMTEST package: https://rdrr.io/cran/homtest/src/R/KAPPA.R
# tau3 and tau4 are sample L-moments, computed in get-sample-lm.R
get_kappa_params <- function(tau3, tau4) {

	# We want to minimize this function
	sumquad = function (k.h,t3.t4) {

		k <- k.h[1]
		h <- k.h[2]
		t3 <- t3.t4[1]
		t4 <- t3.t4[2]

		# Check for valid parameters
		if (((k < -1) && (h >= 0)) || ((h < 0) && ((k <= -1) || (k >= -1/h)))) {
			stop("L-moments are defined if h>=0 and k>-1, or if h<0 and -1<k<-1/h")
			return (-1)
		}

		g <- c(0,0,0,0)

		# If h == 0, we are in the Generalized Extreme Value (GEV) case
		if (h == 0) {
			tau3 <- 2*(1 - 3^(-k))/(1 - 2^(-k)) - 3
			tau4 <- (5*(1 - 4^(-k)) - 10*(1 - 3^(-k)) + 6*(1 - 2^(-k)))/(1 - 2^(-k))
		}

		# Otherwise, we are in the general case
		else {
			for (r in 1:4) {
				if (h > 0) {
					g[r] <- (r*gamma(1+k)*gamma(r/h)) / (h^(1+k) *gamma(1+k+r/h))
				} else {
					g[r]=(r*gamma(1+k)*gamma(-k-r/h)) / ((-h)^(1+k) *gamma(1-r/h))
				}
		  	}

			tau3 <- (-g[1] + 3*g[2] -2*g[3])/(g[1]-g[2])
			tau4 <- -(-g[1] + 6*g[2] -10*g[3] + 5*g[4])/(g[1]-g[2])
		}

		return ((t3 - tau3)^2 + (t4 - tau4)^2)
	}

	# Return with location (xi) = 0 and shape (alpha) = 1, since they don't matter.
	minimo <- optim(c(1,1), sumquad, t3.t4 = c(tau3, tau4))

	if (minimo$value != -1) {
		k <- minimo$par[1]
	  	h <- minimo$par[2]
		return (c(0, 1, k, h))
	} else {
		stop("An error occured in get-kappa-params.R")
		return (c(0, 1, 1, 1))
	}
}
