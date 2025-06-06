library(lmom)
library(parallel)


#' Perform Z-statistic bootstrap for a group of distributions
#'
#' @param distributions List of candidate distributions with moment data
#' @param data Numeric vector of data (raw or log-transformed)
#' @param sample_moments L-moment list for the sample
#' @param n_sim Number of bootstrap iterations
#' @return List with fitted parameters, bias, SD, and distance metrics

z_bootstrap <- function(distributions, data, sample_moments, n_sim) {

	# Fit Kappa distribution to the data
	kappa_params <- tryCatch(
		unname(pelkap(samlmu(data))),
		error = function(e) { 
			message("Kappa fitting failed: ", conditionMessage(e))
			NULL
		}
	)

	# If parameter fitting failed, return early
	if (is.null(kappa_params)) {
		return (list(params = NULL, bias_t4 = NULL, sd_t4 = NULL, metrics = NULL))
	}
	
	# Compute bootstrapped L-moments using ITS on the fitted Kappa distribution
	bootstrap_t4 <- sapply(1:n_sim, function(i) {
		u <- runif(length(data))	
		get_sample_lm(quakap(u, kappa_params))$lm$t4
	})

	# Compute bias and standard deviation of t4 estimates
	bias_t4 <- mean(bootstrap_t4 - sample_moments$t4)
	sd_t4 <- sqrt(mean((bootstrap_t4 - sample_moments$t4)^2) - bias_t4^2)

	# Calculate and return the z-score for each distribution
	metrics <- lapply(distributions, function(distribution) {
		model_moments <- distribution$moments
		t4 <- approx(model_moments$t3, model_moments$t4, sample_moments$t3)$y
		kappa <- approx(model_moments$t3, model_moments$k, sample_moments$t3)$y
		z <- (t4 - sample_moments$t4 + bias_t4) / sd_t4
		list(t3 = sample_moments$t3, t4 = t4, k = kappa, metric = z)
	})

	# Return the results
	list(params = kappa_params, bias_t4 = bias_t4, sd_t4 = sd_t4, metrics = metrics)
}

#' Z-Statistic Method for Distribution Selection
#'
#' Selects the best-fit distribution by computing a bias-corrected Z-statistic for the sample
#' \eqn{\tau_4} (L-kurtosis) against theoretical L-moment surfaces for a set of candidate
#' distributions. The distribution with the smallest absolute Z-score is selected.
#'
#' @param sample_moments A list with sample L-moments for both raw and log-transformed AMS data.
#' @param distributions Named list of candidate distribution specifications.
#' @param ams Numeric vector of annual maximum streamflow values (no missing values).
#' @param n_sim Number of bootstrap samples to generate (default = 100000).
#'
#' @return A list containing:
#' \describe{
#'   \item{params}{Kappa parameters fitted to the raw AMS data.}
#'   \item{log_params}{Kappa parameters fitted to the log-transformed AMS data.}
#'   \item{bootstrap}{List of bootstrap estimates of bias and standard deviation for \eqn{\tau_4}.}
#'   \item{distance}{List of computed Z-statistics and interpolated values for each candidate distribution.}
#'   \item{recommendation}{Name of the best-fit distribution based on the smallest Z-statistic.}
#' }
#'
#' @details
#' The method evaluates both raw and log-transformed data. Raw-data distributions include GEV,
#' GLO, PE3, GNO, WEI, and GPA. Log-data distributions include LP3. A Kappa distribution is
#' fitted to each and used to simulate bootstrapped L-moments. The observed \eqn{\tau_4} is then
#' compared to each theoretical distribution using the Z-statistic framework.
#'
#' @seealso \code{\link{l_distance}}, \code{\link{l_kurtosis}}, 
#'   \code{\link[lmom]{pelkap}}, \code{\link[lmom]{quakap}}
#'
#' @export

z_statistic <- function(sample_moments, distributions, ams, n_sim = 100000) {

	# Define lists of distributions for fitting data/log(data) respectiely 
	reg_dists <- distributions[c("GEV", "GLO", "PE3", "GNO", "WEI", "GPA")]
	log_dists <- distributions["LP3"]

	# Attempt to fit Kappa distribution to data/log(data) using the L-moments
	reg_bootstrap <- z_bootstrap(reg_dists, ams, sample_moments$lm, n_sim)
	log_bootstrap <- z_bootstrap(log_dists, log(ams), sample_moments$log_lm, n_sim)

	# Get the distribution with the best fit
	all_metrics <- c(reg_bootstrap$metrics, log_bootstrap$metrics) 
	z_scores <- sapply(all_metrics, function(d) d$metric)
	best_fit <- names(z_scores)[which.min(z_scores)]

	# Return the results as a list
	list(
		params = reg_bootstrap$params,
		log_params = log_bootstrap$params,
		bootstrap = list(
			bias_t4 = reg_bootstrap$bias_t4,
			sd_t4 = reg_bootstrap$sd_t4,
			log_bias_t4 = log_bootstrap$bias_t4,
			log_sd_t4 = log_bootstrap$sd_t4
		),
		distance = all_metrics,
		recommendation = best_fit
	)

}
