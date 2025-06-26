# Parameter Estimation

The FFA framework implements three methods for parameter estimation:

1. L-moments
2. Maximum likelihood (MLE)
3. Generalized maximum likelihood (GMLE)

## L-Moments

The method estimates parameter values based on the sample L-moments $l_{1}$, $l_{2}$ and the sample L-moment ratios $t_{3}$, $t_{4}$.
For more information about L-moments, see [here](model-selection.md#an-introduction-to-l-moments).
For a information about distribution-specific parameter estimation with L-moments, see [here](distributions.md).
The parameter estimation methods used in the framework are based on [these](https://lib.stat.cmu.edu/general/lmoments) Fortran routines by J.R.M. Hosking.

**Warning**: L-moments parameter estimation can yield distributions which do not have support at small values.
This is generally not an issue, since we are only interested in the higher quantiles of the distribution.
However, it is important to remember that the probability distributions produced by L-moments *should not* be used to predict future streamflow maxima in general.

## Maximum Likelihood (MLE)

Maximum likelihood estimation aims to maximize the log-likelihood function $\ell(x : \theta)$ of the data $x = x_{1}, \dots , x_{n}$ given the parameters $\theta$.
The log-likelihood functions for each distribution are defined [here](distributions.md).
To find the optimal parameters $\hat{\theta}$, we use the [`nlminb`](https://www.rdocumentation.org/packages/stats/versions/3.6.2/topics/nlminb) function from the `stats` library.
This function implements the "L-BFGS-B" algorithm for constrained optimization.

## Generalized Maximum Likelihood (GMLE)

The generalized maximum likelihood (GMLE) parameter estimation method is used to determine the parameters of the [generalized extreme value (GEV) distribution](distributions.md#generalized-extreme-value-gev-distribution) given a prior distribution for the shape parameter $\kappa$.
This method uses [maximum a posteriori estimation](https://en.wikipedia.org/wiki/Maximum_a_posteriori_estimation), which maximizes the product of the likelihood and the prior distribution.

Suppose that $\kappa$ is drawn from a random variable $K \sim \text{Beta}(p, q)$ where $p$ and $q$ are determined using prior knowledge. 
The prior PDF $f_{K}(\kappa)$ is shown below, where $B(p, q)$ is the [Beta function](https://en.wikipedia.org/wiki/Beta_function).

$$
f_{K}(\kappa) = \frac{\kappa ^{p - 1}(1 - \kappa)^{q-1}}{B(p, q)}
$$ 

As in the case of regular maximum likelihood estimation, the likelihood function is:

$$
f_{X}(x : \mu, \sigma, \kappa) =\prod_{i=1}^{n} \frac{1}{\sigma}t_{i}^{-1 - (1/\kappa)} \exp (-t_{i}^{-1/\kappa}), \quad
t_{i} = 1 + \kappa \left(\frac{x_{i} - \mu }{\sigma } \right)
$$

As mentioned previously, we want to maximize the product $\mathcal{L} = f_{K}(\kappa)f_{X}(x:\mu ,\sigma ,\kappa)$. 
To ensure numerical stability, we will maximize $\ln  (\mathcal{L})$ instead, which has the following form:

$$
\begin{aligned}
\ln(\mathcal{L}) &= \ln(f_{K}(\kappa)) + \ln(f_{X}(x:\mu ,\sigma ,\kappa )) \\[10pt]
\ln(f_{K}(\kappa)) &= (p - 1)\ln \kappa + (q-1) \ln (1 - \kappa)  - \ln (B(p, q)) \\[5pt]
\ln(f_{X}(x:\mu ,\sigma ,\kappa )) &= \sum_{i=1}^{n} \left[-\ln \sigma - \left(1 + \frac{1}{\kappa }\right) \ln t_{i} - t_{i}^{-1/\kappa}\right]
\end{aligned}
$$
