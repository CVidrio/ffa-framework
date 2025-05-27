# Parameter Estimation

The FFA framework implements three methods for parameter estimation: 

1. L-moments
2. Maximum likelihood (MLE)
3. Generalized maximum likelihood (GMLE)

## L-Moments

The method estimates parameter values based on the sample L-moments $l_{1}$, $l_{2}$ and the sample L-moment ratios $t_{3}$, $t_{4}$.
For more information about L-moments, see [here](model-selection.md#an-introduction-to-l-moments).
The parameter estimation methods are based on [these](https://lib.stat.cmu.edu/general/lmoments) Fortran routines by J.R.M. Hosking. 
In particular, we use the [lmom](https://cran.r-project.org/web/packages/lmom/lmom.pdf) CRAN package, which implements the aformentioned Fotran routines.

## Maximum Likelihood (MLE)

## Generalized Maximum Likelihood (GMLE)


