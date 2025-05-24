library(lmom)

source("models/selection/sample-l-moments.R")

# Adapted from https://rdrr.io/cran/homtest/man/KAPPA, since 'homtest' is deprecated.
#  - par.kappa.R
# A collection of homogeneity tests described in: Viglione A., Laio F., Claps P. (2007)
#  - doi: 10.1029/2006WR005095

par.kappa <- function(lambda1, lambda2, tau3, tau4) {

    sumquad.tau3tau4 = function (k.h,t3.t4) {

		k <- k.h[1]
		h <- k.h[2]
		t3 <- t3.t4[1]
		t4 <- t3.t4[2]

		if (((k < -1) && (h >= 0)) || ((h < 0) && ((k <= -1) || (k >= -1/h)))) {
			stop("L-moments are defined if h>=0 and k>-1, or if h<0 and -1<k<-1/h")
		}

		g <- c(0,0,0,0)

		# GEV
		if (h == 0) {
			tau3 <- 2*(1 - 3^(-k))/(1 - 2^(-k)) - 3
			tau4 <- (5*(1 - 4^(-k)) - 10*(1 - 3^(-k)) + 6*(1 - 2^(-k)))/(1 - 2^(-k))
		}

		else {
			for (r in 1:4) {
				if (h > 0) {
					g[r] <- (r*gamma(1+k)*gamma(r/h)) / (h^(1+k) *gamma(1+k+r/h))
				}
				else {
					g[r]=(r*gamma(1+k)*gamma(-k-r/h)) / ((-h)^(1+k) *gamma(1-r/h))
				}
		  	}

		    tau3 <- (-g[1] + 3*g[2] -2*g[3])/(g[1]-g[2])
		    tau4 <- -(-g[1] + 6*g[2] -10*g[3] + 5*g[4])/(g[1]-g[2])
		}

		(t3-tau3)^2 + (t4-tau4)^2

	}

    xi.alfa = function (lambda1, lambda2, k, h) {

		if (((k < -1) && (h >= 0)) || ((h < 0) && ((k <= -1) || (k >= -1/h)))) {
			stop("L-moments are defined if h>=0 and k>-1, or if h<0 and -1<k<-1/h")
		}

		g <- c(0,0)

    	# GEV
		if (h == 0) {
		    alfa <- (lambda2*k)/((1 - 2^(-k))*gamma(1+k))
		    xi <- lambda1 - alfa*(1 - gamma(1+k))/k
		}

		else {
			for (r in 1:2) {
				if (h > 0) {
					g[r] <- (r*gamma(1+k)*gamma(r/h)) / (h^(1+k) *gamma(1+k+r/h))
			  	}
			  	else {
					g[r]=(r*gamma(1+k)*gamma(-k-r/h)) / ((-h)^(1+k) *gamma(1-r/h))
			  	}
			}

  		    alfa <- (lambda2*k)/(g[1]-g[2])
  		    xi <- lambda1 - alfa*(1-g[1])/k
		}

    	list(xi = xi, alfa = alfa)
    }

    minimo <- optim(c(1,1),sumquad.tau3tau4,t3.t4=c(tau3,tau4))
    if (minimo$value != -1) {
        k <- minimo$par[1]
        h <- minimo$par[2]
        pp <- xi.alfa(lambda1,lambda2,k,h)
        xi <- pp$xi
        alfa <- pp$alfa
    }

	list(xi = xi, alfa = alfa, k = k, h = h)

}

# Select a distribution using the l-distance method
#  - ams is a vector of streamflow data without NA values
z_statistic <- function(ams) {
	
	# Get the L-moments for the given dataset
	slm <- sample_l_moments(ams)
	lm <- slm$lm
	log_lm <- slm$log_lm

	# Fit the Kappa distribution using the L-moments
	params <- par.kappa(1, lm$t2, lm$t3, lm$t4)
	log_params <- par.kappa(1, log_lm$t2, log_lm$t3, log_lm$t4)

	# Initialize lists of bootstrapped L-moments
	n_sim <- 100000
	t4_sim <- vector("numeric", n_sim)
	log_t4_sim <- vector("numeric", n_sim)

	# Compute bootstrapped L-moments
	for (i in 1:n_sim) {

		# Use ITS to get a random sample from the fitted Kappa distribution
		p <- runif(length(ams))	
		x <- quakap(p, as.numeric(params))
		log_x <- quakap(p, as.numeric(log_params))

		# Compute the L-moments and add them to bootstrap and log_bootstrap
		t4_sim[i] <- sample_l_moments(x)$lm$t4
		log_t4_sim[i] <- sample_l_moments(log_x)$lm$t4

	}

	# Compute summary statistics for the bootstrap
	b4 <- sum(t4_sim - lm$t4) / n_sim
	log_b4 <- sum(log_t4_sim - log_lm$t4) / n_sim
	s4 <- (sum((t4_sim - lm$t4)^2 - b4^2) / (n_sim - 1))^(1/2)
	log_s4 <- (sum((log_t4_sim - log_lm$t4)^2 - log_b4^2) / (n_sim - 1))^(1/2)

	# Helper function for generating and comparing a vector of L-moments
	#  - f_lmr is the likelihood moment ratio function from the 'lmom' library
	#  - k_start and k_end define bounds on the kappa (shape) distribution parameter 
	#  - t3_data and t4_data are likelihood moment ratios derived from the data 
	get_minimum_distance <- function(f_lmr, k_start, k_end, log = FALSE) {

		if (!log) {
			t3_data <- lm$t3
			t4_data <- lm$t4
			b4_data <- b4
			s4_data <- s4
		} else {
			t3_data <- log_lm$t3
			t4_data <- log_lm$t4
			b4_data <- log_b4
			s4_data <- log_s4
		}

		# Generate a sequence of parameter sets to pass to a 3-parameter distribution 
		params <- lapply(seq(k_start, k_end, 0.001), function(i) c(0, 1, i))

		# Get a vector of likelihood moment ratios for each parameterss set in params 
		lmr <- lapply(params, function(p) suppressWarnings(f_lmr(p, nmom = 4)))
		t3_dist <- unname(sapply(lmr, `[`, 3))
		t4_dist <- unname(sapply(lmr, `[`, 4))
			
		# Get the distance between distribution L-kurtosis and sample L-kurtosis
		t4_interp <- suppressWarnings(approx(t3_dist, t4_dist, t3_data)$y)

		# Return the z_distance using the bootstrap statistics 
		(t4_interp - t4_data + b4_data) / s4_data

	}

 	# Generate a list containing the distances for each distribution
	z_distance <- list(
		GEV = get_minimum_distance(lmrgev, -0.999, 9),
		GLO = get_minimum_distance(lmrglo, -0.999, 0.999),
		PE3 = get_minimum_distance(lmrpe3, -1, 10),
		LP3 = get_minimum_distance(lmrpe3, -1, 10, log = TRUE),
		GNO = get_minimum_distance(lmrln3, 0.001, 10),
		WEI = get_minimum_distance(lmrwei, 0.001, 10),
		GPA = get_minimum_distance(lmrgpa, -1, 45)
	)

	bootstrap <- mget(c("b4", "log_b4", "s4", "log_s4"))
	mget(c("params", "log_params", "bootstrap", "z_distance"))
}


