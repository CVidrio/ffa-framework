This page documents changes from [original MATLAB code](https://zenodo.org/records/8012096).

## General

- All configuration details are now stored in YAML files.
- Implement a suite of unit tests using the `testthat` library.
- Use `knitr` and `rmarkdown` to generate reports with text, equations, and images.
- Export reports to `.md` (Pandoc) and `.html`.
- Run individual statistical tests using `run-stats.R`.

## Exploratory Data Analysis (EDA)

### Bug Fixes

- Only show statistically significant change points for the Pettitt and MKS plots.
- Fix bug where the MKS test would only identify one change point, even if multiple change points were found to be above the threshold for statistical significance.
- Fix major bug where the MKS test identified change points based on the progressive series instead of the U-statistics of the crossing points.
- Remove unnecessary rounding in the moving window algorithm for AMS variability.
- Fix bug where the Phillips-Perron and KPSS tests failed to account for drift and trend.
- Fix bug where the Phillips-Perron and KPSS tests failed to account for serial correlation.

### Framework Changes

- If serial correlation is identified, do not run the Phillips-Perron and KPSS tests.
- Implement the Runs test to detect nonlinearity after fitting Sen's trend estimator.
- Run change point detection in multiple stages.

## Flood Frequency Analysis (FFA)

### Bug Fixes

- Implement the RFPL uncertainty quantification with the Weibull distribution.

### Distribution Changes

The generalized pareto (GPA) distribution has been removed, since its likelihood function is not amenable to maximum likelihood estimation.
This issue occurs because the GPA distribution is used in peaks over threshold modelling, which we have not yet implemented.

The R version uses the three parameter Weibull distribution (with location, scale, and shape) parameters instead of the two parameter Weibull distribution (with scale and shape parameters).
This ensures consistency with the other distributions, which all have location parameters.

The quantile function for the Pearson Type III (PE3) distribution does not have a closed form.
The `quape3` function, which computes the quantiles of the PE3 distribution in the R version, uses a different approximate formula than the MATLAB version.
Therefore, quantiles for the PE3 distribution may vary by up to $1\%$ between the R version and MATLAB versions.

### Model Selection Changes

The L-distance and L-kurtosis selection methods have been improved by using an optimization algorithm to find the parameters with the closest L-moments to the data instead of using a brute force approach. This is more computational efficient and elegant (but has no significant effect on the results).

The procedure for computing the Z-statistic selection metric has been changed.
If the L-moments of the dataset do not satisfy $\tau_{4} \leq (1 + 5\tau _{3}^2)/6$, then the Kappa distribution will not be fitted and the candidate distributions that use the dataset will be omitted.

### Parameter Estimation Changes

Parameterization of the PE3/LP3 distributions fails for some datasets because MATLAB is unable to handle the large numbers created by the gamma function.
To manage this issue, the MATLAB version used the conventional moments (i.e. sample mean/variance/skewness) when this occurred.
This behaviour is no longer necessary and has been removed.

The R implementation uses L-BFGS-B for MLE/GMLE parameter estimation instead of Nelder-Mead, since the gradient is well defined for the likelihood functions we are working with.
Additionally, the L-BFGS-B method makes it possible to assign bounds to the variables.
This modification produced slight improvements to the MLE/GMLE for some datasets.

### Model Assessment Changes

Use the built-in R function `approx()` to perform log-linear interpolation of the return periods.
The MATLAB implementation uses a hard-coded algorithm which behaves unpredictably when the original and interpolated $x$-values are equal.
