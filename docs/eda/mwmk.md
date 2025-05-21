# MW-MK Test

The **Moving Window Mann-Kendall (MW-MK) Test** is used to identify a statistically significant monotonic trend in the variances of an AMS time series.

- Null hypothesis: There is no significant trend in the variance of the AMS.
- Alternative hypothesis: There is a significant trend in the variance of the AMS.

To compute the AMS variances we use a moving window:

1. Set the length of the moving window $w$ and the step size $s$.
2. Compute the standard deviation over indices $[1, w]$.
3. Move the window forward by $s$.
4. Check if the right boundary is beyond the end of the data. If not, go to (5).
5. Compute the standard deviation again. Return to (3).

Then, we perform the Mann-Kendall Test on the time series of variances.

For more information about the Mann-Kendall test, see [here](mk.md).

The code used to implement this test can be found [here](https://github.com/rileywheadon/ffa-framework/tree/master/source/eda/mwmk).

