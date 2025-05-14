# Improvements

## Code

### Complete

- Specify all configuration details in a single `config.yml` file.
- Plotting: Only show significant change points for pettitt and MKS tests.
- Add the option to run statistical tests individually using the `run-stats.R` function.
- Implement the Wald-Wolfowitz runs test for detecting irregularities in residuals.
- Develop a suite of unit tests using the `testthat` library.

### Proposed

- Use `knitr` and `rmarkdown` to generate reports with both text and images.
- Embed test statistics, mathematical equations, and code directly into reports.

## Bugs

- Pettitt test computes the number of data points *before* removing NaN values, resulting in artificially high p-values.
- MKS test computes the p-value based on the maximum value of the progressive series instead of the maximum p-value of an intersection point (scripts only, not in the binary).
- The MKS test only identifies one change point, even if multiple crossings are above the threshold for statistical significance.
- The moving window algorithm for AMS variability rounds the mean year in the window.
