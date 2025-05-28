model_assessment <- function(ams, distribution, estimation_results, uncertainty_results, alpha = 0.05) {

	# Compute plotting positions using Weibull formula 
	n <- length(ams)                          # Number of data points
	x <- ams[order(ams, decreasing = TRUE)]   # Ordered data
	p_empirical <- (1:n) / (n + 1)            # Empirical exceedance probabilities
	t_return <- 1 / p_empirical               # Estimated return times

	# Get the quantile functions for each distribution
	qfuncs <- list(
		GEV = quagev,
		GUM = quagum,
		NOR = quanor,
		LNO = quanor,
		GLO = quaglo,
		PE3 = quape3,
		LP3 = quape3,
		GNO = quagno,
		WEI = quawei,
		GPA = quagpa
	)

	# Compute the R2, RMSE, and Bias
	estimates <- qfuncs[[ distribution ]](1 - p_empirical, estimation_results)
	R2 <- summary(lm(estimates ~ x))$r.squared
	RMSE <- sqrt(mean((estimates - x)^2))
	Bias <- mean(estimates - x)

	# Get the number of parameters for each distribution
	nparams <- list(
		GEV = 3,
		GUM = 2,
		NOR = 2,
		LNO = 2,
		GLO = 3,
		PE3 = 3,
		LP3 = 3,
		GNO = 3,
		WEI = 3,
		GPA = 3
	)

	# Compute the AIC and BIC
	AIC <- n * log(RMSE) + (2 * nparams[[ distribution ]])
	BIC <- n * log(RMSE) + (log(n) * nparams[[ distribution ]])

	# Interpolate confidence intervals at empirical return periods
	ci_lower <- approx(log(uncertainty_results$t), uncertainty_results$ci_lower, log(t_return))
	ci_upper <- approx(log(uncertainty_results$t), uncertainty_results$ci_upper, log(t_return))
	w <- ci_upper$y - ci_lower$y

	# Compute the AW, POC, and CWI
	AW <- mean(w, na.rm = TRUE)
	POC <- (sum(x < ci_upper$y & x > ci_lower$y, na.rm = TRUE) / sum(!is.na(w))) * 100
	CWI <- AW * exp((1 - alpha) - (POC / 100))^2

	# Return assessment results in a list
	mget(c("estimates", "R2", "RMSE", "Bias", "AIC", "BIC", "AW", "POC", "CWI"))

}
