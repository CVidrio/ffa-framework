# Meeting

Access to datasets from ["The decomposition-based nonstationary flood frequency analysis"](https://doi.org/10.1016/j.jhydrol.2022.128186) for further testing.

## Identifying Change Points

When we run the framework on dataset 2, I'm concerned that users might choose to split on both the 1972 and 1985 change points. 
This would not be ideal, since only a single split is necessary to account for the inhomogeneity.

### Proposed Changes

I think that we should structure the change point section as follows:

- Look for abrupt changes with the Pettitt test.
- Show the user the plot and ask them if they would like to split.
- Check all of the homogeneous datasets for trend changes with the MKS test.
- Show the user plots and ask them again if they would like to split.

## Identifying Trends in the Mean

Consider a statistical time series model: $y_{t} = \rho y_{t-1} + \epsilon_{t}$.

- If $\rho = 0$, there is *no serial correlation*.
- If $\rho > 0$, there is *serial correlation*.
- If $\rho = 1$, there is a *unit root* (what the PP and KPSS tests look for).
- If $\rho > 1$, the time series is *explosive* (this is physically impossible).

Therefore all processes with a unit root will exhibit serial correlation. 
However, not all serially correlated time series will have a unit root.

### Proposed Changes

If there is a significant trend and no serial correlation, *there is also no unit root*.
Therefore, if the Spearman test failts to reject, we should compute Sen's trend estimator and return results to the user without applying the PP/KPSS tests. 

If there is a significant trend *and* serial correlation, it is possible we have a unit root.
When performing the PP/KPSS tests we should use the drift + trend version (Type 3), *because we already identified a monotonic trend*.

R Documentation:

- https://www.rdocumentation.org/packages/aTSA/versions/3.1.2.1/topics/pp.test
- https://www.rdocumentation.org/packages/aTSA/versions/3.1.2.1/topics/kpss.test

We will use *short lag* since hydrological time series typically have minimal autocorrelation (right?).
The current MATLAB version uses 0 lags, which is not recommended. See the "Tips" section of the MALTAB documentation:

- https://www.mathworks.com/help/econ/pptest.html
- https://www.mathworks.com/help/econ/kpsstest.html

**Remark**: Intuitively, it seems *highly unlikely* that AMS data would have a unit root. 
This would imply that shocks (like floods or droughts) *permanently alter* the streamflow in subsequent years.

