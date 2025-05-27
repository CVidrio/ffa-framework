library(lmom)

# Parameter estimation using the method of L-moments
l_moments <- function(ams, distribution) {

	# Helper function for computing LP3 moments (copied from MATLAB code)
	pellp3 <- function(log_lm) {

		# Unpack Log L-moments
		l1 <- log_lm["l_1"]
		l2 <- log_lm["l_2"]
		t3 <- log_lm["t_3"]

		if (abs(t3) > 0 & abs(t3) < (1/3)) {
            z <- 3 * pi * t3^2
            alpha <- (1 + 0.2906 * z) / (z + 0.1882 * z^2 + 0.0442 * z^3)
		} else {
            z = 1 - abs(t3)
			A1 <- (0.36067 * z - 0.59567 * z^2 + 0.25361 * z^3)
			A2 <- (1 - 2.78861 * z + 2.56096 * z^2 - 0.77045 * z^3)
            alpha <- A1 / A2
		}

		# Skewness function is copied from MATLAB implementation of "skewness" function
        if (is.infinite(gamma(alpha))) {
			S1 <- sqrt(length(ams)) * sum((ams - mean(ams))^3)
			S2 <- sum((ams - mean(ams))^2)^(3/2)
			skewness <- S1 / S2
			theta <- c(mean(log(ams)), sd(log(ams)), skewness)
		} else {
			T1 <- l1
			T2 <- l2 * pi^(1/2) * alpha^(1/2) * gamma(alpha) / gamma(alpha + 1/2)
			T3 <- 2 * alpha^(-1/2) * sign(t3)
			theta <- c(T1, T2, T3)
		}
	
		return(theta)
	}

	# Estimate the parameters using the method of L-moments
	switch(
		distribution,
		GEV = unname(pelgev(samlmu(ams))),
		GUM = unname(pelgum(samlmu(ams))),
		NOR = unname(pelnor(samlmu(ams))),
		LNO = unname(pelln3(samlmu(ams), bound = 0)),
		GLO = unname(pelglo(samlmu(ams))),
		PE3 = unname(pelpe3(samlmu(ams))),
		LP3 = unname(pellp3(samlmu(log(ams)))),
		GNO = unname(pelgno(samlmu(ams))),
		WEI = unname(pelwei(samlmu(ams), bound = 0)),
		GPA = unname(pelgpa(samlmu(ams)))
	)
}
