library(lmom)

# Parameter estimation using the method of L-moments
l_moments <- function(ams) {

	# Helper function for computing LP3 moments (copied from MATLAB code)
	pellp3 <- function(log_lm) {

		# Unpack Log L-moments
		l1 <- log_lm["l_1"]
		l2 <- log_lm["l_2"]
		t3 <- log_lm["t_3"]

		if (abs(t3) < (1/3)) {
            z = 3 * pi * t3^2
            alpha = (1 + 0.2906 * z) / (z + 0.1882 * z^2 + 0.0442 * z^3)
		} else {
            z = 1 - abs(t3)
			A1 <- (0.36067 * z - 0.59567 * z^2 + 0.25361 * z^3)
			A2 <- (1 - 2.78861 * z + 2.56096 * z^2 - 0.77045 * z^3)
            alpha = A1 / A2
		}

		# Skewness function is copied from MATLAB implementation of "skewness" function
        if (is.infinite(gamma(alpha))) {
			skewness <- function(x) sqrt(length(x)) * sum((x - mean(x))^3) / sum((x - mean(x))^2)^(3/2)
			theta <- c(mean(log(ams)), sd(log(ams)), skewness(log(ams)))
		} else {
			T2 <- l2 * pi^(1/2) * alpha^(1/2) * gamma(alpha) / gamma(alpha + 1/2)
			theta <- c(l1, T2, 2 * alpha^(-1/2) * sign(t3))
		}
	
		return(theta)
	}

	# Get the sample L-moments
	lm <- samlmu(ams)
	log_lm <- samlmu(log(ams))

	# Estimate the parameters using the method of L-moments
	list(
		GEV = unname(pelgev(lm)),
		GUM = unname(pelgum(lm)),
		NOR = unname(pelnor(lm)),
		LNO = unname(pelln3(lm, bound = 0)),
		GLO = unname(pelglo(lm)),
		PE3 = unname(pelpe3(lm)),
		LP3 = unname(pellp3(log_lm)),
		GNO = unname(pelgno(lm)),
		WEI = unname(pelwei(lm, bound = 0)),
		GPA = unname(pelgpa(lm))
	)

}
