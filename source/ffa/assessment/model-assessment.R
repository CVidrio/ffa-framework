model_assessment <- function(ams, distribution, params, uncertainty, alpha = 0.05) {

	# Compute plotting positions using Weibull formula 
	n <- length(ams)                          # Number of data points
	x <- ams[order(ams, decreasing = TRUE)]   # Ordered data
	p_empirical <- (1:n) / (n + 1)            # Empirical exceedance probabilities
	t_return <- 1 / p_empirical               # Estimated return times

	# Compute the R2, RMSE, and Bias
	estimates <- distribution$quantile(1 - p_empirical, params)
	R2 <- summary(lm(estimates ~ x))$r.squared
	RMSE <- sqrt(mean((estimates - x)^2))
	Bias <- mean(estimates - x)

	# Compute the AIC and BIC
	AIC <- n * log(RMSE) + (2 * distribution$n_params)
	BIC <- n * log(RMSE) + (log(n) * distribution$n_params)

	# Interpolate confidence intervals at empirical return periods
	ci_lower <- approx(log(uncertainty$t), uncertainty$ci_lower, log(t_return))
	ci_upper <- approx(log(uncertainty$t), uncertainty$ci_upper, log(t_return))
	w <- ci_upper$y - ci_lower$y

	# Compute the AW, POC, and CWI
	AW <- mean(w, na.rm = TRUE)
	POC <- (sum(x < ci_upper$y & x > ci_lower$y, na.rm = TRUE) / sum(!is.na(w))) * 100
	CWI <- AW * exp((1 - alpha) - (POC / 100))^2

	# Return assessment results in a list
	mget(c("estimates", "R2", "RMSE", "Bias", "AIC", "BIC", "AW", "POC", "CWI"))

}
