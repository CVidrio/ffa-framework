# Uncertainty Quantification

The FFA framework implements three methods for uncertainty quantification: 

1. Sample bootstrap
2. Regula-Falsi profile likelihood (RFPL)
2. Regula-Falsi generalized profile likelihood (RFGPL)

## Sample Bootstrap

The sample bootstrap is a flexible method for uncertainty quantification that works with all probability models and parameter estimation methods. Let $n$ be the size of the original dataset.

1. Draw $N_{\text{sim}}$ bootstrap samples of size $n$ from the selected probability distribution.
2. Fit a probability distribution to each bootstrap sample. For consistency, we use the same [model selection method](model-selection.md) and [parameter estimation method](parameter-estimation.md) as before.
3. Compute the quantiles for each of the bootstrapped distributions. 
4. Generate confidence intervals using the mean and variance of the bootstrapped quantiles .

## Regula-Falsi Profile Likelihood (RFPL)

Consider a statistical model with parameters $(\theta, \psi_{1}, \dots, \psi_{n})$.
The **Profile Likelihood** for the scalar parameter $\theta$ and vector of nuisance parameters $\psi$ is defined as:

$$
\ell_{p}(\theta) = \max_{\psi } \ell(\theta , \psi)
$$ 

Let $\hat{\theta}$ be MLE of $\theta$.
To find a confidence interval with significance $1-\alpha$, we find the two solutions to the following equation (where $\chi_{1;1-\alpha}^2$ is the $1-\alpha$ quantile of the [Chi-squared distribution](https://en.wikipedia.org/wiki/Chi-squared_distribution)):

$$
2[\ell_{p}(\hat{\theta }) - \ell_{p}(\theta )] = \chi_{1;1-\alpha }^2
$$ 

This is equivalent to finding the two points $\theta_{L} < \hat{\theta} < \theta_{U}$ such that the profile log-likelihood has dropped by $\chi _{1;1-\alpha }^2 / 2$.
To find $\theta_{L}$ and $\theta_{U}$ we find the roots of $f(\theta)$ using a secant-based algorithm.

$$
f(\theta) = \ell_{p}(\theta) - \left[\ell_{p}(\hat{\theta}) - \frac{\chi_{1;1-\alpha }^2}{2}\right]
$$ 

For the FFA framework, we use the constant location parameter $\mu$ (or $\mu_{0}$ for non-stationary models) to compute the profile likelihood. 
The other parameters are considered nuisance parameters.
For a list of statistical models and their parameters, see [here](parameter-estimation.md#maximum-likelihood-mle).

### Initialization Algorithm

First, we need to identify the initial bounds for $\mu$. This involves:

- Finding a lower bound $\mu^{-} < \hat{\mu}$ such that $f(\mu^{-}) < 0 < f(\hat{\mu})$.
- Finding an upper bound $\mu^{+} > \hat{\mu}$ such that $f(\mu^{+}) < 0 < f(\hat{\mu})$.

To find the bounds, initialize $\mu^{*} = (1 \pm 0.05)\hat{\mu}$, depending on whether we are looking for the upper/lower bound. 
Then, compute the profile likelihood and $f(\mu^{*})$. 

- If $f(\mu^{*}) < 0$ we have found an upper/lower bound.
- Otherwise, iteratively set $\mu^{*} = (1 \pm 0.05)\mu^{*}$ until $f(\mu^{*}) < 0$.

Then, we assign the following variables:

- For the lower bound, set $a = \mu^{-}$ and $b = \hat{\mu}$.
- For the upper bound, set $a = \hat{\mu}$ and $b = \mu^{+}$.

### Iteration Algorithm

Compute the following:

$$
c = \frac{af(b) - bf(a)}{f(b) - f(a)}
$$ 

Evaluate $\ell_{p}(c)$ by maximizing over the nuisance parameters $\psi$, then find $f(c)$.

If $|f(c)| < \epsilon$ (where $\epsilon$ is small), then stop. $c$ is the confidence interval bound.

Otherwise, assign $a = c$ if $f(c) < 0$ and $b = c$ if $f(c) > 0$.

## Regula-Falsi Generalized Profile Likelihood (RFGPL)
