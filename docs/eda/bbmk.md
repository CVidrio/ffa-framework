# BB-MK Test

The **Block Bootstrap Mann-Kendall (BB-MK) Test** is used to assess whether there is a statistically significant monotonic trend in a time series.

Unlike the MK test, the BB-MK test is insensitive to autocorrelation.

- Null hypothesis: There is no monotonic trend.
- Alternative hypothesis: There is a monotonic upwards or downwards trend.

To carry out the BB-MK test, we rely on the results of the MK test and Spearman test.

1. Compute the MK test statistic.
2. Find the least significant lag $k$ using the Spearman test.
3. Resample from the original time series in blocks of size $k+1$, without replacement.
4. Estimate the MK test statistic for each bootstrapped sample.
5. Derive the empirical distribution of the MK test statistic from the bootstrapped statistics.
6. Estimate the significance of the observed test statistic using the empirical distribution.

The code used to implement this test can be found [here](https://github.com/rileywheadon/ffa-framework/tree/master/source/eda/bbmk).
