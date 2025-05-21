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

TBD
