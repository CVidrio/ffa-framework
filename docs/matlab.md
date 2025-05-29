This page documents changes from [original MATLAB code](https://zenodo.org/records/8012096).

## General

- All configuration details are now stored in YAML files.
- Implement a suite of unit tests using the `testthat` library.
- Use `knitr` and `rmarkdown` to generate reports with text, equations, and images.
- Export reports to `.md` (Pandoc) and `.html`.
- Run individual statistical tests using `run-stats.R`.

## Exploratory Data Analysis (EDA)

### Bug Fixes

- Only show statistically significant change points for the Pettitt and MKS tests.
- Fix bug where the Pettitt test computed the number of data points *before* removing NaN values.
- Fix bug where the MKS test would only identify one change point, even if multiple change points were foudn to be above the threshold for statistical significance.
- Remove unnecessary rounding in the moving window algorithm for AMS variability.
- Fix bug where the Phillips-Perron and KPSS tests failed to account for drift and trend.
- Fix bug where the Phillips-Perron and KPSS tests failed to account for serial correlation.

### Framework Changes

- If serial correlation is identified, do not run the Phillips-Perron and KPSS tests.
- Implement the Runs test to detect nonlinearity after fitting Sen's trend estimator.
- Run change point detection in multiple stages.

## Flood Frequency Analysis (FFA)

### Bug Fixes

- L-moments parameter estimation for GEV/GPA distributions has an unnecessary sign change.

### Framework Changes

Parameterization of the PE3/LP3 distributions fails for some datasets because MATLAB is unable to handle the large numbers created by the gamma function. To manage this issue, the MATLAB version used the conventional moments (i.e. sample mean/variance/skewness) when this occurred. This behaviour is no longer necessary and has been removed.

The procedure for computing the Z-statistic selection metric has been changed slightly. In the MATLAB version, kappa and log-kappa distributions were fitted to the data. Then, two bootstrap samples were generated, one from the kappa distribution and one from the log-kappa distribution. In the new version, we do not fit the log-kappa distribution and use a *single* bootstrap sample to compute the sample L-moments and log-L-moments. We do this for three reasons:

1. Consistency with the other metrics, which do not use the L-moments for the log-normal/log-pearson distributions. Instead, they use the fact that under the log-normal/log-pearson models, the log-transformed data has the same L-moments as the normal/pearson distributions.
2. It is hard to estimate the parameters of the log-kappa distribution from L-moments.
3. By taking less bootstrap samples, we improve the speed of our code.

