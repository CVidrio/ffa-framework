#' White Test for Heteroskedasticity in Annual Maximum Streamflow
#'
#' Performs the White test for heteroskedasticity by regressing the squared residuals of a linear
#' model on the original regressors and their squared terms. The null hypothesis is homoskedasticity.
#'
#' @param ams Numeric vector of annual maximum streamflow values with no missing values.
#' @param year Numeric vector of years corresponding to \code{ams}, with no missing values.
#' @param alpha Numeric significance level for the test (default is 0.05).
#' @param quiet Logical. If FALSE, prints a summary message to the console (default is TRUE).
#'
#' @return A named list containing:
#' \describe{
#'   \item{r_squared}{Coefficient of determination from the auxiliary regression.}
#'   \item{test_statistic}{White test statistic based on sample size and auxiliary \code{R^2}.}
#'   \item{p_value}{P-value computed from the Chi-squared distribution with 2 degrees of freedom.}
#'   \item{reject}{Logical. TRUE if the null hypothesis of homoskedasticity is rejected at \code{alpha}.}
#'   \item{msg}{Character string summarizing the test result (printed if \code{quiet = FALSE}).}
#' }
#'
#' @details
#' The White test regresses the squared residuals from a primary linear model \code{lm(ams ~ year)}
#' against both the original regressor and its square. The test statistic is calculated as
#' \code{n * R^2}, where \code{R^2} is from the auxiliary regression. Under the null hypothesis,
#' this statistic follows a \eqn{\chi^2} distribution with 2 degrees of freedom.
#'
#' Rejection of the null hypothesis suggests the presence of heteroskedasticity in the residuals.
#'
#' @references White, H. (1980). A heteroskedasticity-consistent covariance matrix estimator and a
#' direct test for heteroskedasticity. \emph{Econometrica}, 48(4), 817–838.
#'
#' @seealso \code{\link[stats]{lm}}, \code{\link[stats]{pchisq}}
#' @export

white_test <- function(ams, year, alpha = 0.05, quiet = TRUE) {

	# Do a linear regression of ams against year, get the squared residuals
	primary_model <- lm(ams ~ year)
	squared_residuals <- resid(primary_model)^2

	# Fit an auxillary model to the squared residuals, get the R^2 statistic
	auxillary_model <- lm(squared_residuals ~ year + I(year^2))
	r_squared <- summary(auxillary_model)$r.squared

	# Compute the test statistic and p-value
	test_statistic <- length(ams) * r_squared

	# NOTE: The Chi-squared distribution used to compute the p-value has 2 
	# degrees of freedom because we are using 2 regressors (year and year^2). 
	# See the documentation for more information.
	p_value <- 1 - pchisq(test_statistic, df = 2)

	# Determine whether we reject or fail to reject based on p_value and alpha
	reject <- (p_value <= alpha)

	# Print the results of the test
	part1 <- ifelse(reject, "reject", "fail to reject")
	part2 <- ifelse(reject, "heteroskedasticity", "homoskedasticity")

	lines <- c(
		"The White test yielded a p-value of {round(p_value, 3)}.",
		"At a significance level of {alpha}, we {part1} the null hypothesis.",
		"Therefore, there is evidence of {part2}."
	)

	msg <- glue(paste0("\n - ", lines, collapse = ""))
	if (!quiet) message(msg)

	# Return the results of the test
	mget(c("r_squared", "test_statistic", "p_value", "reject", "msg"))

}
